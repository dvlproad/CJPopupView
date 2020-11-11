//
//  PopoverView.m
//  CJPopupViewDemo
//
//  Created by 李超前 on 2018/1/10.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "PopoverView.h"
#import "CJDrawRectUtil.h"

@implementation PopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CJArrowDirection arrowDirection = CJArrowDirectionUp;
    CGPoint arrowPoint = CGPointMake(CGRectGetWidth(rect)/2, 0);
    CGFloat arrowHeight = 10;
    CGFloat arrowCurvature = 6.0f;
    UIColor *arrowBorderColor = [UIColor redColor];
    UIColor *arrowFillColor = [UIColor greenColor];
    
    [CJDrawRectUtil drawArrowInRect:rect
                 withArrowDirection:arrowDirection
                         arrowPoint:arrowPoint
                        arrowHeight:arrowHeight
                     arrowCurvature:arrowCurvature
                   arrowBorderColor:arrowBorderColor
                     arrowFillColor:arrowFillColor];
}

@end
