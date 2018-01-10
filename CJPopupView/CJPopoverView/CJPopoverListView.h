//
//  CJPopoverListView.h
//  CJPopoverViewDemo
//
//  Created by ciyouzen on 6/24/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDrawRectUtil.h"

@interface CJPopoverListView : UIView{
    BOOL isArrowDown;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)showPopoverView;
-(void)dismissPopoverView:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
