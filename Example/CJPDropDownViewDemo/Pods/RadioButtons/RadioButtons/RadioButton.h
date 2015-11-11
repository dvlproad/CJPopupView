//
//  RadioButton.h
//  RadioButtonsDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;
@protocol RadioButtonDelegate <NSObject>

@optional
- (void)radioButtonClick:(RadioButton *)radioButton_cur;
@end

/*
@protocol RadioButtonDataSource <NSObject>

@optional
- (NSInteger)numberOfSectionsInRadioButton:(RadioButton *)radioButton;
@end
*/



@interface RadioButton : UIView{
    
}
@property(nonatomic, strong) IBOutlet UIButton *btn;
@property(nonatomic, strong) IBOutlet UILabel *lab; //当title字数多或者需多行时有用
@property(nonatomic, strong) IBOutlet UIImageView *imageV;
@property(nonatomic, assign) BOOL selected;
/*
@property (nonatomic, strong) id<RadioButtonDataSource> dataSource;
*/
@property (nonatomic, strong) id<RadioButtonDelegate> delegate;


- (void)setTitle:(NSString *)title;

- (id)initWithNibNamed:(NSString *)nibName frame:(CGRect)frame;

@end
