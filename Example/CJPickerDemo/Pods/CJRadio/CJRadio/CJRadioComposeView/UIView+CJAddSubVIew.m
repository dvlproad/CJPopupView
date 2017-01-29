//
//  UIView+CJAddSubVIew.m
//  CJRadioDemo
//
//  Created by lichq on 14-11-12.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "UIView+CJAddSubVIew.h"

@implementation UIView (CJAddSubVIew)

- (void)cj_addSubView:(UIView *)subView withEdgeInsets:(UIEdgeInsets)edgeInsets {
    [self addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:edgeInsets.left]];
    //right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:edgeInsets.right]];
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:edgeInsets.top]];
    //bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:edgeInsets.bottom]];
}

@end
