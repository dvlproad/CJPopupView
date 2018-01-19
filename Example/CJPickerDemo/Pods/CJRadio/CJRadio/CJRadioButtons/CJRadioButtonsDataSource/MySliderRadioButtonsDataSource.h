//
//  MySliderRadioButtonsDataSource.h
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJRadioButtons.h"

///等宽的单选按钮,已支持刷新功能
@interface MySliderRadioButtonsDataSource : NSObject <RadioButtonsDataSource> {
    
}
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger defaultSelectedIndex;   /**< 初始默认选中第几个按钮 */
@property (nonatomic, assign) NSInteger maxButtonShowCount; /**< 显示区域显示的个数超过多少就开始滑动 */

@end
