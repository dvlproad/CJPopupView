//
//  UIScrollView+CJAddContentView.m
//  CJRadioDemo
//
//  Created by lichq on 14-11-12.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "UIScrollView+CJAddContentView.h"

@implementation UIScrollView (AddContentView)

- (UIView *)cj_addContentViewWithWidthMultiplier:(CGFloat)widthMultiplier heightMultiplier:(CGFloat)heightMultiplier {
    UIScrollView *scrollView = self;
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:contentView];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1
                                                            constant:0]];
    //right
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1
                                                            constant:0]]; //right = 0;
    //top
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0]];
    
    //bottom(实际上这条是反向设置了scrollView的高)
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1
                                                            constant:0]]; //bottom = 0
    
    
    //设置container的width（这里我们暂时设置contentView为3被scrollView的宽）
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:widthMultiplier
                                                            constant:0]];
    //设置container的height
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:heightMultiplier
                                                            constant:0]];
    
    return contentView;
}


@end
