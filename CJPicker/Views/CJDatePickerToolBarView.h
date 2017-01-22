//
//  CJDatePickerToolBarView.h
//  CJPickerToolBarViewDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJDatePickerToolBarView;
@protocol CJDatePickerToolBarViewDelegate <NSObject>
@optional
- (void)confirmDelegate_datePicker:(CJDatePickerToolBarView *)pickerToolBarView;
- (void)valueChangeDelegate_datePicker:(CJDatePickerToolBarView *)pickerToolBarView;


@end




@interface CJDatePickerToolBarView : UIView<CJDatePickerToolBarViewDelegate>{
    
}
//@property (nonatomic, strong) void(^block)(void);
@property(nonatomic, strong) id<CJDatePickerToolBarViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;


- (id)initWithNibNameDefaultAndDelegate:(id<CJDatePickerToolBarViewDelegate>)delegate;
- (id)initWithNibName:(NSString *)nibName delegate:(id<CJDatePickerToolBarViewDelegate>)delegate;

@end
