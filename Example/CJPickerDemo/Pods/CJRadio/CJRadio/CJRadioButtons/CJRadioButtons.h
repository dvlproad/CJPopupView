//
//  CJRadioButtons.h
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CJButton.h"

typedef NS_ENUM(NSUInteger, CJRadioButtonType) {
    RadioButtonTypeNormal = 0,
    RadioButtonTypeCanDrop,
    RadioButtonTypeCanSlider    //RadioButtonTypeCanSlider 等价于RadioButtonTypeNormal
};

@class CJRadioButtons;

@protocol CJRadioButtonsDataSource <NSObject>
@required
- (NSInteger)cj_numberOfComponentsInRadioButtons:(CJRadioButtons *)radioButtons;

- (CJButton *)cj_radioButtons:(CJRadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index;

- (CGFloat)cj_radioButtons:(CJRadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index;

@optional
/**
 *  设置初始默认选中第几个(默认-1,即无任何选择)
 *
 *  @param radioButtons radioButtons
 *
 *  @return 默认显示的view的index
 */
- (NSInteger)cj_defaultShowIndexInRadioButtons:(CJRadioButtons *)radioButtons; // Default is -1 if not implemented

@end



@protocol CJRadioButtonsDelegate <NSObject>
@required
- (void)cj_radioButtons:(CJRadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old;

@end






//由于点击CJButton的时候，还要涉及到其他CJButton中图标的变化，所以CJRadioButtons不适合再分开。
@interface CJRadioButtons : UIView {
    
}
@property (nonatomic, strong, readonly) NSArray<CJButton *> *radioButtons;/**< 所有的单选按钮数组 */
@property (nonatomic, assign, readonly) NSInteger currentSelectedIndex;   /**< 当前选中的按钮的index值（当该值为默认的－1时，表示都没有选中） */

@property (nonatomic, weak) id <CJRadioButtonsDataSource> dataSource;
@property (nonatomic, weak) id <CJRadioButtonsDelegate> delegate;

@property (nonatomic, assign) CJRadioButtonType radioButtonType;
@property (nonatomic, assign) BOOL hideSeparateLine;    /**< 是否隐藏分割线(默认NO) */
@property (nonatomic, assign) BOOL showBottomLineView;  /**< 是否显示底部线 */
@property (nonatomic, strong) UIImage *bottomLineImage; /**< 底部线的图片 */
@property (nonatomic, strong) UIColor *bottomLineColor; /**< 底部线的背景色 */
@property (nonatomic, assign) CGFloat bottomLineViewHeight; /**< 底部线的图片的高度（默认1） */
@property (nonatomic, assign) CGFloat bottomLineViewWidth;  /**< 底部线的图片的宽度（无设置时候等于按钮宽度） */

/**
 *  当数据源改变时，可调用此接口更新视图
 */
- (void)reloadViews;

/**
 *  滚动到当前选中的视图
 *
 *  @param animated 是否有滚动动画
 */
- (void)scollToCurrentSelectedViewWithAnimated:(BOOL)animated;


/**
 *  选中/点亮第index个单选按钮
 *
 *  @param index    要选择的单选按钮的索引值
 *  @param animated 是否动画
 */
- (void)cj_selectComponentAtIndex:(NSInteger)index animated:(BOOL)animated;


#pragma mark - 有左右箭头的时候
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
 *  改变当前选中的单选按钮的状态和文字
 *
 *  @param title 当前选中的按钮文字设置为title
 */
- (void)changeCurrentRadioButtonStateAndTitle:(NSString *)title;

/**
 *  改变当前选中的单选按钮的状态
 */
- (void)changeCurrentRadioButtonState;

/**
 *  设置为未选择任何radioButton
 */
- (void)setSelectedNone;

@end
