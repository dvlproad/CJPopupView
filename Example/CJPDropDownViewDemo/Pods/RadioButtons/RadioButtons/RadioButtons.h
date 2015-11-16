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

@class RadioButtons;
@protocol RadioButtonsDelegate <NSObject>
@required
- (void)radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old;

@end



//由于点击RadioButton的时候，还要涉及到其他RadioButton中图标的变化，所以RadioButtons不适合再分开。
@interface RadioButtons : UIView<RadioButtonDelegate, UIScrollViewDelegate>{
    NSInteger countTitles;
}
@property (nonatomic, strong) UIScrollView *sv;//当要显示的radiobutton太多时有用（可通过滑动查看）
@property (nonatomic, strong) id <RadioButtonsDelegate>delegate;
@property (nonatomic, assign) NSInteger index_cur;//当前展开的index ，默认－1时，表示都没有展开

- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName;
- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName andShowIndex:(NSInteger)showIndex;


- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton;
- (void)shouldMoveScrollViewToSelectItem:(RadioButton *)radioButton;


- (void)changeCurrentRadioButtonStateAndTitle:(NSString *)title;
- (void)changeCurrentRadioButtonState;
- (void)setSelectedNone; //设置为未选择任何radioButton

@end
