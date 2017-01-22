//
//  RadioButton.m
//  RadioButtonsDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton

- (void)awakeFromNib{
    [self.button addTarget:self action:@selector(radioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.textColor = self.isSelected ? self.textSelectedColor : self.textNormalColor;
}

- (void)setTitle:(NSString *)title {
    //[self.button  setTitle:title forState:UIControlStateNormal];
    [self.label setText:title];
}

- (void)setSelected:(BOOL)selected {
    if (selected == _selected) {    //如果选中的一样则不进行操作，比如imageV就不进行transform了
        return;
    }
    
    _selected = selected;
    self.button.selected = selected;
    self.label.textColor = selected ? self.textSelectedColor : self.textNormalColor;
    
    
    if (self.stateChangeCompleteBlock) {
        self.stateChangeCompleteBlock(self);
    }
}

- (void)radioButtonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(radioButtonClick:)]) {
        [self.delegate radioButtonClick:self];
    }
}

@end
