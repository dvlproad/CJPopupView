//
//  CJIndependentPickerView.h
//  CJPickerDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDefaultToolbar.h"

/**
 *  含toolbar以及UIPickerView默认样式的控件（用于例如体重60.5kg各部分的独立选择）
 *
 */
@interface CJIndependentPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>{
    
}
@property (nonatomic, strong) UIPickerView *pickerView; //UIPickerView默认216的高
@property (nonatomic, strong) CJDefaultToolbar *toolbar;

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *selecteds;
@property (nonatomic, strong) NSArray *selecteds_default;


@property (nonatomic, copy) void(^valueChangedHandel)(UIPickerView *pickerView);

@end
