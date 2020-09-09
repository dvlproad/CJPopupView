//
//  CJImagePickerViewController.h
//  CJPickerDemo
//
//  Created by ciyouzen on 2015/8/31.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import "CJAlumbImageModel.h"

#import "CJAlumbSectionDataModel.h"


/**
 *  自定义的“图片选择器CJImagePickerViewController”
 */
@interface CJImagePickerViewController : UIViewController {
    
}
@property (nonatomic, assign) NSInteger canMaxChooseImageCount;     /**< 可一次性选取的最大数目 */
@property (nonatomic, copy) void (^pickCompleteBlock)(NSArray<CJAlumbImageModel *> *imageModels);    /**< 照片选取完毕后 */



@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *assets;


/*
 *  初始化
 *
 *  @param overLimitBlock       超过最大选择图片数量的限制回调
 *  @param clickImageBlock      点击图片执行的事件
 *  @param previewAction        点击"预览"执行的事件
 *  @param previewAction        点击"相册"执行的事件
 *  @param finishPickBlock      点击"完成"执行的事件
 *
 *  @return 照片选择器
 */
- (instancetype)initWithOverLimitBlock:(void(^)(void))overLimitBlock
                       clickImageBlock:(void(^)(CJAlumbImageModel *imageModel))clickImageBlock
                         previewAction:(void(^)(NSMutableArray<CJAlumbImageModel *> *bSelectedArray))previewAction
                      showPhotoesBlock:(void(^)(NSArray<CJAlumbImageModel *> *bImageModels))showPhotoesBlock
                       finishPickBlock:(void(^)(NSArray<CJAlumbImageModel *> *bImageModels))finishPickBlock NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)hcRefreshViewDidDataUpdated;



@end
