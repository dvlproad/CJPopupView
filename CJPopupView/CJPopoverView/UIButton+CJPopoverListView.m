//
//  UIButton+CJPopoverListView.m
//  CJPopupViewDemo
//
//  Created by ciyouzen on 6/24/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "UIButton+CJPopoverListView.h"
#import "CJPopoverListView.h"

@implementation UIButton (CJPopoverListView)

/* 完整的描述请参见文件头部 */
- (void)cj_showDownPopoverListViewWithTitles:(NSArray<NSString *> *)titles
                              selectRowBlock:(void (^)(NSInteger selectedIndex))selectRowBlock
{
    UIView *dropPopoverListOwner = self; //由哪个视图弹出带箭头的列表视图,默认self,有时是navigationBar
    if ([self.superview.superview.superview isKindOfClass:[UINavigationBar class]]) {
        dropPopoverListOwner = (UINavigationBar *)self.superview.superview.superview;
    }
    
    //UIView *convertToView = popoverListUpperView.view;
    UIView *convertToView = dropPopoverListOwner.superview;
    
    CGPoint point_origin = CGPointMake(dropPopoverListOwner.center.x, dropPopoverListOwner.center.y + dropPopoverListOwner.frame.size.height/2);
    CGPoint point = [dropPopoverListOwner.superview convertPoint:point_origin toView:convertToView];
    
    CJPopoverListView *popoverView = [[CJPopoverListView alloc] initWithPoint:point titles:titles images:nil];
    popoverView.selectRowAtIndex = ^(NSInteger index) {
        [self setTitle:titles[index] forState:UIControlStateNormal];
        if (selectRowBlock) {
            selectRowBlock(index);
        }
    };
    [popoverView showPopoverView];
}

@end
