//
//  ImagePickerViewController.m
//  CJPickerDemo
//
//  Created by 李超前 on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "UIImagePickerControllerUtil.h"

#import <JGActionSheet/JGActionSheet.h>
#import <CJFMDBFileManager/CJFileManager.h>

#import "CJUploadItemModel.h"
#import "CJImageUploadItem.h"
#import "MJImagePickerVC.h"

#import "IjinbuNetworkClient+Login.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"图片选择", nil);
    
    
    self.uploadImageCollectionView.belongToViewController = self;
    self.uploadImageCollectionView.useToUploadItemToWhere = 0;
    self.uploadImageCollectionView.mediaType = CJMediaTypeImage;
    self.uploadImageCollectionView.maxDataModelShowCount = 5;
    
//    __weak typeof(self)weakSelf = self;
    [self.uploadImageCollectionView setPickImageCompleteBlock:^{
        //[weakSelf.uploadImageCollectionView reloadData];
    }];
    
    [[IjinbuNetworkClient sharedInstance] requestijinbuLogin_name:@"18020721201" pasd:@"123456" success:^(IjinbuResponseModel *responseModel) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)pickImageAction:(id)sender {
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
    [sheet showInView:self.view animated:YES];
}

/**< 拍照 */
- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //NSArray<NSString *> *mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    
    UIImagePickerControllerUtil *imagePickerControllerUtil = [UIImagePickerControllerUtil sharedInstance];
    imagePickerControllerUtil.saveLocation = CJSaveLocationNone;
    
    UIImagePickerController *imagePickerController =
    [imagePickerControllerUtil createWithSourceType:sourceType isVideo:NO pickImageFinishBlock:^(UIImage *image) {
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
//         [self.dataModels addObject:imageItem];
//         
//         [self reloadData];
    } pickVideoFinishBlock:^(UIImage *firstImage) {
        
    } pickCancelBlock:^{
        
    }];
    
    if (imagePickerController) {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}


/**< 从相册中选择照片 */
- (void)choosePhoto {
    //*
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //NSArray<NSString *> *mediaTypes = @[(NSString *)kUTTypeImage];
    
    UIImagePickerControllerUtil *imagePickerControllerUtil = [UIImagePickerControllerUtil sharedInstance];
    imagePickerControllerUtil.saveLocation = CJSaveLocationNone;
    
    UIImagePickerController *imagePickerController =
    [imagePickerControllerUtil createWithSourceType:sourceType isVideo:NO pickImageFinishBlock:^(UIImage *image)
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
         
//         [self.dataModels addObject:imageItem];
//         
//         [self reloadData];
//         if (self.pickImageCompleteBlock) {
//             self.pickImageCompleteBlock();
//         }
         
     } pickVideoFinishBlock:nil pickCancelBlock:^{
         
     }];
     //*/
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
