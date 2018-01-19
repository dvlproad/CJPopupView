//
//  UIScrollView+CJAddContentView.m
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import "UIScrollView+CJAddContentView.h"

@implementation UIScrollView (AddContentView)

- (UIView *)cj_addContentViewWithWidthMultiplier:(CGFloat)widthMultiplier heightMultiplier:(CGFloat)heightMultiplier {
    UIScrollView *scrollView = self;
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:contentView];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //left.right.top.bottom
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0]];
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]];
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0]];
    
    
    //设置contentView的width和height,由此可决定scrollView的contentSize大小
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeWidth  //width
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:widthMultiplier
                                   constant:0]];
    [scrollView addConstraint:
     [NSLayoutConstraint constraintWithItem:contentView
                                  attribute:NSLayoutAttributeHeight //height
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:scrollView
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:heightMultiplier
                                   constant:0]];
    
    return contentView;
}


@end
