//
//  RadioButtons_Slider.h
//  RadioButtonsDemo
//
//  Created by lichq on 15/11/11.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//

#import "RadioButtons.h"

@interface RadioButtons_Slider : RadioButtons{
    
}
- (void)addArrowImage_Left:(UIImage *)imageLeft Right:(UIImage *)imageRight;//添加左右滑动箭头

/**
 *  设置指定Index的Tab为选中状态
 *
 *  @param index
 */
- (void)selectRadioButtonIndex:(NSInteger)index;

@end
