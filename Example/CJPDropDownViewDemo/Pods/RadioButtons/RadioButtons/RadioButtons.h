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

@optional

- (void)radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index;
@end



//由于点击RadioButton的时候，还要涉及到其他RadioButton中图标的变化，所以RadioButtons不适合再分开。
@interface RadioButtons : UIView<RadioButtonDelegate, UIScrollViewDelegate>{
    NSInteger currentExtendSection;//当前展开的section ，默认－1时，表示都没有展开
    NSInteger countTitles;
}
@property (nonatomic, strong) UIScrollView *sv;//当要显示的radiobutton太多时有用（可通过滑动查看）
@property (nonatomic, strong) id <RadioButtonsDelegate>delegate;

- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName;
- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName andShowIndex:(NSInteger)showIndex;


- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton;
- (BOOL)shouldDidDelegate_WhenClickSameRadioButton;

- (void)doSomethingExtra_WhenClickSameRadioButton:(RadioButton *)radioButton_same;
- (void)doSomethingExtra_WhenClickNewRadioButton:(RadioButton *)radioButton;
- (void)shouldMoveScrollViewToSelectItem:(RadioButton *)radioButton;

@end
