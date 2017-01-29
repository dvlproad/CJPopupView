//
//  CJRadioButtonsDropDownSample.h
//  CJRadioDemo
//
//  Created by lichq on 14-11-5.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "RadioButtons.h"

typedef NS_ENUM(NSUInteger, CJRadioButtonsDropDownType) {
    CJRadioButtonsDropDownTypeUnderAll,
    CJRadioButtonsDropDownTypeUnderCurrent,
};

@class CJRadioButtonsDropDownSample;
@protocol CJRadioButtonsDropDownSampleDataSource <NSObject>

- (UIView *)cj_RadioButtonsPopupSample:(CJRadioButtonsDropDownSample *)radioButtonsPopupSample viewForButtonIndex:(NSInteger)index;

@end

@interface CJRadioButtonsDropDownSample : RadioButtons {
    
}
@property (nonatomic, weak) id<CJRadioButtonsDropDownSampleDataSource> radioButtonsPopupSampleDataSource;
@property (nonatomic, strong, readonly) NSArray *titles;

/**
 *  初始设置包含弹出视图的按钮组合成品
 *
 *  @param titles               按钮标题组合
 *  @param dropDownImage        箭头
 *  @param popupSuperview       弹出视图到哪里
 *  @param dropDownUnderType    弹出视图的位置
 */
- (void)setupWithTitles:(NSArray *)titles
          dropDownImage:(UIImage *)dropDownImage
         popupSuperview:(UIView *)popupSuperview
      dropDownUnderType:(CJRadioButtonsDropDownType)dropDownUnderType;
@end
