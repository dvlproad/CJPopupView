//
//  CJButtonsSingleTableView.h
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RadioButtons/RadioButtons.h>
#import <CJPopupView/UIView+CJShowExtendView.h>
#import "CJSingleTableView.h"


@class CJButtonsSingleTableView;
@protocol CJButtonsSingleTableViewDelegate <NSObject>

- (void)cj_buttonsSingleTableView:(CJButtonsSingleTableView *)buttonsSingleTableView didSelectText:(NSString *)text;
@end



@interface CJButtonsSingleTableView : UIView<RadioButtonsDataSource, RadioButtonsDelegate, CJSingleTableViewDelegate> {
    RadioButtons *_radioButtons;
}
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) id<CJButtonsSingleTableViewDelegate> delegate;

@end
