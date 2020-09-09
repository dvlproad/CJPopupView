//
//  CQImagePickerPermissionUtil.h
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//
//  执行拍照操作（所拍摄的图片不会被保存到沙盒中）

#import <UIKit/UIKit.h>

@interface CQImagePickerPermissionUtil : NSObject

#pragma mark - 拍摄照片
/*
 *  拍照
 *
 *  @param viewController       用来弹出拍照视图控制器的viewController
 *  @param noPermissionBlock    没有权限时候的回调
 *  @param pickFinishBlock      拍照结束的回调
 *  @param pickCancelBlock      取消的回调
 */
+ (void)takePhotoInViewController:(UIViewController *)viewController
            withNoPermissionBlock:(void(NSString *title, NSString *message))noPermissionBlock
                  pickFinishBlock:(void (^)(UIImage *image))pickFinishBlock
                  pickCancelBlock:(void(^)(void))pickCancelBlock;


@end
