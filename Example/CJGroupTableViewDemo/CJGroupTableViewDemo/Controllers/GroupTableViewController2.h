//
//  GroupTableViewController2.h
//  CJGroupTableViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RadioButtons/RadioButtons.h>
//#import <CJPopupView/UIView+CJPopupInView.h>
#import <CJPopupView/UIView+CJShowExtendView.h>

#import "CJSingleTableView.h"
#import "CJGroupTableView.h"
#import "GroupDataUtil.h"

@interface GroupTableViewController2 : UIViewController <RadioButtonsDataSource, RadioButtonsDelegate, CJSingleTableViewDelegate, CJGroupTableViewDelegate> {
    
}
@property (nonatomic, weak) IBOutlet RadioButtons *radioButtons;
@property (nonatomic, strong) NSArray *titles;


@property (nonatomic, weak) IBOutlet CJSingleTableView *singleTableView;

@property (nonatomic, strong) IBOutlet CJGroupTableView *groupTableView1;
@property (nonatomic, strong) IBOutlet CJGroupTableView *groupTableView2;
@property (nonatomic, strong) IBOutlet CJGroupTableView *groupTableView3;
@property (nonatomic, strong) IBOutlet CJGroupTableView *groupTableView4;

@end
