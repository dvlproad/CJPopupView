//
//  RadioButton.h
//  RadioButtonsDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;


typedef void(^RadioButtonStateChangeCompleteBlock)(RadioButton *radioButton);

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@protocol RadioButtonDelegate <NSObject>

@optional
- (void)radioButtonClick:(RadioButton *)radioButton_cur;
@end



@interface RadioButton : UIView {
    
}
@property (nonatomic, weak) id<RadioButtonDelegate> delegate;
@property (nonatomic, assign) NSInteger index;  /**< 单选按钮的索引，在RadioButtons里有用 */
@property (nonatomic, strong) IBOutlet UIButton *button;
@property (nonatomic, strong) IBOutlet UILabel *label; //当title字数多或者需多行时有用
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, strong) UIColor *textNormalColor;   /**< 单选按钮正常时的文字颜色 */
@property (nonatomic, strong) UIColor *textSelectedColor; /**< 单选按钮选中时的文字颜色 */
@property (nonatomic, copy) RadioButtonStateChangeCompleteBlock stateChangeCompleteBlock; /**< 单选按钮(选中)状态改变后的block(可用来做一些图片的transform旋转等) */

- (void)setTitle:(NSString *)title;

@end
