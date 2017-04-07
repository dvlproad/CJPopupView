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
#import <AVFoundation/AVFoundation.h>


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
