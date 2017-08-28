//
//  CJUploadImageCollectionView.h
//  FileChooseViewDemo
//
//  Created by 李超前 on 2017/1/19.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <CJBaseScrollView/MyEqualCellSizeCollectionView.h>
#import "CJImageUploadItem.h"
#import "CJUploadVideoItem.h"

typedef NS_ENUM(NSUInteger, CJMediaType) {
    CJMediaTypeImage,
    CJMediaTypeVideo
};

///TODO:将FileChooseView从CJPickerDemo中整理到MainViewControllerDemo
@interface CJUploadImageCollectionView : MyEqualCellSizeCollectionView <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
}




//可选
@property (nonatomic, assign) NSInteger useToUploadItemToWhere; /** 可选：上传到哪里(一个项目中可能有好几个地方都要上传) */

@property (nonatomic, assign) CJMediaType mediaType;
@property (nonatomic, strong) UIViewController *belongToViewController;

//image
@property (nonatomic, copy) void(^pickImageCompleteBlock)(); /**< 选择完图片后的操作 */

//video
@property (nonatomic, copy) void(^pickVideoHandle)();   /**< 开始操作视频的操作 */


/**
 *  检查所有文件是否上传完成
 *
 *  return 是否上传完成
 */
- (BOOL)isAllUploadFinish;




@end
