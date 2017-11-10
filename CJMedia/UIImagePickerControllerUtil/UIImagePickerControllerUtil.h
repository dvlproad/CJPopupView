//
//  UIImagePickerControllerUtil.h
//  CJPickerDemo
//
//  Created by ciyouzen on 14-02-16.
//  Copyright © 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>   //UIImagePickerController需要使用

// [iOS判断是否有权限访问相机，相册，定位](http://blog.csdn.net/u013127850/article/details/52160911)
//typedef NS_ENUM(NSUInteger, CJDeviceComponentType) {
//    CJDeviceComponentTypeCamera,    /**< 相机 */
//    CJDeviceComponentTypePhoto,     /**< 相册 */
//    CJDeviceComponentTypeLocation,  /**< 定位 */
//};

@interface UIImagePickerControllerUtil : NSObject {
    
}

/**
 *  校验是否支持sourceType
 *
 *  @param sourceType sourceType
 *
 *  return 是否支持
 */
+ (BOOL)checkSupportSourceType:(UIImagePickerControllerSourceType)sourceType;

@end
