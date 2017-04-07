//
//  UIImagePickerControllerUtil.m
//  CameraDemo
//
//  Created by 李超前 on 2017/2/16.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "UIImagePickerControllerUtil.h"

@interface UIImagePickerControllerUtil () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) void(^pickImageFinishBlock)(UIImage *image);
@property (nonatomic, copy) void(^pickVideoFinishBlock)(UIImage *firstImage);
@property (nonatomic, copy) void(^pickCancelBlock)();


@end

@implementation UIImagePickerControllerUtil

/**
 *  创建单例
 *
 *  @return 单例
 */
+ (UIImagePickerControllerUtil *)sharedInstance {
    static UIImagePickerControllerUtil *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (UIImagePickerController *)createWithSourceType:(UIImagePickerControllerSourceType)sourceType
                                          isVideo:(BOOL)isVideo
                             pickImageFinishBlock:(void(^)(UIImage *image))pickImageFinishBlock
                             pickVideoFinishBlock:(void(^)(UIImage *firstImage))pickVideoFinishBlock
                                  pickCancelBlock:(void(^)())pickCancelBlock
{
    self.pickImageFinishBlock = pickImageFinishBlock;
    self.pickVideoFinishBlock = pickVideoFinishBlock;
    self.pickCancelBlock = pickCancelBlock;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![UIImagePickerControllerUtil checkSupportCamera]) {
            return nil;
        }
    }
    
    if (![UIImagePickerControllerUtil checkAuthorizationStatus]) {
        return nil;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提示", nil)
                                   message:NSLocalizedString(@"对不起，摄像头暂不支持此类型", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"好的，我知道了", nil)
                         otherButtonTitles:nil] show];
        return nil;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置摄像头
    }
    
    if (isVideo) {
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
    } else {
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];//默认
    }
    
    
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    
    return imagePickerController;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
    
    if (self.pickCancelBlock) {
        self.pickCancelBlock();
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        UIImage *image = nil;
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        
        //保存
        if (self.saveLocation & CJSaveLocationPhotoLibrary) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
        }
        
        if (self.pickImageFinishBlock) {
            self.pickImageFinishBlock(image);
        }
        
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSLog(@"video...");
        NSURL *URL = [info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *url = [URL path];
        
        //保存
        if (self.saveLocation & CJSaveLocationPhotoLibrary) {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url)) {
                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                UISaveVideoAtPathToSavedPhotosAlbum(url, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            }
        }
        
        if (self.pickVideoFinishBlock) {
            self.pickVideoFinishBlock(nil);
        }
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        //        NSURL *url=[NSURL fileURLWithPath:videoPath];
        //        _player=[AVPlayer playerWithURL:url];
        //        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
        //        playerLayer.frame=self.photo.frame;
        //        [self.photo.layer addSublayer:playerLayer];
        //        [_player play];
        
    }
}


#pragma mark - 类方法
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

+ (BOOL)checkAuthorizationStatus {
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
