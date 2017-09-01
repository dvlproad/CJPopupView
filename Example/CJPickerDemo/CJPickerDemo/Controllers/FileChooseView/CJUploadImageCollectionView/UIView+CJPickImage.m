//
//  UIView+CJPickImage.m
//  CJPickerDemo
//
//  Created by 李超前 on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "UIView+CJPickImage.h"
#import "UIImagePickerControllerUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <CJFMDBFileManager/CJFileManager.h>

@implementation UIView (CJPickImage)

/* 完整的描述请参见文件头部 */
- (UIImagePickerController *)takePhotoPickerWithPickCompleteBlock:(void (^)(NSArray<CJImageUploadItem *> *pickedImageItems))pickImageCompleteBlock {
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
         
         if (pickImageCompleteBlock) {
             pickImageCompleteBlock(@[imageItem]);
         }
         
     } pickVideoFinishBlock:nil pickCancelBlock:^{
         
     }];
    
    return imagePickerController;
}


/* 完整的描述请参见文件头部 */
- (CJImagePickerViewController *)choosePhotoPickerWithCanMaxChooseImageCount:(NSInteger)canMaxChooseImageCount pickCompleteBlock:(void (^)(NSArray<CJImageUploadItem *> *pickedImageItems))pickImageCompleteBlock {
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
    
    CJImagePickerViewController *vc = [[CJImagePickerViewController alloc] init];
    vc.canMaxChooseImageCount = canMaxChooseImageCount;
    vc.pickCompleteBlock = ^(NSArray * array){
        NSMutableArray *pickerImageModels = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < array.count; i++) {
            AlumbImageModel *item = array[i];
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
            
            [pickerImageModels addObject:imageItem];
        }
        //选择结束
        if (pickImageCompleteBlock) {
            pickImageCompleteBlock(pickerImageModels);
        }
    };
    
    return vc; //imagePickerController
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

@end
