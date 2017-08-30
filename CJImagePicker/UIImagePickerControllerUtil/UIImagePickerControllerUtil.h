//
//  UIImagePickerControllerUtil.h
//  CameraDemo
//
//  Created by 李超前 on 2017/2/16.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>   //UIImagePickerController需要使用
#import <AssetsLibrary/AssetsLibrary.h> //系统相册需要使用

// [iOS判断是否有权限访问相机，相册，定位](http://blog.csdn.net/u013127850/article/details/52160911)
//typedef NS_ENUM(NSUInteger, CJDeviceComponentType) {
//    CJDeviceComponentTypeCamera,    /**< 相机 */
//    CJDeviceComponentTypePhoto,     /**< 相册 */
//    CJDeviceComponentTypeLocation,  /**< 定位 */
//};


typedef NS_OPTIONS(NSUInteger, CJSaveLocation) {
    CJSaveLocationNone = 1 << 0,
    CJSaveLocationPhotoLibrary = 1 << 1,
};

@interface UIImagePickerControllerUtil : NSObject {
    
}
@property (nonatomic, assign) CJSaveLocation saveLocation;

+ (UIImagePickerControllerUtil *)sharedInstance;

- (UIImagePickerController *)createWithSourceType:(UIImagePickerControllerSourceType)sourceType
                                          isVideo:(BOOL)isVideo
                             pickImageFinishBlock:(void(^)(UIImage *image))pickImageFinishBlock
                             pickVideoFinishBlock:(void(^)(UIImage *firstImage))pickVideoFinishBlock
                                  pickCancelBlock:(void(^)())pickCancelBlock;

//+ (UIImagePickerController *)createImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType;


@end
