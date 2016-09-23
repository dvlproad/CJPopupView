//
//  CJPopoverView.h
//  CJPopoverViewDemo
//
//  Created by lichq on 6/24/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJPopoverView : UIView{
    BOOL isArrowDown;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)showPopoverView;
-(void)dismissPopoverView:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
