//
//  GroupTableViewController2.h
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CJRadio/CJRadio.h>
#import <CJPopupAction/UIView+CJShowExtendView.h>

#import "CJSingleTableView.h"
#import "CJRelatedPickerRichView.h"
#import "GroupDataUtil.h"

@interface GroupTableViewController2 : UIViewController <RadioButtonsDataSource, RadioButtonsDelegate, CJSingleTableViewDelegate, CJRelatedPickerRichViewDelegate> {
    
}
@property (nonatomic, weak) IBOutlet RadioButtons *radioButtons;
@property (nonatomic, strong) NSArray *titles;


@property (nonatomic, weak) IBOutlet CJSingleTableView *singleTableView;

@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView1;
@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView2;
@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView3;
@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView4;

@end
