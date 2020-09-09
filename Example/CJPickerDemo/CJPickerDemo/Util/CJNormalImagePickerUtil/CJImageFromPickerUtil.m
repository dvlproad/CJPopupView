//
//  CJImageFromPickerUtil.m
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/8/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJImageFromPickerUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <CJBaseHelper/AuthorizationCJHelper.h>
#import "CQSystemImagePickerController.h"
#import "CJImagePickerViewController.h"

/*
 Authorized:   //已授权，可使用
 NotDetermined://未进行授权选择:系统还未知是否访问，第一次开启时
 Restricted:   //未授权，且用户无法更新，如家长控制情况下
 Denied:       //用户拒绝App使用
 //*/
//相册权限判断
#import <Photos/Photos.h>               //(iOS8之后)


@implementation CJImageFromPickerUtil

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
                    pickFinishBlock:(void (^)(NSArray<UIImage *> *image))pickFinishBlock
{
    BOOL isAlbumEnable = [self checkUserAuthorizationStatusForAlbum];
    if (!isAlbumEnable) {
        NSString *title = NSLocalizedString(@"无法访问相册", nil);
        NSString *message = NSLocalizedString(@"请在设备的\"设置-隐私-照片\"中允许访问照片。", nil);
        NSLog(@"功能权限信息提示:\n%@\n%@", title, message);
        
        if (noPermissionBlock) {
            noPermissionBlock(title, message);
        }
        return;
    }
    
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
    
    [viewController presentViewController:imagePickerViewController animated:YES completion:nil];
}


#pragma mark - 用户授权判断 AuthorizationStatus
/**
 *  检查授权之"相册PhotoLibrary"
 *  @brief: 在info.plist里面设置NSPhotoLibraryUsageDescription
 *                            Privacy - Photo Library Usage Description App需要您的同意,才能访问相册
 *
 *  return 是否授权
 */
+ (BOOL)checkUserAuthorizationStatusForAlbum {
    BOOL isAuthorization = NO;
    
    //iOS 8 之后推荐用 #import <Photos/Photos.h> 中的判断
     PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
     if (authStatus == PHAuthorizationStatusRestricted ||
         authStatus == PHAuthorizationStatusDenied) {
         isAuthorization = NO;
     } else {
         isAuthorization = YES;
     }
         

    return isAuthorization;
}

@end
