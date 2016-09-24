//
//  DataListViewController.h
//  DataListViewDemo
//
//  Created by 李超前 on 16/6/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSingleTableView.h"
#import "CJGroupTableView.h"

@interface DataListViewController : UIViewController<CJSingleTableViewDelegate, CJGroupTableViewDelegate>

@property (nonatomic, weak) IBOutlet CJSingleTableView *singleTableView;

@property (nonatomic, weak) IBOutlet CJGroupTableView *groupTableView1;
@property (nonatomic, weak) IBOutlet UILabel *groupTextLabel1;

@property (nonatomic, weak) IBOutlet CJGroupTableView *groupTableView2;
@property (nonatomic, weak) IBOutlet UILabel *groupTextLabel2;

@end
