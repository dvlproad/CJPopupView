//
//  CJIndependentPickerView.h
//  CJPickerToolBarViewDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJIndependentPickerView;
@protocol CJIndependentPickerViewDelegate <NSObject>
@optional
- (void)confirmDelegate_pickerView:(CJIndependentPickerView *)pickerToolBarView;
- (void)valueChangeDelegate_pickerView:(CJIndependentPickerView *)pickerToolBarView;


@end



@interface CJIndependentPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate, CJIndependentPickerViewDelegate>{
    
}
//@property (nonatomic, strong) void(^block)(void);
@property(nonatomic, strong) id<CJIndependentPickerViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *selecteds;
@property (nonatomic, strong) NSArray *selecteds_default;

- (id)initWithNibNameDefaultAndDelegate:(id<CJIndependentPickerViewDelegate>)delegate;
- (id)initWithNibName:(NSString *)nibName delegate:(id<CJIndependentPickerViewDelegate>)delegate;

@end
