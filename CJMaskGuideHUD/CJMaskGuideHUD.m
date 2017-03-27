//
//  CJMaskGuideHUD.m
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/3/20.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJMaskGuideHUD.h"

@interface CJMaskGuideHUD ()
{
    BOOL _hidenAnimation;
}

///背景图片
@property (nonatomic, strong) UIImage *backgroundImage;
///背景（毛玻璃的时候才存在）
@property (nonatomic, strong) UIView *backgroundView;
///显示的区域
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
///高亮区域
@property (nonatomic, strong) UIBezierPath *lightPath;

@end

@implementation CJMaskGuideHUD

#pragma mark - Class methods
+ (instancetype)showHUDAddedTo:(UIView *)view visibleView:(UIView *)visibleView animated:(BOOL)animated
{
    if (!view) {
        NSLog(@"Error:遮罩层要显示的位置不能为空");
    }
    CJMaskGuideHUD *hud = [[self alloc] initWithView:view];
    hud.visibleView = visibleView;
    [view addSubview:hud];
    [hud show:animated];
    return hud;
}

#pragma mark - Lifecycle
- (instancetype)initWithView:(UIView *)view
{
    
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化操作
        self.backgroundColor = [UIColor clearColor];
        self.margin = 10;
        self.cornerRadius = 10;
        self.lineWidth = 5;
        self.lineColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"CJMaskGuideHUD 释放了");
}

#pragma mark - Show & hide
- (void)show:(BOOL)animated
{
    if (animated) {
        CGAffineTransform small = CGAffineTransformMakeScale(0.2f, 0.2f);
        self.transform = small;
        [UIView animateWithDuration:0.3 delay:0.f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)hide:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide:) object:nil];
    if (animated || _hidenAnimation) {
        CGAffineTransform small = CGAffineTransformMakeScale(0.01f, 0.01f);
        [UIView animateWithDuration:0.25 delay:0.f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.transform = small;
            
            CGFloat centerX = CGRectGetMidX(_lightFrame);
            CGFloat centerY = CGRectGetMidY(_lightFrame);
            self.center = CGPointMake(centerX, centerY);
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    _hidenAnimation = animated;
    [self performSelector:@selector(hide:) withObject:nil afterDelay:delay];
}

#pragma mark - UI
- (void)setupUI
{
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        _style = CJMaskGuideHUDBackgroundStyleBlur;
    } else {
        _style = CJMaskGuideHUDBackgroundStyleSolidColor;
    }
    [self updateForBackgroundStyle];
    [self prepare];
}

- (void)prepare
{
    //自定义操作
}

- (void)updateForBackgroundStyle {
    
    CJMaskGuideHUDBackgroundStyle style = self.style;
    self.backgroundColor = [UIColor clearColor];
    if (style == CJMaskGuideHUDBackgroundStyleBlur) {
        [self.backgroundView removeFromSuperview];
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) {
            
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
            [self addSubview:effectView];
            effectView.frame = self.bounds;
            effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            self.backgroundView = effectView;
            
            
        } else {

            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
            toolbar.barStyle = UIBarStyleDefault;
            toolbar.translucent = YES;
            toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self addSubview:toolbar];
            self.backgroundView = toolbar;
        }
        

    } else {

        [self.backgroundView removeFromSuperview];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchBackgroundHandle) {
        self.touchBackgroundHandle();
    }
}

#pragma mark - Other
- (void)changeVisibleViewFrame
{
    CGRect visibleRect = CGRectZero;
    CGRect visibleFrame = self.visibleView.frame;
    //坐标系转换
    CGRect frame = [_visibleView.superview convertRect:visibleFrame toView:self];
    
    CGFloat originX = CGRectGetMinX(frame) - self.margin + self.edgeInsets.left;
    CGFloat originY = CGRectGetMinY(frame) - self.margin + self.edgeInsets.top;
    CGFloat width = CGRectGetWidth(frame) + 2 * self.margin - self.edgeInsets.left - self.edgeInsets.right;
    CGFloat height = CGRectGetHeight(frame) + 2 * self.margin - self.edgeInsets.top - self.edgeInsets.bottom;
    
    if (self.style == CJMaskGuideHUDBackgroundStyleBlur) {
        originX -= self.lineWidth;
        originY -= self.lineWidth;
        width += 2 * self.lineWidth;
        height += 2 * self.lineWidth;
        
        visibleRect = CGRectMake(originX, originY, width, height);
        
    } else {
        visibleRect = CGRectMake(originX, originY, width, height);
    }
    _lightFrame = visibleRect;
}
#pragma mark - Properties
- (void)setVisibleView:(UIView *)visibleView
{
    _visibleView = visibleView;
    [self changeVisibleViewFrame];
    [self setNeedsDisplay];
}

- (void)setStyle:(CJMaskGuideHUDBackgroundStyle)style
{
    _style = style;
    [self updateForBackgroundStyle];
    [self changeVisibleViewFrame];
    [self setNeedsLayout];
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;

    UIView *view = nil;
    if (![self.backgroundView isKindOfClass:[UIToolbar class]]) {
        view = [self findSubviewWithClassNamed:@"_UIVisualEffectBackdropView" inView:self.backgroundView];
        if (view) {
            view.alpha = alpha;
        }
    } else {
        self.backgroundView.alpha = alpha;
    }
}


- (void)setOval:(BOOL)oval
{
    _oval = oval;
    [self changeVisibleViewFrame];
    [self setNeedsDisplay];
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    [self changeVisibleViewFrame];
    [self setNeedsDisplay];
}
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    [self changeVisibleViewFrame];
    [self setNeedsDisplay];
}
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self changeVisibleViewFrame];
    [self setNeedsDisplay];
}
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self changeVisibleViewFrame];
    [self setNeedsDisplay];
}
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setBlurStyle:(CJMaskGuideHUDBlurStyle)blurStyle
{
    _blurStyle = blurStyle;
    if (blurStyle == CJMaskGuideHUDBlurStyleLight) {
        if (![self.backgroundView isKindOfClass:[UIToolbar class]]) {
            UIVisualEffectView *effectView = (UIVisualEffectView *)self.backgroundView;
            effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        } else {
            UIToolbar *boolbar = (UIToolbar *)self.backgroundView;
            boolbar.barStyle = UIBarStyleDefault;
        }
    } else {
        if (![self.backgroundView isKindOfClass:[UIToolbar class]]) {
            UIVisualEffectView *effectView = (UIVisualEffectView *)self.backgroundView;
            effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else {
            UIToolbar *boolbar = (UIToolbar *)self.backgroundView;
            boolbar.barStyle = UIBarStyleBlack;
        }
    }
    [self changeVisibleViewFrame];
}

- (void)setBlurColor:(UIColor *)blurColor
{
    _blurColor = blurColor;
    if (self.blurColor) { //自定义毛玻璃样式_UIVisualEffectBackdropView
        UIView *view = nil;
        if (![self.backgroundView isKindOfClass:[UIToolbar class]]) {
            view = [self findSubviewWithClassNamed:@"_UIVisualEffectFilterView" inView:self.backgroundView];
            if (view) {
                view.backgroundColor = self.blurColor;
            }
        }
    }
}


#pragma mark - Lazy
- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}



#pragma mark - DrawRect
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    UIBezierPath *clearPath = nil;
    if (self.isOval) { //椭圆
        self.lightPath = [UIBezierPath bezierPathWithOvalInRect:_lightFrame];
    } else { //矩形
        self.lightPath = [UIBezierPath bezierPathWithRoundedRect:_lightFrame cornerRadius:self.cornerRadius];
    }
    clearPath = [self.lightPath bezierPathByReversingPath]; //取反
    [path appendPath:clearPath];
    
    self.lightPath.lineJoinStyle = kCGLineJoinRound;
    self.lightPath.lineCapStyle = kCGLineCapRound;
    self.lightPath.lineWidth = self.lineWidth * 2;
    [self.lineColor set];
    [self.lightPath stroke];
    
    if (self.style == CJMaskGuideHUDBackgroundStyleBlur) {
        self.backgroundView.layer.mask = self.shapeLayer;
    } else {
        self.layer.mask = self.shapeLayer;
    }
    self.shapeLayer.path = path.CGPath;
}

/**
 *  从findInView中找到其subview中名为string的view
 *
 *  @param string       要找的subview的名字
 *  @param findInView   从哪里找的
 *
 *  return  找到的view(找不到返回nil)
 */
- (UIView *)findSubviewWithClassNamed:(NSString *)string inView:(UIView *)findInView
{
    for (UIView *view in findInView.subviews) {
        if ([view isKindOfClass:NSClassFromString(string)]) {
            return view;
        }
        [self findSubviewWithClassNamed:string inView:view];
    }
    return nil;
}

@end
