//
//  CJMaskGuideHUD.h
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CJMaskGuideHUDBackgroundStyle) {
    CJMaskGuideHUDBackgroundStyleSolidColor,    /**< 纯色背景 */
    CJMaskGuideHUDBackgroundStyleBlur           /**< 毛玻璃背景 */
};

typedef NS_ENUM(NSInteger, CJMaskGuideHUDBlurStyle) {
    CJMaskGuideHUDBlurStyleLight,   /**< 白色 */
    CJMaskGuideHUDBlurStyleDark     /**< 黑色 */
};


@protocol CJMaskGuideHUDDeledate <NSObject>

@optional
- (void)cjMaskGuideHUD_TouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end



@interface CJMaskGuideHUD : UIView

///需要高亮的控件
@property (nonatomic, weak) UIView *visibleView;

///高亮区域的偏移量
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

///高亮区域相对于原控件大多少（默认5）
@property (nonatomic, assign) CGFloat margin;

///高亮区域是否是椭圆 （默认为 圆角为10 的矩形）
@property (nonatomic, assign, getter=isOval) BOOL oval;

///背景样式
@property (nonatomic, assign) CJMaskGuideHUDBackgroundStyle style;

@property (nonatomic, copy) void (^touchBackgroundHandle)(void);    ///点击的操作

///圆角 (默认10)
@property (nonatomic, assign) CGFloat cornerRadius;

///线宽 (默认 5)
@property (nonatomic, assign) CGFloat lineWidth;

///线的颜色（白色）
@property (nonatomic, strong) UIColor *lineColor;

///毛玻璃样式
@property (nonatomic, assign) CJMaskGuideHUDBlurStyle blurStyle;

///自定义毛玻璃颜色，使用blurColor,blurStyle失效(ios 8+)
@property (nonatomic, strong) UIColor *blurColor;

///透明度
@property (nonatomic, assign) CGFloat alpha;

///高亮区域的frame
@property (nonatomic, assign, readonly) CGRect lightFrame;

//自定义UI
- (void)prepare;
+ (instancetype)showHUDAddedTo:(UIView *)view visibleView:(UIView *)visibleView animated:(BOOL)animated;
- (instancetype)initWithView:(UIView *)view;
- (void)hide:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end
