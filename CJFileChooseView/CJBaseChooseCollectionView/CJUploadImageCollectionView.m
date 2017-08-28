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

@interface CJUploadImageCollectionView () {
    
}
@property (nonatomic, strong) NSMutableArray *dataModels;

@end

@implementation CJUploadImageCollectionView

- (void)commonInit {
    [super commonInit];
    
    
    self.dataModels = [[NSMutableArray alloc] init];
    /*
    {
        CJImageUploadItem *item = [[CJImageUploadItem alloc] init];
        item.image = [UIImage imageNamed:@"CJAvatar.png"];
        [self.dataModels addObject:item];
    }
    */
    self.extralItemSetting = CJExtralItemSettingTailing;
                                                       
                                                       
    self.currentDataModelCount = [self.dataModels count];
    
    //以下值必须二选一设置（默认cellWidthFromFixedWidth设置后，另外一个自动失效）
    self.cellWidthFromPerRowMaxShowCount = 4;
    //self.cellWidthFromFixedWidth = 50;
    
    //以下值，可选设置
    //self.collectionViewCellHeight = 30;
    //self.maxDataModelCount = 5;
    self.maxDataModelCount = 5; //MAXFLOAT
    
    self.allowsMultipleSelection = YES; //是否打开多选
    
    
    
    CJUploadCollectionViewCell *registerCell = [[CJUploadCollectionViewCell alloc] init];
    
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:CJUploadCollectionViewCellID];
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:CJUploadCollectionViewCellAddID];
    
    /*
    CJFullBottomCollectionViewCell *registerCell = [[CJFullBottomCollectionViewCell alloc] init];
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:@"cell"];
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:@"addCell"];
    */
    
    __weak typeof(self)weakSelf = self;
    
    [self configureDataCellBlock:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        
        /*
        CJFullBottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        */
        CJUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJUploadCollectionViewCellID forIndexPath:indexPath];
        [self operateCell:cell withDataModelIndexPath:indexPath isSettingOperate:YES];
        
        [self uploadCell:cell inCollectionView:collectionView withDataModelIndexPath:indexPath]; //上传操作
        
        return cell;
        
    } configureExtraCellBlock:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        /*
        CJFullBottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
        */
        CJUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJUploadCollectionViewCellAddID forIndexPath:indexPath];
        
        cell.cjImageView.image = [UIImage imageNamed:@"cjCollectionViewCellAdd"];
        [cell.cjDeleteButton setImage:nil forState:UIControlStateNormal];
        
        return cell;
    }];
    
    
    [self didTapDataItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        NSLog(@"当前点击的Item为数据源中的第%ld个", indexPath.item);
        /*
        if (collectionView.allowsMultipleSelection == NO) {
            NSArray *oldSelectedIndexPaths = weakSelf.equalCellSizeCollectionView.currentSelectedIndexPaths;
            if (oldSelectedIndexPaths.count > 0) {
                NSIndexPath *oldSelectedIndexPath = oldSelectedIndexPaths[0];
                
                CJFullBottomCollectionViewCell *oldCell = (CJFullBottomCollectionViewCell *)[collectionView cellForItemAtIndexPath:oldSelectedIndexPath];//是oldSelectedIndexPath不要写成indexPath了
                [self operateCell:oldCell withDataModelIndexPath:oldSelectedIndexPath isSettingOperate:NO];
            }
        }
        
        NSArray *currentSelectedIndexPaths = [self.equalCellSizeCollectionView indexPathsForSelectedItems];
        weakSelf.equalCellSizeCollectionView.currentSelectedIndexPaths = currentSelectedIndexPaths;
        NSLog(@"currentSelectedIndexPaths = %@", currentSelectedIndexPaths);
        
        CJFullBottomCollectionViewCell *cell = (CJFullBottomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self operateCell:cell withDataModelIndexPath:indexPath isSettingOperate:NO];
        */
        
        CJBaseUploadItem *baseUploadItem = [self.dataModels objectAtIndex:indexPath.row];
        
        CJUploadInfo *uploadInfo = baseUploadItem.uploadInfo;
        if (uploadInfo.uploadState == CJUploadStateFailure) {
            return;
        }
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [weakSelf didSelectMediaUploadItemAtIndexPath:indexPath];
        
    } didTapExtraItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        NSLog(@"点击额外的item");
        
        [weakSelf addMediaUploadItemAction];
    }];
}


- (id)getDataModelAtIndexPath:(NSIndexPath *)indexPath {
    /* 从数据源中获取每个indexPath要用什么dataModel来赋值 */
    id dataModle = nil;
    switch (self.extralItemSetting) {
            case CJExtralItemSettingLeading:
        {
            dataModle = [self.dataModels objectAtIndex:indexPath.item-1];
            break;
        }
            case CJExtralItemSettingTailing:
            case CJExtralItemSettingNone:
        default:
        {
            dataModle = [self.dataModels objectAtIndex:indexPath.item];
            break;
        }
    }
    
    /*
    NSString *stringDataModle = (NSString *)dataModle;
    return stringDataModle;
    */
    
    CJImageUploadItem *baseUploadItem = (CJImageUploadItem *)dataModle;
    baseUploadItem.indexPath = indexPath;
    return baseUploadItem;
}

/**
 *  设置或者更新Cell
 *
 *  @param cell             要设置或者更新的Cell
 *  @param indexPath        用于获取数据的indexPath(此值一般情况下与cell的indexPath相等)
 *  @param isSettingOperate 是否是设置，如果否则为更新
 */
- (void)operateCell:(CJUploadCollectionViewCell *)cell withDataModelIndexPath:(NSIndexPath *)indexPath isSettingOperate:(BOOL)isSettingOperate {
    
    if (isSettingOperate) {
        /* 从数据源中获取每个indexPath要用什么dataModel来赋值 */
        /*
        NSString *dataModel = [self getDataModelAtIndexPath:indexPath];
        cell.cjTextLabel.text = dataModel;
        */
    }
    CJImageUploadItem *dataModel = [self getDataModelAtIndexPath:indexPath];
    
    cell.cjImageView.image = [UIImage imageNamed:@"icon"];
    if (cell.selected) {
        cell.cjImageView.image = [UIImage imageNamed:@"cjCollectionViewCellAdd"];
        cell.backgroundColor = [UIColor blueColor];
    } else {
        cell.cjImageView.image = dataModel.image;
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)uploadCell:(CJUploadCollectionViewCell *)cell inCollectionView:(UICollectionView *)collectionView withDataModelIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    
    CJImageUploadItem *baseUploadItem = [self getDataModelAtIndexPath:indexPath];
    
    NSArray<CJUploadItemModel *> *uploadItemModels = baseUploadItem.uploadItems;
    [cell uploadItems:uploadItemModels toWhere:weakSelf.useToUploadItemToWhere uploadInfoSaveInItem:baseUploadItem uploadInfoChangeBlock:^(CJBaseUploadItem *item) {
        CJImageUploadItem *imageItem = (CJImageUploadItem *)item;
        CJUploadCollectionViewCell *myCell = (CJUploadCollectionViewCell *)[weakSelf cellForItemAtIndexPath:imageItem.indexPath];
        CJUploadInfo *uploadInfo = item.uploadInfo;
        [myCell.uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];
    }];
    
    
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
    
    if (self.dataModels.count >= self.maxDataModelCount) {
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
    vc.maxCount = self.maxDataModelCount - self.dataModels.count;
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
        self.currentDataModelCount = [self.dataModels count]; //TODO:重要不要落下了
        
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
        CJUploadInfo *uploadInfo = uploadItem.uploadInfo;
        if (uploadInfo.uploadState == CJUploadStateFailure) {
            NSLog(@"Failure:请等待所有附件上传完成");
            return NO;
        }
    }
    return YES;
}

@end
