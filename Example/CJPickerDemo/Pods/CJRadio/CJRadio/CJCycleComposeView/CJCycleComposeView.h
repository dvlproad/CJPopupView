//
//  CJCycleComposeView.h
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

///滑动类型
typedef NS_ENUM(NSUInteger, CJCycleComposeViewScrollType) {
    CJCycleComposeViewScrollTypeNormal,
    CJCycleComposeViewScrollTypeBanScrollHorizontal,      /**< 禁用水平方向滑动 */
//    CJCycleComposeViewScrollTypeBanScrollVertical,      /**< 禁用竖直方向滑动 */ (暂时只有左中右即暂时顶多只能水平滑动)
    CJCycleComposeViewScrollTypeBanScrollCycle,           /**< 禁止循环滚动 */
};



@class CJCycleComposeView;
@protocol CJCycleComposeViewDataSource <NSObject>

@required
/**
 *  view数组
 *
 *  @return view数组
 */
- (NSArray<UIView *> *)cj_radioViewsInCJCycleComposeView:(CJCycleComposeView *)cycleComposeView;


@optional
/**
 *  默认显示第几个view
 *
 *  @return 默认显示的view的index
 */
- (NSInteger)cj_defaultShowIndexInCJCycleComposeView:(CJCycleComposeView *)CJCycleComposeView; // Default is 0 if not implemented

@end



@protocol CJCycleComposeViewDelegate <NSObject>

/**
 *  CJCycleComposeView上选中的index改变时触发
 *
 *  @param cycleComposeView cycleComposeView
 *  @param index            index
 */
- (void)cj_cycleComposeView:(CJCycleComposeView *)cycleComposeView didChangeToIndex:(NSInteger)index;

@end




/**
 *  一个可以无限循环的视图组合类(常用于视图组合各异的轮播图)
 */
@interface CJCycleComposeView : UIView {
    
}
@property (nonatomic, weak) id <CJCycleComposeViewDataSource> dataSource;
@property (nonatomic, weak) id <CJCycleComposeViewDelegate> delegate;
@property (nonatomic, assign) CJCycleComposeViewScrollType scrollType;  /**< 滑动类型 */
@property (nonatomic, assign, readonly) NSInteger currentShowViewIndex; /**< 当前显示的视图(即中视图)上的视图内容在所有view中的位置 */

//当所添加的view不足三个的时候，需要多用到以下这一个参数
@property (nonatomic, assign) BOOL canScrollWhenViewCountLessThree; /**< 当views的个数小于三个的时候，是否允许滚动(默认YES) */

/**
 *  重新加载View视图
 */
- (void)reloadViews;

/**
 *  显示第几个View（即将第viewIndex位置的View显示到centerView中）
 *
 *  @param showViewIndex    要显示的view的索引
 *  @param animated         是否切换动画
 */
- (void)cj_selectComponentAtIndex:(NSInteger)showViewIndex animated:(BOOL)animated;

/**
 *  滑动到显示的视图(即中视图)
 *  @attention  请在viewDidLayoutSubviews调用
 *
 *  @param animated 滚动过程中是否要有动画
 */
- (void)cj_scrollToCenterViewWithAnimated:(BOOL)animated;

@end
