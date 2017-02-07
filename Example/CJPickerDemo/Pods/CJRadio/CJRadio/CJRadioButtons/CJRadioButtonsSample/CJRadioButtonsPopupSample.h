//
//  CJRadioButtonsPopupSample.h
//  CJRadioDemo
//
//  Created by lichq on 14-11-5.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "RadioButtons.h"
#import <CJPopupAction/UIView+CJShowExtendView.h>

typedef NS_ENUM(NSUInteger, CJRadioButtonsPopupType) {
    CJRadioButtonsPopupTypeUnderAll,
    CJRadioButtonsPopupTypeUnderCurrent,
    CJRadioButtonsPopupTypeWindowBottom,
};

@class CJRadioButtonsPopupSample;
@protocol CJRadioButtonsPopupSampleDataSource <NSObject>

- (UIView *)cj_RadioButtonsPopupSample:(CJRadioButtonsPopupSample *)radioButtonsPopupSample viewForButtonIndex:(NSInteger)index;

@end

@interface CJRadioButtonsPopupSample : RadioButtons {
    
}
@property (nonatomic, weak) id<CJRadioButtonsPopupSampleDataSource> radioButtonsPopupSampleDataSource;
@property (nonatomic, strong, readonly) NSArray *titles;

/**
 *  初始设置包含弹出视图的按钮组合成品
 *
 *  @param titles               按钮标题组合
 *  @param dropDownImage        箭头
 *  @param popupSuperview       弹出视图到哪里
 *  @param popupType            弹出视图的位置
 */
- (void)setupWithTitles:(NSArray *)titles
          dropDownImage:(UIImage *)dropDownImage
         popupSuperview:(UIView *)popupSuperview
              popupType:(CJRadioButtonsPopupType)popupType;
@end
