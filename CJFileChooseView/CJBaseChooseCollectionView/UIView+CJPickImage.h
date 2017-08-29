//
//  UIView+CJPickImage.h
//  CJPickerDemo
//
//  Created by 李超前 on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <TRMJPhotoBrowser/MJPhotoBrowser.h>
//#import <TRMJPhotoBrowser/MJPhoto.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "CJImageUploadItem.h"
#import "CJUploadVideoItem.h"


@interface UIView (CJPickImage)

/**
 *  拍照：创建拍照的picker视图控制器
 *
 *  @param pickImageCompleteBlock 选择完图片后执行的操作
 *
 *  @return 拍照的picker视图控制器
 */
- (UIImagePickerController *)takePhotoPickerWithPickCompleteBlock:(void (^)(NSArray<CJImageUploadItem *> *pickedImageItems))pickImageCompleteBlock;


/**
 *  从相册中选择照片：创建从相册中选择照片的picker视图控制器
 *
 *  @param canMaxChooseImageCount   当前控制器可一次性选择的最大图片数目
 *  @param pickImageCompleteBlock   选择完图片后执行的操作
 *
 *  @return 从相册中选择照片的picker视图控制器
 */
- (MJImagePickerVC *)choosePhotoPickerWithCanMaxChooseImageCount:(NSInteger)canMaxChooseImageCount pickCompleteBlock:(void (^)(NSArray<CJImageUploadItem *> *pickedImageItems))pickImageCompleteBlock;

@end
