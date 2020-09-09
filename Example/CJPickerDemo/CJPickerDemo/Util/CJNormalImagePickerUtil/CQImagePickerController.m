//
//  CQImagePickerController.m
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQImagePickerController.h"

@implementation CQImagePickerController

#pragma mark - 拍摄照片 的视图控制器
/*
 *  拍摄照片 的视图控制器
 *
 *  @param pickFinishBlock      拍照结束的回调
 *  @param pickCancelBlock      取消的回调
 */
+ (CQSystemImagePickerController *)takePhotoVC_PickFinishBlock:(void (^)(UIImage *image))pickFinishBlock
                                               pickCancelBlock:(void(^)(void))pickCancelBlock
{
    CQSystemImagePickerController *imagePickerController = [[CQSystemImagePickerController alloc] init];
    [imagePickerController setSingleMediaTypeForVideo:NO];
    imagePickerController.saveLocation = CJSaveLocationNone;
    [imagePickerController pickImageFinishBlock:pickFinishBlock pickVideoFinishBlock:nil pickCancelBlock:pickCancelBlock];
    
    return imagePickerController;
}

#pragma mark - 选择照片 的视图控制器

/*
 *  从相册中选择照片 的照片选择器
 *
 *  @param canMaxChooseImageCount   最多可选择多少张的回调
 *  @param pickFinishBlock          选择结束的回调
 */
+ (CJImagePickerViewController *)pickAssetsVC_canMaxChooseImageCount:(NSInteger)canMaxChooseImageCount
                                                     pickFinishBlock:(void (^)(NSArray<UIImage *> *image))pickFinishBlock
{
    CJImagePickerViewController *imagePickerViewController = [[CJImagePickerViewController alloc] init];
    imagePickerViewController.canMaxChooseImageCount = canMaxChooseImageCount;
    imagePickerViewController.pickCompleteBlock = ^(NSArray<AlumbImageModel *> *imageModels) {
        NSMutableArray *pickerImages = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < imageModels.count; i++) {
            AlumbImageModel *item = imageModels[i];
            UIImage *image = item.image;
            
            [pickerImages addObject:image];
        }
        //选择结束
        if (pickFinishBlock) {
            pickFinishBlock(pickerImages);
        }
    };
    
    return imagePickerViewController;
}



@end
