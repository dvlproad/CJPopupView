//
//  RelatedPickerViewController2.h
//  CJRelatedPickerRichViewDemo
//
//  Created by ciyouzen on 9/7/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CJRadio/CJRadio.h>
#import <CJPopupAction/UIView+CJShowExtendView.h>

#import "CJRelatedPickerRichView.h"
#import "GroupDataUtil.h"

@interface RelatedPickerViewController2 : UIViewController <CJRelatedPickerRichViewDelegate> {
    
}
@property (nonatomic, weak) IBOutlet RadioButtons *radioButtons;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView1;
@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView2;
@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView3;
@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView4;

@end
