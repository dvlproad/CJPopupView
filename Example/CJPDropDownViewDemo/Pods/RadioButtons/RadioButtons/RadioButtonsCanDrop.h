//
//  RadioButtonsCanDrop.h
//  RadioButtonsDemo
//
//  Created by 李超前 on 15/11/16.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RadioButton.h"

#define RadioButton_TAG_BEGIN   1000

@class RadioButtonsCanDrop;
@protocol RadioButtonsCanDropDelegate <NSObject>

@optional

- (void)radioButtonsCanDrop:(RadioButtonsCanDrop *)radioButtonsCanDrop chooseIndex:(NSInteger)index;
@end




@interface RadioButtonsCanDrop : UIView<RadioButtonDelegate, UIScrollViewDelegate>{
    NSInteger currentExtendSection;//当前展开的section ，默认－1时，表示都没有展开
    NSInteger countTitles;
}
@property (nonatomic, strong) UIScrollView *sv;//当要显示的radiobutton太多时有用（可通过滑动查看）
@property (nonatomic, strong) id <RadioButtonsCanDropDelegate>delegate;

- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName;
- (void)setTitles:(NSArray *)titles radioButtonNidName:(NSString *)nibName andShowIndex:(NSInteger)showIndex;


@property (nonatomic, strong) UIView *m_SuperView;
@property (nonatomic, strong) UIView *tapV;
@property (nonatomic, strong) UIView *extendView;

- (void)radioButtonsCanDrop_showDropDownExtendView:(UIView *)extendView_m inView:(UIView *)superView complete:(void(^)(void))block;
- (void)radioButtonsCanDrop_didSelectInExtendView:(NSString *)title;

@end
