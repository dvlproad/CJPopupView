//
//  MyButton.m
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
}


//设置Button内部的image的范围
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageOriginX = 0;
    CGFloat imageOriginY = 0;
    CGFloat imageWidth = 0;
    CGFloat imageHeight = 0;
    switch (self.imagePosition) {
        case MyButtonImagePositionRight:
        {
            imageOriginY = 0;
            imageWidth = 0.3 * CGRectGetWidth(contentRect);
            imageHeight = CGRectGetHeight(contentRect);
            imageOriginX = CGRectGetWidth(contentRect)-imageHeight;
            break;
        }
        case MyButtonImagePositionBottom:
        {
            imageHeight = 0.3 * CGRectGetHeight(contentRect);
            imageWidth = imageHeight;
            imageOriginX = (CGRectGetWidth(contentRect) - imageWidth)/2;
            imageOriginY = 0.7 * CGRectGetHeight(contentRect);
            break;
        }
        default:
            break;
    }
    CGRect imageRect = CGRectMake(imageOriginX, imageOriginY, imageWidth, imageHeight);
    return imageRect;
}

//设置Button内部的title的范围
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleOriginX = 0;
    CGFloat titleOriginY = 0;
    CGFloat titleWidth = 0;
    CGFloat titleHeight = 0;
    switch (self.imagePosition) {
        case MyButtonImagePositionRight:
        {
            titleOriginX = 0;
            titleOriginY = 0;
            titleHeight = CGRectGetHeight(contentRect);
            titleWidth = 0.7 * CGRectGetWidth(contentRect);
            break;
        }
        case MyButtonImagePositionBottom:
        {
            titleOriginX = 0;
            titleWidth = CGRectGetWidth(contentRect);
            titleHeight = 0.7 * CGRectGetHeight(contentRect);
            titleOriginY = 0;
            break;
        }
        default:
            break;
    }
    CGRect titleRect = CGRectMake(titleOriginX, titleOriginY, titleWidth, titleHeight);
    
    return titleRect;
}


@end
