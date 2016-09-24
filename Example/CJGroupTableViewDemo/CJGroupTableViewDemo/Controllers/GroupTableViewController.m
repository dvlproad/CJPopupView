//
//  GroupTableViewController.m
//  CJGroupTableViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "GroupTableViewController.h"
#import "GroupDataUtil.h"

@interface GroupTableViewController ()

@end

@implementation GroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupDataListViewSingle];
    
    [self setupGroupTableView1];
    [self setupGroupTableView3];
}


- (void)setupDataListViewSingle {
    NSArray *chooseArray = @[@"区域", @"鼓楼", @"台江", @"仓山"];
    
    [self.singleTableView setDatas:chooseArray];
    [self.singleTableView setDelegate:self];
}

#pragma mark - 注意增加此行
- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)setupGroupTableView1 {
    CJDataGroupModel *dataGroupModel = [GroupDataUtil groupData1];
    
    [self.groupTableView1 setDataGroupModel:dataGroupModel];
    [self.groupTableView1 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
    [self.groupTableView1 setDelegate:self];
}

- (void)setupGroupTableView2 {
    CJDataGroupModel *dataGroupModel = [GroupDataUtil groupData2];

    [self.groupTableView1 setDataGroupModel:dataGroupModel];
    [self.groupTableView1 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
    [self.groupTableView1 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
    [self.groupTableView1 setDelegate:self];
}

- (void)setupGroupTableView3 {
    CJDataGroupModel *dataGroupModel = [GroupDataUtil groupData3];
    
    [self.groupTableView2 setDataGroupModel:dataGroupModel];
    [self.groupTableView2 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
    [self.groupTableView2 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
    [self.groupTableView2 setDelegate:self];
}


- (void)cj_singleTableView:(CJSingleTableView *)singleTableView didSelectText:(NSString *)text {
    NSLog(@"text2 = %@", text);
}

- (void)cj_groupTableView:(CJGroupTableView *)groupTableView didSelectText:(NSString *)text {
    NSArray *selectedTitles = groupTableView.dataGroupModel.selectedTitles;
    NSLog(@"text1 = %@, %@", text, selectedTitles);
    
    NSString *string = @"";
    for (NSString *selectedTitle in selectedTitles) {
        string = [string stringByAppendingString:selectedTitle];
    }
    
    if (groupTableView == self.groupTableView1) {
        self.groupTextLabel1.text = string;
    } else if (groupTableView == self.groupTableView2) {
        self.groupTextLabel2.text = string;
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
