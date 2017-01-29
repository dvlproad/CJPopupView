//
//  CJRelatedPickerView.h
//  CJPickerToolBarViewDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJRelatedPickerView;
@protocol CJRelatedPickerViewDelegate <NSObject>
@optional
- (void)confirmDelegate_pickerArea:(CJRelatedPickerView *)pickerToolBarView;
- (void)valueChangeDelegate_pickerArea:(CJRelatedPickerView *)pickerToolBarView;


@end


/**
 *  用于例如地区"福建-厦门-思明"各部分的关联选择
 *
 */
@interface CJRelatedPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate, CJRelatedPickerViewDelegate>{
    
}
//@property (nonatomic, strong) void(^block)(void);
@property(nonatomic, strong) id<CJRelatedPickerViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *selecteds;
@property (nonatomic, strong) NSArray *selecteds_default;

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSArray *dicArray;

+ (NSMutableArray *)getDatasByDatasC_0:(NSArray *)m_datasC_0 dicArray:(NSArray *)m_dicArray;

- (id)initWithNibNameDefaultAndDelegate:(id<CJRelatedPickerViewDelegate>)delegate;
- (id)initWithNibName:(NSString *)nibName delegate:(id<CJRelatedPickerViewDelegate>)delegate;

@end
