//
//  DataListViewController.h
//  DataListViewDemo
//
//  Created by 李超前 on 16/6/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDataListViewSingle.h"
#import "CJDataListViewGroup.h"

@interface DataListViewController : UIViewController<CJDataListViewSingleDelegate, CJDataListViewGroupDelegate>

@property (nonatomic, weak) IBOutlet CJDataListViewSingle *dataListViewSingle;
@property (nonatomic, weak) IBOutlet CJDataListViewGroup *dataListViewGroup;

@end
