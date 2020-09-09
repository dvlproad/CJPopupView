//
//  CJImageFromPickerUtil.h
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//
//  执行从相册中选择照片操作（所选择的图片不会被保存到沙盒中）

#import <UIKit/UIKit.h>

@interface CJImageFromPickerUtil : NSObject

#pragma mark - 照片选择

/*
 *  从相册中选择照片
    @brief: 在info.plist里面设置NSPhotoLibraryUsageDescription
 *                            Privacy - Photo Library Usage Description App需要您的同意,才能访问相册
 *
 *  @param viewController           用来弹出照片选择视图控制器的viewController
 *  @param noPermissionBlock        没有权限时候的回调
 *  @param canMaxChooseImageCount   最多可选择多少张的回调
 *  @param pickFinishBlock          选择结束的回调
 */
+ (void)choosePhotoInViewController:(UIViewController *)viewController
              withNoPermissionBlock:(void(NSString *title, NSString *message))noPermissionBlock
             canMaxChooseImageCount:(NSInteger)canMaxChooseImageCount
                    pickFinishBlock:(void (^)(NSArray<UIImage *> *image))pickFinishBlock;

@end
