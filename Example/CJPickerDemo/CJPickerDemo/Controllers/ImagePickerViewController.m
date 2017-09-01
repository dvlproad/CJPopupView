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
#import "CJImagePickerViewController.h"

//#import "IjinbuNetworkClient+Login.h"

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
    
//    [[IjinbuNetworkClient sharedInstance] requestijinbuLogin_name:@"15800000007" pasd:@"123456" success:^(IjinbuResponseModel *responseModel) {
//        NSLog(@"登录成功");
//    } failure:^(NSError *error) {
//        NSLog(@"登录失败");
//        [SVProgressHUD showErrorWithStatus:@"登录失败"];
//    }];
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
        
        [self finishChooseImage:image];
        
    } pickVideoFinishBlock:^(UIImage *firstImage) {
        
    } pickCancelBlock:^{
        
    }];
    
    if (imagePickerController) {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}

///通过 "拍照" 和 "从手机相册选择" 两种方式选择到图片后
- (void)finishChooseImage:(UIImage *)image {
    NSMutableArray<CJUploadItemModel *> *uploadModels = [[NSMutableArray alloc] init];
    CJUploadItemModel *imageUploadModel = [self saveImageToLocal:image];
    [uploadModels addObject:imageUploadModel];
    
//    CJImageUploadItem *imageItem =
//    [[CJImageUploadItem alloc] initWithShowImage:image
//                          imageLocalRelativePath:imageRelativePath
//                                     uploadItems:uploadModels];
    
    //         [self.dataModels addObject:imageItem];
    //
    //         [self reloadData];
    //         if (self.pickImageCompleteBlock) {
    //             self.pickImageCompleteBlock();
    //         }
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
         [self finishChooseImage:image];
         
     } pickVideoFinishBlock:nil pickCancelBlock:^{
         
     }];
     //*/
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


/**< 保存图片到本地 */
- (CJUploadItemModel *)saveImageToLocal:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    //文件名
    NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *imageName = [identifier stringByAppendingPathExtension:@"jpg"];
    
    NSString *imageRelativePath = [CJFileManager saveFileData:imageData
                                                withFileName:imageName
                                          inSubDirectoryPath:@"UploadImage"
                                         searchPathDirectory:NSCachesDirectory];
    
    CJUploadItemModel *imageUploadModel = [[CJUploadItemModel alloc] init];
    imageUploadModel.uploadItemType = CJUploadItemTypeImage;
    imageUploadModel.uploadItemData = imageData;
    imageUploadModel.uploadItemName = imageName;
    
    return imageUploadModel;
}

///开始上传/继续上传没上传完的
- (IBAction)uploadUnFinishImageModel:(id)sender {
    NSLog(@"对collectionView，开始上传/继续上传没上传完的");
}


- (IBAction)reloadCollectionView:(id)sender {
    [self.uploadImageCollectionView reloadData];
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
