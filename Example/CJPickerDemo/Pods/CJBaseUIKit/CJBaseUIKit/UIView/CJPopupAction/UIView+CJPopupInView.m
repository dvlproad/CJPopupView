//
//  UIView+CJPopupInView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "UIView+CJPopupInView.h"

#define CJPopupMainThreadAssert() NSAssert([NSThread isMainThread], @"UIView+CJPopupInView needs to be accessed on the main thread.");

static CGFloat kCJPopupAnimationDuration = 0.3;

static NSString *cjPopupAnimationTypeKey = @"cjPopupAnimationType";
static NSString *cjPopupViewHideFrameStringKey = @"cjPopupViewHideFrameString";
static NSString *cjPopupViewHideTransformKey = @"cjPopupViewHideTransform";

static NSString *cjShowInViewKey = @"cjShowInView";
static NSString *cjTapViewKey = @"cjTapView";

static NSString *cjShowPopupViewCompleteBlockKey = @"cjShowPopupViewCompleteBlock";
static NSString *cjTapBlankViewCompleteBlockKey = @"cjTapBlankViewCompleteBlock";

static NSString *cjPopupViewShowingKey = @"cjPopupViewShowing";
static NSString *cjMustHideFromPopupViewKey = @"cjMustHideFromPopupView";


@interface UIView ()

@property (nonatomic, assign) CJAnimationType cjPopupAnimationType; /**< 弹出视图的动画方式 */
@property (nonatomic, copy) NSString *cjPopupViewHideFrameString;   /**< 弹出视图隐藏时候的frame */
//@property (nonatomic, assign) CATransform3D cjPopupViewHideTransform;/**< 弹出视图隐藏时候的transform */

@property (nonatomic, strong) UIView *cjShowInView; /**< 弹出视图被add到的view */
@property (nonatomic, strong) UIView *cjTapView;    /**< 空白区域（指radioButtons组合下的点击区域（不包括radioButtons区域），用来点击之后隐藏列表） */

@property (nonatomic, copy) CJTapBlankViewCompleteBlock cjTapBlankViewCompleteBlock;    /**< 点击空白区域执行的操作 */
@property (nonatomic, copy) CJShowPopupViewCompleteBlock cjShowPopupViewCompleteBlock;    /**< 显示弹出视图后的操作 */

@end


@implementation UIView (CJPopupInView)

#pragma mark - runtime
//cjPopupAnimationType
- (CJAnimationType)cjPopupAnimationType {
    return [objc_getAssociatedObject(self, &cjPopupAnimationTypeKey) integerValue];
}

- (void)setCjPopupAnimationType:(CJAnimationType)cjPopupAnimationType {
    return objc_setAssociatedObject(self, &cjPopupAnimationTypeKey, @(cjPopupAnimationType), OBJC_ASSOCIATION_ASSIGN);
}

//cjPopupViewHideFrameString
- (NSString *)cjPopupViewHideFrameString {
    return objc_getAssociatedObject(self, &cjPopupViewHideFrameStringKey);
}

- (void)setCjPopupViewHideFrameString:(NSString *)cjPopupViewHideFrameString {
    return objc_setAssociatedObject(self, &cjPopupViewHideFrameStringKey, cjPopupViewHideFrameString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

////cjPopupViewHideTransform
//- (CATransform3D)cjPopupViewHideTransform {
//    return objc_getAssociatedObject(self, &cjPopupViewHideTransformKey);
//}
//
//- (void)setCjPopupViewHideTransform:(CATransform3D)cjPopupViewHideTransform {
//    return objc_setAssociatedObject(self, &cjPopupViewHideTransformKey, cjPopupViewHideTransform, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//cjShowInView
- (UIView *)cjShowInView {
    return objc_getAssociatedObject(self, &cjShowInViewKey);
}

- (void)setCjShowInView:(UIView *)cjShowInView {
    return objc_setAssociatedObject(self, &cjShowInViewKey, cjShowInView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjTapView
- (UIView *)cjTapView {
    return objc_getAssociatedObject(self, &cjTapViewKey);
}

- (void)setCjTapView:(UIView *)cjTapView {
    return objc_setAssociatedObject(self, &cjTapViewKey, cjTapView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//cjTapBlankViewCompleteBlock
- (CJTapBlankViewCompleteBlock)cjTapBlankViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjTapBlankViewCompleteBlockKey);
}

- (void)setCjTapBlankViewCompleteBlock:(CJTapBlankViewCompleteBlock)cjTapBlankViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjTapBlankViewCompleteBlockKey, cjTapBlankViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//cjShowPopupViewCompleteBlock
- (CJShowPopupViewCompleteBlock)cjShowPopupViewCompleteBlock {
    return objc_getAssociatedObject(self, &cjShowPopupViewCompleteBlockKey);
}

- (void)setCjShowPopupViewCompleteBlock:(CJShowPopupViewCompleteBlock)cjShowPopupViewCompleteBlock {
    return objc_setAssociatedObject(self, &cjShowPopupViewCompleteBlockKey, cjShowPopupViewCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


//cjPopupViewShowing
- (BOOL)isCJPopupViewShowing {
    return [objc_getAssociatedObject(self, &cjPopupViewShowingKey) boolValue];
}

- (void)setCjPopupViewShowing:(BOOL)cjPopupViewShowing {
    return objc_setAssociatedObject(self, &cjPopupViewShowingKey, @(cjPopupViewShowing), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 底层接口
/** 完整的描述请参见文件头部 */
- (void)cj_popupInView:(UIView *)popupSuperview
            withOrigin:(CGPoint)popupViewOrigin
                  size:(CGSize)popupViewSize
          blankBGColor:(UIColor *)blankBGColor
          showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
      tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    UIView *popupView = self;
    
    BOOL canAdd = [self letPopupSuperview:popupSuperview addPopupView:popupView withBlankBGColor:blankBGColor];
    if (!canAdd) {
        return;
    }
    UIView *blankView = self.cjTapView;
    CGFloat blankViewX = popupViewOrigin.x;
    CGFloat blankViewY = popupViewOrigin.y;
    CGFloat blankViewWidth = popupViewSize.width;
    CGFloat blankViewHeight = CGRectGetHeight(popupSuperview.frame) - popupViewOrigin.y;
    CGRect blankViewFrame = CGRectMake(blankViewX,
                                       blankViewY,
                                       blankViewWidth,
                                       blankViewHeight);
    [blankView setFrame:blankViewFrame];
    

    self.cjPopupAnimationType = CJAnimationTypeNormal;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    
    
    CGFloat popupViewX = popupViewOrigin.x;
    CGFloat popupViewY = popupViewOrigin.y;
    CGFloat popupViewWidth = popupViewSize.width;
    CGFloat popupViewShowHeight = popupViewSize.height;
    CGFloat popupViewHideHeight = 0;
    CGRect popupViewShowFrame = CGRectMake(popupViewX,
                                           popupViewY,
                                           popupViewWidth,
                                           popupViewShowHeight);
    CGRect popupViewHideFrame = CGRectMake(popupViewX,
                                           popupViewY,
                                           popupViewWidth,
                                           popupViewHideHeight);
    self.cjPopupViewHideFrameString = NSStringFromCGRect(popupViewHideFrame);
    
    
    
    
    //动画设置位置
    blankView.alpha = 0.2;
    popupView.alpha = 0.2;
    popupView.frame = popupViewHideFrame;
    [UIView animateWithDuration:kCJPopupAnimationDuration
                     animations:^{
                         blankView.alpha = 1.0;
                         popupView.alpha = 1.0;
                         popupView.frame = popupViewShowFrame;
                     }];
    
    if(showPopupViewCompleteBlock){
        showPopupViewCompleteBlock();
    }
}

/* 完整的描述请参见文件头部 */
- (void)cj_popupInCenterWindow:(CJAnimationType)animationType
                      withSize:(CGSize)popupViewSize
                  blankBGColor:(UIColor *)blankBGColor
                  showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
              tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIView *popupView = self;
    UIView *popupSuperview = keyWindow;
    
    NSAssert(popupViewSize.width != 0 && popupViewSize.height != 0, @"弹出视图的宽高都不能为0");
    CGRect frame = popupView.frame;
    frame.size.width = popupViewSize.width;
    frame.size.height = popupViewSize.height;
    popupView.frame = frame;
    
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView withBlankBGColor:blankBGColor];
    if (!canAdd) {
        return;
    }
    
    
    self.cjPopupAnimationType = animationType;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;
    
    popupView.center = popupSuperview.center;
    if (animationType == CJAnimationTypeNone) {
        
    } else if (animationType == CJAnimationTypeNormal) {
        
    } else if (animationType == CJAnimationTypeCATransform3D) {
        CATransform3D popupViewShowTransform = CATransform3DIdentity;
        
        CATransform3D rotate = CATransform3DMakeRotation(70.0*M_PI/180.0, 0.0, 0.0, 1.0);
        CATransform3D translate = CATransform3DMakeTranslation(20.0, -500.0, 0.0);
        CATransform3D popupViewHideTransform = CATransform3DConcat(rotate, translate);
        
        self.layer.transform = popupViewHideTransform;
        [UIView animateWithDuration:kCJPopupAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.layer.transform = popupViewShowTransform;
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
    if(showPopupViewCompleteBlock){
        showPopupViewCompleteBlock();
    }
    
}
/** 完整的描述请参见文件头部 */
- (void)cj_popupInBottomWindow:(CJAnimationType)animationType
                    withHeight:(CGFloat)popupViewHeight
                  blankBGColor:(UIColor *)blankBGColor
                  showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
              tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
{
    CJPopupMainThreadAssert();
    NSAssert(popupViewHeight != 0, @"弹出视图的高都不能为0");
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat popupViewWidth = CGRectGetWidth(keyWindow.frame);
    CGSize popupViewSize = CGSizeMake(popupViewWidth, popupViewHeight);
    if (CGSizeEqualToSize(self.frame.size, popupViewSize)) {
        NSLog(@"Warning:popupView视图大小将自动调整为指定的弹出视图大小");
        CGRect selfFrame = self.frame;
        selfFrame.size = popupViewSize;
        self.frame = selfFrame;
    }
    
    UIView *popupView = self;
    
    BOOL canAdd = [self letkeyWindowAddPopupView:popupView withBlankBGColor:blankBGColor];
    if (!canAdd) {
        return;
    }
    
    
    
    self.cjPopupAnimationType = animationType;
    self.cjShowPopupViewCompleteBlock = showPopupViewCompleteBlock;
    self.cjTapBlankViewCompleteBlock = tapBlankViewCompleteBlock;

    
    //popupViewShowFrame
    
    CGFloat popupViewX = 0;
    CGFloat popupViewShowY = CGRectGetHeight(keyWindow.frame) - popupViewHeight;
    CGRect popupViewShowFrame = CGRectZero;
    popupViewShowFrame = CGRectMake(popupViewX,
                                    popupViewShowY,
                                    popupViewWidth,
                                    popupViewHeight);
    
    if (animationType == CJAnimationTypeNone) {
        popupView.frame = popupViewShowFrame;
        
    } else if (animationType == CJAnimationTypeNormal) {
        //popupViewHideFrame
        CGRect popupViewHideFrame = popupViewShowFrame;
        popupViewHideFrame.origin.y = CGRectGetMaxY(keyWindow.frame);
        self.cjPopupViewHideFrameString = NSStringFromCGRect(popupViewHideFrame);
        
        //动画设置位置
        UIView *blankView = self.cjTapView;
        blankView.alpha = 0.2;
        popupView.alpha = 0.2;
        popupView.frame = popupViewHideFrame;
        [UIView animateWithDuration:kCJPopupAnimationDuration
                         animations:^{
                             blankView.alpha = 1.0;
                             popupView.alpha = 1.0;
                             popupView.frame = popupViewShowFrame;
                         }];
        
    } else if (animationType == CJAnimationTypeCATransform3D) {
        popupView.frame = popupViewShowFrame;
        
        CATransform3D popupViewShowTransform = CATransform3DIdentity;
        
        CATransform3D rotate = CATransform3DMakeRotation(70.0*M_PI/180.0, 0.0, 0.0, 1.0);
        CATransform3D translate = CATransform3DMakeTranslation(20.0, -500.0, 0.0);
        CATransform3D popupViewHideTransform = CATransform3DConcat(rotate, translate);
        
        self.layer.transform = popupViewHideTransform;
        [UIView animateWithDuration:kCJPopupAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.layer.transform = popupViewShowTransform;
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
    if(showPopupViewCompleteBlock){
        showPopupViewCompleteBlock();
    }
}


/**
 *  将popupView添加进keyWindow中(会默认添加进blankView及对popupView做一些默认设置)
 *
 *  @param popupView                要被添加的视图
 *  @param blankBGColor             空白区域的背景颜色
 *
 *  @return 是否可以被添加成功
 */
- (BOOL)letkeyWindowAddPopupView:(UIView *)popupView withBlankBGColor:(UIColor *)blankBGColor
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    BOOL canAdd = [self letPopupSuperview:keyWindow addPopupView:popupView withBlankBGColor:blankBGColor];
    if (!canAdd) {
        return NO;
    }
    
    /* 设置blankView的位置 */
    UIView *blankView = self.cjTapView;
    CGFloat blankViewX = 0;
    CGFloat blankViewY = 0;
    CGFloat blankViewWidth = CGRectGetWidth(keyWindow.frame);
    CGFloat blankViewHeight = CGRectGetHeight(keyWindow.frame);;
    CGRect blankViewFrame = CGRectMake(blankViewX,
                                       blankViewY,
                                       blankViewWidth,
                                       blankViewHeight);
    [blankView setFrame:blankViewFrame];
    
    /* 对popupView做一些默认设置 */
    popupView.layer.shadowColor = [[UIColor blackColor] CGColor];
    popupView.layer.shadowOffset = CGSizeMake(0, -2);
    popupView.layer.shadowRadius = 5.0;
    popupView.layer.shadowOpacity = 0.8;
    
    return YES;
}

/**
 *  将popupView添加进popupSuperview中(会默认添加进blankView及对popupView做一些默认设置)
 *
 *  @param popupSuperview           被添加到的地方
 *  @param popupView                要被添加的视图
 *  @param blankBGColor             空白区域的背景颜色
 *
 *  @return 是否可以被添加成功
 */
- (BOOL)letPopupSuperview:(UIView *)popupSuperview
             addPopupView:(UIView *)popupView
         withBlankBGColor:(UIColor *)blankBGColor
{
    if ([popupSuperview.subviews containsObject:popupView]) {
        return NO;
    }
    
    /* 添加进空白的点击区域blankView */
    UIView *blankView = self.cjTapView;
    if (blankView == nil) {
        blankView = [[UIView alloc] initWithFrame:CGRectZero];
        if (!blankBGColor) {
            blankView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
        } else {
            blankView.backgroundColor = blankBGColor;
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cj_TapBlankViewAction:)];
        [blankView addGestureRecognizer:tapGesture];
        
        self.cjTapView = blankView;
    }
    
    if (self.cjPopupViewShowing) { //如果存在，先清除
        [blankView removeFromSuperview];
    }
    [popupSuperview addSubview:blankView];
    
    
    
    
    
    /* 添加进popupView，并做一些默认设置 */
    if (self.cjPopupViewShowing) { //如果存在，先清除
        [popupView removeFromSuperview];
    }
    [popupSuperview addSubview:popupView];
    
    self.cjShowInView = popupSuperview;
    self.cjPopupViewShowing = YES;
    
    return YES;
}


/** 点击空白区域的事件 */
- (void)cj_TapBlankViewAction:(UITapGestureRecognizer *)tap {
    if (self.cjTapBlankViewCompleteBlock) {
        self.cjTapBlankViewCompleteBlock();
    }
}


/** 完整的描述请参见文件头部 */
- (void)cj_hidePopupView {
    CJAnimationType animationType = self.cjPopupAnimationType;
    [self cj_hidePopupViewWithAnimationType:animationType];
}

/** 完整的描述请参见文件头部 */
- (void)cj_hidePopupViewWithAnimationType:(CJAnimationType)animationType {
    CJPopupMainThreadAssert();
    
    self.cjPopupViewShowing = NO;  //设置成NO表示当前未显示任何弹出视图
    [self endEditing:YES];
    
    UIView *popupView = self;
    UIView *tapView = self.cjTapView;
    
    switch (animationType) {
        case CJAnimationTypeNone:
        {
            [popupView removeFromSuperview];
            [tapView removeFromSuperview];
            break;
        }
        case CJAnimationTypeNormal:
        {
            CGRect popupViewHideFrame = CGRectFromString(self.cjPopupViewHideFrameString);
            if (CGRectEqualToRect(popupViewHideFrame, CGRectZero)) {
                popupViewHideFrame = self.frame;
            }
            
            [UIView animateWithDuration:kCJPopupAnimationDuration
                             animations:^{
                                 //要设置成0，不设置非零值如0.2，是为了防止在显示出来的时候，在0.3秒内很快按两次按钮，仍有view存在
                                 tapView.alpha = 0.0f;
                                 popupView.alpha = 0.0f;
                                 popupView.frame = popupViewHideFrame;
                                 
                             }completion:^(BOOL finished) {
                                 [popupView removeFromSuperview];
                                 [tapView removeFromSuperview];
                             }];
            break;
        }
        case CJAnimationTypeCATransform3D:
        {
            [UIView animateWithDuration:kCJPopupAnimationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 CATransform3D rotate = CATransform3DMakeRotation(-70.0 * M_PI / 180.0, 0.0, 0.0, 1.0);
                                 CATransform3D translate = CATransform3DMakeTranslation(-20.0, 500.0, 0.0);
                                 popupView.layer.transform = CATransform3DConcat(rotate, translate);
                                 
                             } completion:^(BOOL finished) {
                                 [popupView removeFromSuperview];
                                 [tapView removeFromSuperview];
                             }];
            break;
        }
    }
}




@end
