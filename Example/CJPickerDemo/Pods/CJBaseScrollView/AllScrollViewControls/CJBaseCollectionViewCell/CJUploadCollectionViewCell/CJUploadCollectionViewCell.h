//
//  CJUploadCollectionViewCell.h
//  AllScrollViewDemo
//
//  Created by lichq on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJBaseCollectionViewCell.h"

@interface CJUploadCollectionViewCell : CJBaseCollectionViewCell


@property (nonatomic, copy) void(^cjReUploadHandle)(CJUploadCollectionViewCell *cell);


/**
 *  更新上传状态的提示文字和进度
 *
 *  @param progressText     该上传状态的提示文字
 *  @param progressValue    该上传状态的进度值[0-100]
 */
- (void)updateProgressText:(NSString *)progressText progressVaule:(CGFloat)progressValue;

@end
