//
//  CJMaskGuideHUD+addHUDSubview.h
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJMaskGuideHUD.h"

typedef NS_ENUM(NSUInteger, CJMaskGuideIndicatorPositon) {
    CJMaskGuideIndicatorPositonStartInCenter,  /**< 指示器(一般为箭头)在中间 */
    CJMaskGuideIndicatorPositonStartInLeft,
    CJMaskGuideIndicatorPositonEndInRight,
};

@interface CJMaskGuideHUD (Factory)

- (void)addHUDSubview:(UIView *)hudSubview withHudSubviewHeight:(CGFloat)hudSubviewHeight;


/**
 *  添加遮罩图层
 *
 *  @param hudSubview           遮罩图层
 *  @param hudSubviewHeight     遮罩图层的高度
 *  @param indicator            指示图
 *  @param indicatorWidth       指示图的宽度
 *  @param indicatorPosition    指示图的位置
 */
- (void)addHUDSubview:(UIView *)hudSubview withHeight:(CGFloat)hudSubviewHeight andSubViewIndicator:(UIView *)indicator withWidth:(CGFloat)indicatorWidth position:(CJMaskGuideIndicatorPositon)indicatorPosition;

@end
