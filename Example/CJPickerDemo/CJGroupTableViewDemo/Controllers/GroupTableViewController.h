//
//  GroupTableViewController.h
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSingleTableView.h"
#import "CJRelatedPickerRichView.h"
#import "GroupDataUtil.h"

@interface GroupTableViewController : UIViewController<CJSingleTableViewDelegate, CJRelatedPickerRichViewDelegate>

@property (nonatomic, weak) IBOutlet CJSingleTableView *singleTableView;

@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView1;
@property (nonatomic, weak) IBOutlet UILabel *groupTextLabel1;

@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView2;
@property (nonatomic, weak) IBOutlet UILabel *groupTextLabel2;

@property (nonatomic, strong) IBOutlet CJRelatedPickerRichView *groupTableView3;
@property (nonatomic, weak) IBOutlet UILabel *groupTextLabel3;

@end
