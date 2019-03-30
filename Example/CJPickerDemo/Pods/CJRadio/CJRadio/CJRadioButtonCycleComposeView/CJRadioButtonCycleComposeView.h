//
//  CJRadioButtonCycleComposeView.h
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJRadioButtons.h"
#import "CJCycleComposeView.h"

#import "CJRadioModule.h"

/**
 *  一个整合了单选按钮和循环视图的视图
 */
@class CJRadioButtonCycleComposeView;
@protocol CJButtonControllerViewDataSource <NSObject>

@required
/** 获取数据源 */
- (CJButton *)cj_buttonControllerView:(CJRadioButtonCycleComposeView *)buttonControllerView cellForComponentAtIndex:(NSInteger)index;

@end


@protocol CJButtonControllerViewDelegate <NSObject>

- (void)cj_buttonControllerView:(CJRadioButtonCycleComposeView *)buttonControllerView didChangeToIndex:(NSInteger)index;

@end





@interface CJRadioButtonCycleComposeView : UIView {
    
}
@property (nonatomic, weak) id <CJButtonControllerViewDataSource> dataSource;
@property (nonatomic, weak) id <CJButtonControllerViewDelegate> delegate;


@property (nonatomic, strong) NSArray<CJRadioModule *> *radioModules;


//设置CJRadioButtons需要的数据
@property (nonatomic, assign) BOOL hideSeparateLine;    /**< 是否隐藏分割线(默认NO) */
@property (nonatomic, assign) BOOL showBottomLineView;  /**< 是否显示底部线 */
@property (nonatomic, strong) UIImage *bottomLineImage; /**< 底部线的图片 */
@property (nonatomic, strong) UIColor *bottomLineColor; /**< 底部线的图片 */
@property (nonatomic, assign) CGFloat bottomLineViewHeight;  /**< 底部线的图片的高度（默认1） */
@property (nonatomic, assign) CGFloat bottomLineViewWidth;  /**< 底部线的图片的宽度（无设置时候等于按钮宽度） */

@property (nonatomic, assign) CGFloat radioButtonsHeight;   /**< 控件radioButtons的高度 */
//@property (nonatomic, assign) CGFloat radioButtonsLeftViewWdith;    /**< 控件radioButtons左侧视图的宽度 */
//@property (nonatomic, assign) CGFloat radioButtonsRightViewWdith;    /**< 控件radioButtons右侧视图的宽度 */

//设置CJCycleComposeView需要的数据
@property (nonatomic, assign) CJCycleComposeViewScrollType scrollType;  /**< 滑动类型 */
@property (nonatomic, strong) UIViewController *componentViewParentViewController;

//设置Self其他设置需要的数据
@property (nonatomic, assign) NSInteger defaultSelectedIndex;           /**< 默认选择第几个0 */
@property (nonatomic, assign) NSInteger maxRadioButtonsShowViewCount;   /**< 最大展示个数，默认3 */

/**
 *  滚动到当前选中的视图
 *
 *  @param animated 是否有滚动动画
 */
- (void)scollToCurrentSelectedViewWithAnimated:(BOOL)animated;

- (void)reloadData;   //TODO: 用于类似栏目变更操作

/**
 *  为view添加左侧箭头视图和右侧箭头视图
 *
 *  @param leftArrowImage  左侧箭头视图
 *  @param rightArrowImage 右侧箭头视图
 *  @param arrowImageWidth 两个箭头视图共同的宽度
 */
- (void)addLeftArrowImage:(UIImage *)leftArrowImage
          rightArrowImage:(UIImage *)rightArrowImage
      withArrowImageWidth:(CGFloat)arrowImageWidth;

/**
 *  在radioButtons左侧添加视图
 *
 *  @param radioButtonsLeftView      radioButtons的左侧视图
 *  @param radioButtonsLeftViewWidth radioButtons左侧视图的宽度
 */
- (void)addRadioButtonsLeftView:(UIView *)radioButtonsLeftView withWidth:(CGFloat)radioButtonsLeftViewWidth;

/**
 *  在radioButtons右侧添加视图（可用来设置一些比如栏目添加的按钮视图）
 *
 *  @param radioButtonsRightView      radioButtons的右侧视图
 *  @param radioButtonsRightViewWidth radioButtons右侧视图的宽度
 */
- (void)addRadioButtonsRightView:(UIView *)radioButtonsRightView withWidth:(CGFloat)radioButtonsRightViewWidth;

@end
