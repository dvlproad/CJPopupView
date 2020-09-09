//
//  CQImagePickerControllerFactory.m
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CQImagePickerControllerFactory.h"

@implementation CQImagePickerControllerFactory

#pragma mark - 拍摄照片 的视图控制器
/*
 *  拍摄照片 的视图控制器
 *
 *  @param pickFinishBlock      拍照结束的回调
 *  @param pickCancelBlock      取消的回调
 */
+ (CJSystemImagePickerController *)takePhotoVC_PickFinishBlock:(void (^)(UIImage *image))pickFinishBlock
                                               pickCancelBlock:(void(^)(void))pickCancelBlock
{
    CJSystemImagePickerController *imagePickerController = [[CJSystemImagePickerController alloc] init];
    [imagePickerController setSingleMediaTypeForVideo:NO];
    imagePickerController.saveLocation = CJSaveLocationNone;
    [imagePickerController pickImageFinishBlock:pickFinishBlock pickVideoFinishBlock:nil pickCancelBlock:pickCancelBlock];
    
    return imagePickerController;
}

#pragma mark - 选择照片 的视图控制器

/*
*  从相册中选择照片 的照片选择器(只多选)
*
*  @param pickFinishBlock          选择结束的回调
*/
+ (CJSystemImagePickerController *)pickSingleAssetVC_pickFinishBlock:(void(^)(UIImage *image))pickImageFinishBlock {
    CJSystemImagePickerController *singleImagePickerController = [[CJSystemImagePickerController alloc] init];
    singleImagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    singleImagePickerController.allowsEditing = YES;
    [singleImagePickerController setSingleMediaTypeForVideo:NO];
    singleImagePickerController.saveLocation = CJSaveLocationNone;
    [singleImagePickerController pickImageFinishBlock:pickImageFinishBlock pickVideoFinishBlock:nil pickCancelBlock:nil];
    
    return singleImagePickerController;
}

/*
 *  从相册中选择照片 的照片选择器(可多选)
 *
 *  @param canMaxChooseImageCount   最多可选择多少张的回调
 *  @param pickFinishBlock          选择结束的回调
 */
+ (CJImagePickerViewController *)pickMultipleAssetsVC_canMaxChooseImageCount:(NSInteger)canMaxChooseImageCount
                                                             pickFinishBlock:(void (^)(NSArray<UIImage *> *image))pickFinishBlock
{
    CJImagePickerViewController *imagePickerViewController = [[CJImagePickerViewController alloc] initWithOverLimitBlock:^{
        
    } clickImageBlock:^(CJAlumbImageModel *imageModel) {
        
    } previewAction:^(NSMutableArray<CJAlumbImageModel *> *bSelectedArray) {
        
    } showPhotoesBlock:^(NSArray<CJAlumbImageModel *> *bImageModels) {
        
    } finishPickBlock:^(NSArray<CJAlumbImageModel *> *bImageModels) {
//        NSMutableArray *pickerImages = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0; i < imageModels.count; i++) {
//            AlumbImageModel *item = imageModels[i];
//            UIImage *image = item.image;
//
//            [pickerImages addObject:image];
//        }
//        //选择结束
//        if (pickFinishBlock) {
//            pickFinishBlock(pickerImages);
//        }
    }];
    imagePickerViewController.canMaxChooseImageCount = canMaxChooseImageCount;

    
    return imagePickerViewController;
}



@end
