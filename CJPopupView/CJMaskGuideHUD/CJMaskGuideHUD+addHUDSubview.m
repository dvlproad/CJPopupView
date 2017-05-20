//
//  CJMaskGuideHUD+addHUDSubview.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJMaskGuideHUD+addHUDSubview.h"

#define IndicateLeftMarginToLightFrame 5    //indicateFrame相对高亮区域的左右偏移量为多少
#define IndicateHeight  35                  //indicateFrame的整体高度
#define HUDSubviewFrameLeftMarginToHUD  20  //hudSubviewFrame相对hud左右的偏移量

@implementation CJMaskGuideHUD (Factory)

- (void)addHUDSubview:(UIView *)hudSubview withHudSubviewHeight:(CGFloat)hudSubviewHeight
{
    CJMaskGuideHUD *hud = self;
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    /* 1、获取indicateFrame，随后再在indicateFrame中画指示标志，如箭号等 */
    CGFloat indicateWidth = CGRectGetWidth(hud.lightFrame) + 2 * IndicateLeftMarginToLightFrame;
    CGFloat indicateHeight = IndicateHeight;
    CGFloat indicateMinX = CGRectGetMinX(hud.lightFrame) - IndicateLeftMarginToLightFrame;
    CGFloat indicateMinY = 0;
    
    CGFloat centerY = CGRectGetMidY(hud.lightFrame);
    if (centerY > hud.bounds.size.height / 2) { //上面
        indicateMinY = CGRectGetMinY(hud.lightFrame) - indicateHeight;
        
    } else { //下面
        indicateMinY = CGRectGetMaxY(hud.lightFrame);
    }
    CGRect indicateFrame = CGRectMake(indicateMinX, indicateMinY, indicateWidth, indicateHeight);
    CGFloat indicateMaxY = CGRectGetMaxY(indicateFrame);
    CGFloat indicateHorizontalLineBottomMargin = 15; //indicate的水平线离indicateFrame底部的距离
    
    CGPoint first = CGPointMake(CGRectGetMinX(indicateFrame), indicateMaxY);
    CGPoint second = CGPointMake(CGRectGetMinX(indicateFrame) + IndicateLeftMarginToLightFrame, indicateMaxY - indicateHorizontalLineBottomMargin);
    
    CGPoint third = CGPointMake(CGRectGetMaxX(indicateFrame) - IndicateLeftMarginToLightFrame, indicateMaxY - indicateHorizontalLineBottomMargin);
    CGPoint fourth = CGPointMake(CGRectGetMaxX(indicateFrame), indicateMaxY);
    
    CGPoint fifth = CGPointMake(CGRectGetMidX(indicateFrame), indicateMaxY - indicateHorizontalLineBottomMargin);
    CGPoint sixth = CGPointMake(CGRectGetMidX(indicateFrame), indicateMinY);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:first];
    [path addLineToPoint:second];
    [path addLineToPoint:third];
    [path addLineToPoint:fourth];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:fifth];
    [path2 addLineToPoint:sixth];
    
    [path appendPath:path2];
    
    layer.path = path.CGPath;
    layer.lineWidth = 2;
    layer.lineCap = @"round";
    layer.lineJoin = @"round";
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    
    [hud.layer addSublayer:layer];
    
    /* 2、获取hudSubviewFrame，随后再在hudSubviewFrame中添加hudSubview等指示说明 */
    CGFloat hudSubviewMinX = HUDSubviewFrameLeftMarginToHUD;
    CGFloat hudSubviewWidth = CGRectGetWidth(hud.frame) - 2 * HUDSubviewFrameLeftMarginToHUD;
    CGFloat hudSubviewMinY = 0;
    if (centerY > hud.bounds.size.height / 2) { //上面
        hudSubviewMinY = CGRectGetMinY(indicateFrame) - hudSubviewHeight;
        
    } else { //下面
        hudSubviewMinY = CGRectGetMaxY(indicateFrame);
    }
    CGRect hudSubviewFrame = CGRectMake(hudSubviewMinX, hudSubviewMinY, hudSubviewWidth, hudSubviewHeight);
    hudSubview.frame = hudSubviewFrame;
    [hud addSubview:hudSubview];
}

/** 完整的描述请参见文件头部 */
- (void)addHUDSubview:(UIView *)hudSubview withHeight:(CGFloat)hudSubviewHeight andSubViewIndicator:(UIView *)indicator withWidth:(CGFloat)indicatorWidth position:(CJMaskGuideIndicatorPositon)indicatorPosition
{
    CJMaskGuideHUD *hud = self;
    
    /* 1、获取indicateFrame，随后再在indicateFrame中画指示标志，如箭号等 */
    CGFloat indicateWidth = CGRectGetWidth(hud.lightFrame) + 2 * IndicateLeftMarginToLightFrame;
    CGFloat indicateHeight = IndicateHeight;
    CGFloat indicateMinX = CGRectGetMinX(hud.lightFrame) - IndicateLeftMarginToLightFrame;
    CGFloat indicateMinY = 0;
    
    CGFloat centerY = CGRectGetMidY(hud.lightFrame);
    if (centerY > hud.bounds.size.height / 2) { //上面
        indicateMinY = CGRectGetMinY(hud.lightFrame) - indicateHeight;
        
    } else { //下面
        indicateMinY = CGRectGetMaxY(hud.lightFrame);
    }
    
    CGFloat indicatorOriginX = 0;
    switch (indicatorPosition) {
        case CJMaskGuideIndicatorPositonStartInLeft:
        {
            indicatorOriginX = indicateMinX;
            break;
        }
        case CJMaskGuideIndicatorPositonStartInCenter:
        {
            indicatorOriginX = indicateMinX + indicateWidth/2;
            break;
        }
        default:    //CJMaskGuideIndicatorPositonEndInRight
        {
            indicatorOriginX = indicateMinX + indicateWidth - indicatorWidth;
            break;
        }
    }
    CGRect indicateFrame = CGRectMake(indicatorOriginX, indicateMinY, indicatorWidth, indicateHeight);
    [indicator setFrame:indicateFrame];
    [self addSubview:indicator];
    
    /* 2、获取hudSubviewFrame，随后再在hudSubviewFrame中添加hudSubview等指示说明 */
    CGFloat hudSubviewMinX = HUDSubviewFrameLeftMarginToHUD;
    CGFloat hudSubviewWidth = CGRectGetWidth(hud.frame) - 2 * HUDSubviewFrameLeftMarginToHUD;
    CGFloat hudSubviewMinY = 0;
    if (centerY > hud.bounds.size.height / 2) { //上面
        hudSubviewMinY = CGRectGetMinY(indicateFrame) - hudSubviewHeight;
        
    } else { //下面
        hudSubviewMinY = CGRectGetMaxY(indicateFrame);
    }
    CGRect hudSubviewFrame = CGRectMake(hudSubviewMinX, hudSubviewMinY, hudSubviewWidth, hudSubviewHeight);
    hudSubview.frame = hudSubviewFrame;
    [hud addSubview:hudSubview];
}

@end
