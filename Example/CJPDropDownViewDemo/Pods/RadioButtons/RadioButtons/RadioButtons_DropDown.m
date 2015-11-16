//
//  RadioButtons_DropDown.m
//  RadioButtonsDemo
//
//  Created by lichq on 15/11/11.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "RadioButtons_DropDown.h"

@implementation RadioButtons_DropDown

- (BOOL)shouldUpdateRadioButtonSelected_WhenClickSameRadioButton{   //可根据情况为YES或NO
    return YES; //设默认可重复点击（YES:可重复点击  NO:不可重复点击）
}


- (void)shouldMoveScrollViewToSelectItem:(RadioButton *)radioButton{
    //do nothing...
}



@end
