//
//  RadioComposeView.h
//  CJRadioDemo
//
//  Created by lichq on 14-11-12.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RadioComposeViewScrollType) {
    RadioComposeViewScrollTypeNormal,
    RadioComposeViewScrollTypeBanScrollHorizontal,      /**< 禁用水平方向滑动 */
//    RadioComposeViewScrollTypeBanScrollVertical,      /**< 禁用竖直方向滑动 */ (暂时只有左中右即暂时顶多只能水平滑动)
    RadioComposeViewScrollTypeBanScrollCycle,           /**< 禁止循环滚动 */
};

@class RadioComposeView;


@protocol RadioComposeViewDataSource <NSObject>

@required
/**
 *  view数组
 *
 *  @return view数组
 */
- (NSArray<UIView *> *)cj_radioViewsInRadioComposeView:(RadioComposeView *)radioComposeView;


@optional
/**
 *  默认显示第几个view
 *
 *  @return 默认显示的view的index
 */
- (NSInteger)cj_defaultShowIndexInRadioComposeView:(RadioComposeView *)radioComposeView; // Default is 0 if not implemented

@end



@protocol RadioComposeViewDelegate <NSObject>

/**
 *  radioComposeView上选中的index改变时触发
 *
 *  @param radioComposeView radioComposeView
 *  @param index            index
 */
- (void)cj_radioComposeView:(RadioComposeView *)radioComposeView didChangeToIndex:(NSInteger)index;

@end




/**
 *  单选View的组合类
 */
@interface RadioComposeView : UIView {
    
}
@property (nonatomic, weak) id <RadioComposeViewDataSource> dataSource;
@property (nonatomic, weak) id <RadioComposeViewDelegate> delegate;
@property (nonatomic, assign) RadioComposeViewScrollType scrollType;
@property (nonatomic, assign, readonly) NSInteger currentShowViewIndex; /**< 当前显示的视图(即中视图)上的视图内容在所有view中的位置 */

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
 *
 *  @param isAnimate 滚动过程中是否要有动画
 */
- (void)scrollToCenterViewWithAnimate:(BOOL)isAnimate;

@end
