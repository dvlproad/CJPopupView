//
//  UIImagePickerControllerUtil.m
//  CJPickerDemo
//
//  Created by ciyouzen on 14-02-16.
//  Copyright © 2014年 dvlproad. All rights reserved.
//

#import "UIImagePickerControllerUtil.h"

@interface UIImagePickerControllerUtil ()

@end

@implementation UIImagePickerControllerUtil

/* 完整的描述请参见文件头部 */
+ (BOOL)checkSupportSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![UIImagePickerControllerUtil checkSupportCamera]) {
            return NO;
        }
    }
    
    if (![UIImagePickerControllerUtil checkCameraAuthorizationStatus]) {
        return NO;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提示", nil)
                                   message:NSLocalizedString(@"对不起，摄像头暂不支持此类型", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"好的，我知道了", nil)
                         otherButtonTitles:nil] show];
        return NO;
    }
    
    return YES;
}

/**
 *  校验是否支持“拍照”
 *
 *  return 是否支持
 */
+ (BOOL)checkSupportCamera {
    BOOL isSupportCamera = NO;
#if TARGET_IPHONE_SIMULATOR
    isSupportCamera = NO;
#else
    isSupportCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
#endif
    if (isSupportCamera == NO) {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提示", nil)
                                   message:NSLocalizedString(@"对不起，您的手机不支持拍照功能", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"好的，我知道了", nil)
                         otherButtonTitles:nil] show];
    }
    
    return isSupportCamera;
}


//+ (BOOL)checkAuthorizationStatusForImageComponentType:(CJDeviceComponentType)imageComponentType {
/**
 *  校验是否授权sourceType
 *
 *  return 是否授权
 */
+ (BOOL)checkCameraAuthorizationStatus {
    BOOL isAuthorization = NO;
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus) {
        case AVAuthorizationStatusAuthorized:   //已授权，可使用
        {
            isAuthorization = YES;
            break;
        }
        case AVAuthorizationStatusNotDetermined://未进行授权选择
        {
            isAuthorization = YES;
            break;
        }
        case AVAuthorizationStatusRestricted:   //未授权，且用户无法更新，如家长控制情况下
        case AVAuthorizationStatusDenied:       //用户拒绝App使用
        {
            isAuthorization = NO;
            break;
        }
        default:
        {
            isAuthorization = NO;
            break;
        }
    }
    
    if(isAuthorization == NO) {
        [[[UIAlertView alloc] initWithTitle:@"无法拍照"
                                    message:@"请在“设置-隐私-相机”选项中允许应用访问你的相机"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
    }
    
    return isAuthorization;
}

@end

