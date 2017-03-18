//
//  CJDefaultDatePicker.h
//  CJPickerDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDefaultToolbar.h"

/**
 *  含toolbar以及UIDatePicker默认样式的控件
 *
 */
@interface CJDefaultDatePicker : UIView {
    
}
@property (nonatomic, strong) UIDatePicker *datePicker; //UIDatePicker默认216的高
@property (nonatomic, strong) CJDefaultToolbar *toolbar;

@property (nonatomic, copy) void(^valueChangedHandel)(UIDatePicker *datePicker);

@end
