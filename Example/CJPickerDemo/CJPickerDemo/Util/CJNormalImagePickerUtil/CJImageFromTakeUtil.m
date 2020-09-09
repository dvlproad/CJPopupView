//
//  CJImageFromTakeUtil.m
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJImageFromTakeUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "CQImagePickerController.h"

/*
 Authorized:   //已授权，可使用
 NotDetermined://未进行授权选择:系统还未知是否访问，第一次开启时
 Restricted:   //未授权，且用户无法更新，如家长控制情况下
 Denied:       //用户拒绝App使用
 //*/
//相册权限判断
#import <Photos/Photos.h>               //(iOS8之后)

@implementation CJImageFromTakeUtil

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
                  pickCancelBlock:(void(^)(void))pickCancelBlock
{
    BOOL isCameraEnable = [self checkEnableForCamera];
    if (!isCameraEnable) {
        NSString *title = NSLocalizedString(@"无法拍照", nil);
        NSString *message = NSLocalizedString(@"请在“设置-隐私-相机”选项中允许应用访问你的相机", nil);
        NSLog(@"功能权限信息提示:\n%@\n%@", title, message);
        
        if (noPermissionBlock) {
            noPermissionBlock(title, message);
        }
        return;
    }
    
    CQSystemImagePickerController *imagePickerController = [CQImagePickerController takePhotoVC_PickFinishBlock:pickFinishBlock pickCancelBlock:pickCancelBlock];
    
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - 权限检查

/*
*  检查是否具备访问相机权限
*
*  @param noPermissionBlock        没有权限时候的回调
*
*  @return 权限判断
*/
+ (BOOL)checkEnableForCamera {
    if (![self __checkDeviceSupportCamera]) {
        return NO;
    }
    
    if (![self __checkUserAuthorizationStatusForCamera]) {
        return NO;
    }
    
    return YES;
}


/**
 *  设备支持判断--设备支持校验之是否支持“拍照”
 *
 *  return 是否支持
 */
+ (BOOL)__checkDeviceSupportCamera {
    BOOL isSupportCamera = NO;
#if TARGET_IPHONE_SIMULATOR
    isSupportCamera = NO;
#else
    isSupportCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
#endif
    
    return isSupportCamera;
}



/**
 *  用户授权判断 AuthorizationStatus--检查授权之"相机Camera"
 *  @brief: 在info.plist里面设置NSCameraUsageDescription
 *                            Privacy - Camera Usage Description      App需要您的同意,才能访问相机
 *
 *  return 是否授权
 */
+ (BOOL)__checkUserAuthorizationStatusForCamera {
    BOOL isAuthorization = NO;
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied) {
        isAuthorization = NO;
    } else {
        isAuthorization = YES;
    }
    
    return isAuthorization;
}



@end
