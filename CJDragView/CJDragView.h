//
//  CJDragView.h
//  CJPopupViewDemo
//
//  Created by dvlproad on 2016/11/05.
//  Copyright © 2016年 dvlproad. All rights reserved.//

#import <UIKit/UIKit.h>


/**
 *  拖曳view的方向
 *
 */
typedef NS_ENUM(NSInteger, CJDragDirection) {
    CJDragDirectionAny,          /**< 任意方向 */
    CJDragDirectionHorizontal,   /**< 水平方向 */
    CJDragDirectionVertical,     /**< 垂直方向 */
};

@interface CJDragView : UIView <UIGestureRecognizerDelegate> {
    
}
@property (nonatomic, assign) BOOL dragEnable;   /**< 是否允许拖曳 */
@property (nonatomic, assign) CJDragDirection dragDirection; /**< 拖曳的方向(默认为any，即任意方向) */
@property (nonatomic, copy) void(^dragBeginBlock)(CJDragView *dragView);    /**< 开始拖曳的回调 */
@property (nonatomic, copy) void(^dragDuringBlock)(CJDragView *dragView);   /**< 拖曳中的回调 */
@property (nonatomic, copy) void(^dragEndBlock)(CJDragView *dragView);      /**< 结束拖曳的回调 */

/**
 活动范围，默认为父视图的frame范围内（因为拖出父视图后无法点击，也没意义）
 如果设置了，则会在给定的范围内活动
 如果没设置，则会在父视图范围内活动
 注意：设置的frame不要大于父视图范围
 注意：设置的frame为0，0，0，0表示活动的范围为默认的父视图frame，如果想要不能活动，请设置dragEnable这个属性为NO
 */
@property (nonatomic,assign) CGRect freeRect;

/**
 是不是保持在边界，默认为NO,没有黏贴边界效果
 isKeepBounds = YES，它将自动黏贴边界，而且是最近的边界
 isKeepBounds = NO， 它将不会黏贴在边界，它是free(自由)状态，跟随手指到任意位置，但是也不可以拖出规定的范围
 */
@property (nonatomic,assign) BOOL isKeepBounds;



/**
 *  初始化（注继承自此类的视图，必须执行[super cjDragView_commonInit]，否则会导致的手势没添加而无法拖动的问题）
 *
 */
- (void)cjDragView_commonInit;

@end


