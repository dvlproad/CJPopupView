//
//  RadioButtons.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 7/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RadioButton.h"

@class RadioButtons;
@protocol RadioButtonsDelegate <NSObject>

@optional

- (void)radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index;
@end



//由于点击RadioButton的时候，还要涉及到其他RadioButton中图标的变化，所以RadioButtons不适合再分开。
@interface RadioButtons : UIView<RadioButtonDelegate>{
    NSInteger currentExtendSection;//当前展开的section ，默认－1时，表示都没有展开
}

@property (nonatomic, strong) id <RadioButtonsDelegate>delegate;
@property (nonatomic, strong) UIView *m_SuperView;
@property (nonatomic, strong) UIView *tapV;
@property (nonatomic, strong) UIView *extendView;


- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName;
- (void)showDropDownExtendView:(UIView *)extendView_m inView:(UIView *)superView complete:(void(^)(void))block;
- (void)didSelectInExtendView:(NSString *)title;


@end
