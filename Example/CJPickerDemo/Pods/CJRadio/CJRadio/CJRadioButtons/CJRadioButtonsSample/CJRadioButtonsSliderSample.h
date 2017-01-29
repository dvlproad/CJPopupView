//
//  CJRadioButtonsSliderSample.h
//  CJRadioDemo
//
//  Created by lichq on 14-11-5.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "RadioButtons.h"

@class CJRadioButtonsSliderSample;
@protocol CJRadioButtonsSliderSampleDataSource <NSObject>

- (UIView *)cj_RadioButtonsSliderSample:(CJRadioButtonsSliderSample *)RadioButtonsSliderSample viewForButtonIndex:(NSInteger)index;

@end



@interface CJRadioButtonsSliderSample : RadioButtons {
    
}
@property (nonatomic, weak) id<CJRadioButtonsSliderSampleDataSource> radioButtonsSliderSampleDataSource;
@property (nonatomic, strong, readonly) NSArray *titles;

/**
 *  初始设置包含弹出视图的按钮组合成品
 *
 *  @param titles               按钮标题组合
 *  @param defaultShowIndex     默认选中第几个按钮(-1表示不选中任何一个)
 *  @param maxButtonShowCount   最大显示第几个
 */
- (void)setupWithTitles:(NSArray *)titles
       defaultShowIndex:(NSInteger)defaultShowIndex
     maxButtonShowCount:(NSInteger)maxButtonShowCount;

@end
