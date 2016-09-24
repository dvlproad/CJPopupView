//
//  RadioButtons.h
//  RadioButtonsDemo
//
//  Created by lichq on 7/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RadioButton.h"

#define RadioButton_TAG_BEGIN   1000

typedef NS_ENUM(NSUInteger, RadioButtonType) {
    RadioButtonTypeNormal = 0,
    RadioButtonTypeCanDrop,
    RadioButtonTypeCanSlider    //RadioButtonTypeCanSlider 等价于RadioButtonTypeNormal
};

@class RadioButtons;

@protocol RadioButtonsDataSource <NSObject>
@required
- (NSInteger)cj_numberOfComponentsInRadioButtons:(RadioButtons *)radioButtons;

- (RadioButton *)cj_radioButtons:(RadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index;

- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index;

@optional
/**
 *  设置初始默认选中第几个(默认-1,即无任何选择)
 *
 *  @param radioButtons radioButtons
 *
 *  @return 默认显示的view的index
 */
- (NSInteger)cj_defaultShowIndexInRadioButtons:(RadioButtons *)radioButtons; // Default is -1 if not implemented

@end



@protocol RadioButtonsDelegate <NSObject>
@required
- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old;

@end






//由于点击RadioButton的时候，还要涉及到其他RadioButton中图标的变化，所以RadioButtons不适合再分开。
@interface RadioButtons : UIView {
    
}
@property (nonatomic, weak) id <RadioButtonsDataSource> dataSource;
@property (nonatomic, weak) id <RadioButtonsDelegate> delegate;
@property (nonatomic, assign) RadioButtonType radioButtonType;
@property (nonatomic, assign) NSInteger currentSelectedIndex;   /**< 当前选中的按钮的index值（当该值为默认的－1时，表示都没有选中） */
@property (nonatomic, assign) BOOL showLineImageView;   /**< 是否显示底部线 */
@property (nonatomic, strong) UIImage *lineImage;       /**< 底部线的图片 */
@property (nonatomic, assign) CGFloat lineImageViewHeight;  /**< 底部线的图片的高度（默认1） */


/**
 *  reloadViews
 */
- (void)reloadViews;


/**
 *  选中第index个单选按钮
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
