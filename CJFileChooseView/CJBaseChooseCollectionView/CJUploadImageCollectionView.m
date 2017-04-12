//
//  CJUploadImageCollectionView.m
//  FileChooseViewDemo
//
//  Created by 李超前 on 2017/1/19.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJUploadImageCollectionView.h"
#import "CJUploadCollectionViewCell+configureForSpecificUploadItem.h"

#import <JGActionSheet/JGActionSheet.h>

//#import <TRMJPhotoBrowser/MJPhotoBrowser.h>
//#import <TRMJPhotoBrowser/MJPhoto.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import <MediaPlayer/MediaPlayer.h>

#import "UIImage+Helper.h"

//#import "NetworkClient+CJUploadFile.h"

#import "UIImagePickerControllerUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <CJFMDBFileManager/CJFileManager.h>
#import <CJBaseUIKit/UIColor+CJHex.h>


static NSString *CJUploadCollectionViewCellID = @"CJUploadCollectionViewCell";
static NSString *CJUploadCollectionViewCellAddID = @"CJUploadCollectionViewCellAdd";

@implementation CJUploadImageCollectionView

- (void)commonInit {
    [super commonInit];
    
//    self.dataModels = [[NSMutableArray alloc] init];
    self.maxDataModelShowCount = 5;
    self.showExtraItem = YES;
    self.maxShowCountPerRow = 4;
    
    CJUploadCollectionViewCell *cell = [[CJUploadCollectionViewCell alloc] init];
    
    [self registerClass:[cell class] forCellWithReuseIdentifier:CJUploadCollectionViewCellID];
    [self registerClass:[cell class] forCellWithReuseIdentifier:CJUploadCollectionViewCellAddID];
    
    
    __weak typeof(self)weakSelf = self;
    [self setupConfigureDataCellBlock:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        CJUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJUploadCollectionViewCellID forIndexPath:indexPath];
        CJImageUploadItem *baseUploadItem = [weakSelf.dataModels objectAtIndex:indexPath.row];
        baseUploadItem.indexPath = indexPath;
        
        [cell configureForImageUploadItem:baseUploadItem andUploadToWhere:weakSelf.useToUploadItemToWhere requestBlock:^(CJImageUploadItem *item) {
            CJUploadCollectionViewCell *myCell = (CJUploadCollectionViewCell *)[weakSelf cellForItemAtIndexPath:item.indexPath];
            [myCell updateProgressText:item.uploadStatePromptText progressVaule:item.progressValue];
        }];

        
        __weak typeof(self)weakSelf = self;
        [cell setDeleteHandle:^(CJBaseCollectionViewCell *baseCell) {
            if (baseUploadItem.operation) {
                [baseUploadItem.operation cancel];
            }
            NSIndexPath *indexPath = [collectionView indexPathForCell:baseCell];
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.dataModels removeObjectAtIndex:indexPath.item];
            NSInteger currentCount = strongSelf.dataModels.count;
            NSInteger oldCount = [strongSelf numberOfItemsInSection:0];
            NSLog(@"currentCount = %ld, oldCount = %ld", currentCount, oldCount);
            if (currentCount == oldCount) {
                [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            } else {
                [collectionView reloadData];
            }
        }];
        
        return cell;
        
    } configureExtraCellBlock:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        CJUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJUploadCollectionViewCellAddID forIndexPath:indexPath];
        [cell.cjDeleteButton setImage:nil forState:UIControlStateNormal];
        
        return cell;
        
    } didSelectDataItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        CJBaseUploadItem *baseUploadItem = [self.dataModels objectAtIndex:indexPath.row];
        if (baseUploadItem.uploadState == CJUploadStateFailure) {
            return;
        }
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [weakSelf didSelectMediaUploadItemAtIndexPath:indexPath];
        
    } didSelectExtraItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        
        [weakSelf addMediaUploadItemAction];
    }];
}


- (void)didSelectMediaUploadItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectMediaUploadItemAtIndexPath");
    
    if (self.mediaType == CJMediaTypeVideo) {
        CJImageUploadItem *imageUploadItem = [self.dataModels objectAtIndex:indexPath.row];
        NSString *localPath = [NSHomeDirectory() stringByAppendingPathComponent:imageUploadItem.localRelativePath];
        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self.belongToViewController presentMoviePlayerViewControllerAnimated:moviePlayerController];
        
    } else {
        for (CJImageUploadItem *imageUploadItem in self.dataModels) {
            UIImage *image = imageUploadItem.image;
            if (image == nil) {
                image = nil;    //试着从本地种查找
            }
            
        }
    }
}

- (void)addMediaUploadItemAction {
    NSAssert(self.belongToViewController != nil, @"未设置CJUploadCollectionView的belongToViewController");
    
    if (self.dataModels.count >= self.maxDataModelShowCount) {
        //[UIGlobal showMessage:@"图片数量已达上限"];
        NSLog(@"所选媒体数量已达上限");
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (self.mediaType == CJMediaTypeVideo) {
        [self addVideoUploadItemAction];
        
    } else {
        [self addImageUploadItemAction];
    }
}

#pragma mark - 视频选择
- (void)addVideoUploadItemAction {
    if (self.pickVideoHandle) {
        self.pickVideoHandle();
    } else {
        NSLog(@"未操作视频选择");
    }
}



#pragma mark - 图片选择
- (void)addImageUploadItemAction {
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"拍照", @"从手机相册选择"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel];
    NSArray *sections = @[section1, cancelSection];
    
    __weak typeof(self)weakSelf = self;
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0) {   //拍照
                [weakSelf takePhoto];
                
            } else {
                [weakSelf choosePhoto];
            }
        }
        [sheet dismissAnimated:YES];
    }];
    [sheet setOutsidePressBlock:^(JGActionSheet *sheet){
        [sheet dismissAnimated:YES];
    }];
    
    NSAssert(self.belongToViewController != nil, @"所属控制器不能为空，请先设置");
    [sheet showInView:self.belongToViewController.view animated:YES];
}

/**< 拍照 */
- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //NSArray<NSString *> *mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    
    UIImagePickerControllerUtil *imagePickerControllerUtil = [UIImagePickerControllerUtil sharedInstance];
    imagePickerControllerUtil.saveLocation = CJSaveLocationNone;
    
    UIImagePickerController *imagePickerController =
    [imagePickerControllerUtil createWithSourceType:sourceType isVideo:NO pickImageFinishBlock:^(UIImage *image)
     {
         NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
         
         //文件名
         NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
         NSString *imageName = [identifier stringByAppendingPathExtension:@"jpg"];
         
         NSString *imageRelativePath = [CJFileManager saveFileData:imageData
                                                     withFileName:imageName
                                               inSubDirectoryPath:@"UploadImage"
                                              searchPathDirectory:NSCachesDirectory];
         
         
         NSMutableArray<CJUploadItemModel *> *uploadItems = [[NSMutableArray alloc] init];
         //NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
         //图片
         //NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
         //NSString *imageName = [identifier stringByAppendingPathExtension:@"jpg"];
         CJUploadItemModel *imageUploadItem = [[CJUploadItemModel alloc] init];
         imageUploadItem.uploadItemType = CJUploadItemTypeImage;
         imageUploadItem.uploadItemData = imageData;
         imageUploadItem.uploadItemName = imageName;
         [uploadItems addObject:imageUploadItem];
         
         CJImageUploadItem *imageItem =
                [[CJImageUploadItem alloc] initWithShowImage:image
                                      imageLocalRelativePath:imageRelativePath
                                                 uploadItems:uploadItems];
         [self.dataModels addObject:imageItem];
         
         [self reloadData];
         
     } pickVideoFinishBlock:nil pickCancelBlock:^{
         
     }];
    
    if (imagePickerController) {
        [self.belongToViewController presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}


/**< 从相册中选择照片 */
- (void)choosePhoto {
    /*
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //NSArray<NSString *> *mediaTypes = @[(NSString *)kUTTypeImage];
    
    UIImagePickerControllerUtil *imagePickerControllerUtil = [UIImagePickerControllerUtil sharedInstance];
    imagePickerControllerUtil.saveLocation = CJSaveLocationNone;
    [imagePickerControllerUtil openImagePickerControllerWithSourceType:sourceType isVideo:NO inViewController:self.belongToViewController pickImageFinishBlock:^(UIImage *image)
     {
         NSString *imageRelativePath = [self saveImageToLocal:image];
         
         NSMutableArray<CJUploadItemModel *> *uploadModels = [[NSMutableArray alloc] init];
         NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
         //图片
         NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
         NSString *imageName = [identifier stringByAppendingPathExtension:@"jpg"];
         CJUploadItemModel *imageUploadModel = [[CJUploadItemModel alloc] init];
         imageUploadModel.uploadItemType = CJUploadItemTypeImage;
         imageUploadModel.uploadItemData = imageData;
         imageUploadModel.uploadItemName = imageName;
         [uploadModels addObject:imageUploadModel];
         
         CJImageUploadItem *imageItem =
         [[CJImageUploadItem alloc] initWithShowImage:image
                               imageLocalRelativePath:imageRelativePath
                                          uploadItems:uploadModels];
         
         [self.dataModels addObject:imageItem];
         
         [self reloadData];
         if (self.pickImageCompleteBlock) {
             self.pickImageCompleteBlock();
         }
         
     } pickVideoFinishBlock:nil pickCancelBlock:^{
         
     }];
    return;
    */
    
    MJImagePickerVC * vc = [[MJImagePickerVC alloc] init];
    vc.maxCount = self.maxDataModelShowCount - self.dataModels.count;
    vc.callback = ^(NSArray * array){
        for (NSInteger i = 0; i < array.count; i++) {
            MJImageItem *item = array[i];
            UIImage *image = item.image;
            
            NSString *imageRelativePath = [self saveImageToLocal:image];
            
            NSMutableArray<CJUploadItemModel *> *uploadModels = [[NSMutableArray alloc] init];
            NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
            //图片
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            NSString *imageName = [identifier stringByAppendingPathExtension:@"jpg"];
            CJUploadItemModel *imageUploadModel = [[CJUploadItemModel alloc] init];
            imageUploadModel.uploadItemType = CJUploadItemTypeImage;
            imageUploadModel.uploadItemData = imageData;
            imageUploadModel.uploadItemName = imageName;
            [uploadModels addObject:imageUploadModel];
            
            CJImageUploadItem *imageItem =
                    [[CJImageUploadItem alloc] initWithShowImage:image
                                          imageLocalRelativePath:imageRelativePath
                                                     uploadItems:uploadModels];
            [self.dataModels addObject:imageItem];
        }
        
        [self reloadData];
        if (self.pickImageCompleteBlock) {
            self.pickImageCompleteBlock();
        }
    };
    
    UIColor *blueTextColor = [UIColor cjColorWithHexString:@"#68c2f4"];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:blueTextColor}];
    nav.navigationBar.tintColor = blueTextColor;
    
    [self.belongToViewController presentViewController:nav animated:YES completion:NULL];
}


/**< 保存图片到本地 */
- (NSString *)saveImageToLocal:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    //文件名
    NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *fileName = [identifier stringByAppendingPathExtension:@"jpg"];
    
    NSString *fileRelativePath = [CJFileManager saveFileData:imageData
                                                withFileName:fileName
                                          inSubDirectoryPath:@"UploadImage"
                                         searchPathDirectory:NSCachesDirectory];
    
    return fileRelativePath;
}

- (void)deletePhoto:(NSInteger)index
{
    if (self.dataModels.count > index) {
        [self.dataModels removeObjectAtIndex:index];
        [self reloadData];
    }
}


- (BOOL)isAllUploadFinish {
    for (CJBaseUploadItem *uploadItem in self.dataModels) {
        if (uploadItem.uploadState == CJUploadStateFailure) {
            NSLog(@"Failure:请等待所有附件上传完成");
            return NO;
        }
    }
    return YES;
}

@end
