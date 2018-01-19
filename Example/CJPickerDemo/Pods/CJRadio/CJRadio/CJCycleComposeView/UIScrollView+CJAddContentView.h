//
//  UIScrollView+CJAddContentView.h
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CJAddContentView)

/**
 *  为srollView添加contentView。该contentView的宽为scrollView的widthMultiplier倍，高为scrollView的heightMultiplier倍。
 *
 *  @param widthMultiplier  contentView的宽为scrollView的多少倍
 *  @param heightMultiplier contentView的高为scrollView的多少倍
 *
 *  @return contentView
 */
- (UIView *)cj_addContentViewWithWidthMultiplier:(CGFloat)widthMultiplier heightMultiplier:(CGFloat)heightMultiplier;

@end
