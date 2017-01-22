//
//  UIView+CJShowExtendView.m
//  CJPopupViewDemo
//
//  Created by lichq on 15/11/12.
//  Copyright (c) 2015年 ciyouzen. All rights reserved.
//

#import "UIView+CJShowExtendView.h"

static NSString *cjExtendViewKey = @"cjExtendView";


@interface UIView ()

@property (nonatomic, strong) UIView *cjExtendView; /**< 当前视图的弹出视图 */

@end

@implementation UIView (CJShowDropView)

#pragma mark - runtime
//cjExtendView
- (UIView *)cjExtendView {
    return objc_getAssociatedObject(self, &cjExtendViewKey);
}

- (void)setCjExtendView:(UIView *)cjExtendView {
    return objc_setAssociatedObject(self, &cjExtendViewKey, cjExtendView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - <#Section#>
/** 完整的描述请参见文件头部 */
- (void)cj_showExtendView:(UIView *)popupView
                   inView:(UIView *)popupSuperView
               atLocation:(CGPoint)popupViewLocation
                 withSize:(CGSize)popupViewSize
             showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
         tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
             hideComplete:(CJHidePopupViewCompleteBlock)hidePopupViewCompleteBlock {
    self.cjExtendView = popupView;
    
    [popupView cj_popupInView:popupSuperView
                   atLocation:popupViewLocation
                     withSize:popupViewSize
                 showComplete:showPopupViewCompleteBlock
             tapBlankComplete:tapBlankViewCompleteBlock
                 hideComplete:hidePopupViewCompleteBlock];
}

/** 完整的描述请参见文件头部 */
- (void)cj_hideExtendViewAnimated:(BOOL)animated {
    if (animated) {
        [self.cjExtendView cj_hidePopupViewWithAnimationType:CJAnimationTypeNormal];
    } else {
        [self.cjExtendView cj_hidePopupViewWithAnimationType:CJAnimationTypeNone];
    }
}



/**
 *  在popupSuperView中根据popupView与accordingView的位置关系popupViewPosition来弹出视图
 *
 *  @param popupView                  弹出视图popupView
 *  @param popupSuperView             弹出视图popupView的superView
 *  @param accordingView              根据accordingView来取得弹出视图的应该的位置和大小
 *  @param popupViewPosition          弹出视图popupView相对accordingView的位置
 *  @param showPopupViewCompleteBlock 显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock  点击空白区域后的操作
 *  @param hidePopupViewCompleteBlock 隐藏弹出视图后的操作
 */
- (void)cj_popupView:(UIView *)popupView
              inView:(UIView *)popupSuperView
       accordingView:(UIView *)accordingView
    relativePosition:(CJPopupViewPosition)popupViewPosition
        showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
    tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
        hideComplete:(CJHidePopupViewCompleteBlock)hidePopupViewCompleteBlock {
    
    self.cjExtendView = popupView;
    
    //accordingView在popupView的superView中对应的y、rect值为：
    CGRect accordingViewFrameInHisSuperView = [accordingView.superview convertRect:accordingView.frame toView:popupSuperView];
    //NSLog(@"accordingViewFrameInHisSuperView = %@", NSStringFromCGRect(accordingViewFrameInHisSuperView));
    CGPoint popupViewLocation = CGPointZero;
    if (popupViewPosition == CJPopupViewPositionUnder) {
        CGFloat popupViewX = CGRectGetMinX(accordingView.frame);
        CGFloat popupViewY = CGRectGetMinY(accordingViewFrameInHisSuperView) + CGRectGetHeight(accordingView.frame);
        popupViewLocation = CGPointMake(popupViewX, popupViewY);
    }
    
    
    CGFloat popupViewWidth = CGRectGetWidth(popupView.frame);
    CGFloat popupViewHeight = CGRectGetHeight(popupView.frame);
    CGSize popupViewSize = CGSizeMake(popupViewWidth, popupViewHeight);
    
    [popupView cj_popupInView:popupSuperView
                   atLocation:popupViewLocation
                     withSize:popupViewSize
                 showComplete:showPopupViewCompleteBlock
             tapBlankComplete:tapBlankViewCompleteBlock
                 hideComplete:hidePopupViewCompleteBlock];
}


#pragma mark - 外部接口
/** 完整的描述请参见文件头部 */
- (void)cj_showDropDownView:(UIView *)popupView
                     inView:(UIView *)showInView
               showComplete:(CJShowPopupViewCompleteBlock)showPopupViewCompleteBlock
           tapBlankComplete:(CJTapBlankViewCompleteBlock)tapBlankViewCompleteBlock
               hideComplete:(CJHidePopupViewCompleteBlock)hidePopupViewCompleteBlock {
    
    UIView *accordingView = self;
    [self cj_popupView:popupView
                  inView:showInView
           accordingView:accordingView
        relativePosition:CJPopupViewPositionUnder
            showComplete:showPopupViewCompleteBlock
        tapBlankComplete:tapBlankViewCompleteBlock
            hideComplete:hidePopupViewCompleteBlock];
}




@end
