//
//  ImagePickerViewController.m
//  CJPickerDemo
//
//  Created by 李超前 on 2017/3/31.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "CJValidateAuthorizationUtil.h"
#import "MySingleImagePickerController.h"

#import <JGActionSheet/JGActionSheet.h>
#import <CJFile/CJFileManager+SaveFileData.h>

#import "CJUploadItemModel.h"
#import "CJImagePickerViewController.h"

//#import "IjinbuNetworkClient+Login.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"图片选择", nil);
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
    BOOL isCameraEnable = [CJValidateAuthorizationUtil checkEnableForDeviceComponentType:CJDeviceComponentTypeCamera inViewController:self];
    if (!isCameraEnable) {
        return;
    }
    
    MySingleImagePickerController *singleImagePickerController = [[MySingleImagePickerController alloc] init];
    [singleImagePickerController setSingleMediaTypeForVideo:NO];
    singleImagePickerController.saveLocation = CJSaveLocationNone;
    [singleImagePickerController pickImageFinishBlock:^(UIImage *image) {
        
        [self finishChooseImage:image];
        
    } pickVideoFinishBlock:^(UIImage *firstImage) {
        
    } pickCancelBlock:^{
        
    }];
    
    [self presentViewController:singleImagePickerController animated:YES completion:nil];
}

/**< 从相册中选择照片 */
- (void)choosePhoto {
    BOOL isAlbumEnable = [CJValidateAuthorizationUtil checkEnableForDeviceComponentType:CJDeviceComponentTypeAlbum inViewController:self];
    if (!isAlbumEnable) {
        return;
    }
    
    MySingleImagePickerController *singleImagePickerController = [[MySingleImagePickerController alloc] init];
    [singleImagePickerController setSingleMediaTypeForVideo:NO];
    singleImagePickerController.saveLocation = CJSaveLocationNone;
    [singleImagePickerController pickImageFinishBlock:^(UIImage *image)
     {
         [self finishChooseImage:image];
         
     } pickVideoFinishBlock:nil pickCancelBlock:^{
         
     }];
     //*/
    
    [self presentViewController:singleImagePickerController animated:YES completion:nil];
}

///通过 "拍照" 和 "从手机相册选择" 两种方式选择到图片后
- (void)finishChooseImage:(UIImage *)image {
    self.imageView.image = image;
    
    NSMutableArray<CJUploadItemModel *> *uploadModels = [[NSMutableArray alloc] init];
    CJUploadItemModel *imageUploadModel = [self saveImageToLocal:image];
    [uploadModels addObject:imageUploadModel];
}

/**< 保存图片到本地 */
- (CJUploadItemModel *)saveImageToLocal:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    //文件名
    NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *imageName = [identifier stringByAppendingPathExtension:@"jpg"];
    
    NSString *fileRelativePath =
    [CJFileManager getLocalDirectoryPathType:CJLocalPathTypeRelative
                          bySubDirectoryPath:@"UploadImage"
                       inSearchPathDirectory:NSCachesDirectory
                             createIfNoExist:YES];
    [CJFileManager saveFileData:imageData withFileName:imageName toRelativeDirectoryPath:fileRelativePath];
    
    
    CJUploadItemModel *imageUploadModel = [[CJUploadItemModel alloc] init];
    imageUploadModel.uploadItemType = CJUploadItemTypeImage;
    imageUploadModel.uploadItemData = imageData;
    imageUploadModel.uploadItemName = imageName;
    
    return imageUploadModel;
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
