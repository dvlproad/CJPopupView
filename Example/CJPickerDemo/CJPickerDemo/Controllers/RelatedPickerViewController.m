//
//  RelatedPickerViewController.m
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RelatedPickerViewController.h"

@interface RelatedPickerViewController ()

@end

@implementation RelatedPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupGroupTableView1];
    [self setupGroupTableView2];
    [self setupGroupTableView3];
}

#pragma mark - 注意增加此行
- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

#pragma mark - 设置数据
- (void)setupGroupTableView1 {
    NSMutableArray *componentDataModels = [GroupDataUtil groupData1];
    
    [_relatedPickerView1 setComponentDataModels:componentDataModels];
    [_relatedPickerView1 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
    [_relatedPickerView1 setDelegate:self];
}

- (void)setupGroupTableView2 {
    NSMutableArray *componentDataModels = [GroupDataUtil groupData2];
    
    [_relatedPickerView2 setComponentDataModels:componentDataModels];
    [_relatedPickerView2 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
    [_relatedPickerView2 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
    [_relatedPickerView2 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
    [_relatedPickerView2 setDelegate:self];
}

- (void)setupGroupTableView3 {
    NSMutableArray *componentDataModels = [GroupDataUtil groupData3];
    
    [_relatedPickerView3 setComponentDataModels:componentDataModels];
    [_relatedPickerView3 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
    [_relatedPickerView3 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
    [_relatedPickerView3 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
    [_relatedPickerView3 setDelegate:self];
}

#pragma mark - CJRelatedPickerRichViewDelegate
- (void)cj_RelatedPickerRichView:(CJRelatedPickerRichView *)relatedPickerRichView didSelectText:(NSString *)text {
    NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
    for (CJComponentDataModel *componentDataModel in relatedPickerRichView.componentDataModels) {
        CJDataModelSample *selectedDataModel = componentDataModel.selectedDataModel;
        if (selectedDataModel) {
            [selectedTitles addObject:selectedDataModel.text];
        } else {
            [selectedTitles addObject:@""];
        }
    }
    
    
    NSLog(@"text1 = %@, %@", text, selectedTitles);
    
    NSString *string = @"";
    for (NSString *selectedTitle in selectedTitles) {
        string = [string stringByAppendingString:selectedTitle];
    }
    
    if (relatedPickerRichView == _relatedPickerView1) {
        self.textLabel1.text = string;
    } else if (relatedPickerRichView == _relatedPickerView2) {
        self.textLabel2.text = string;
    } else if (relatedPickerRichView == _relatedPickerView3) {
        self.textLabel3.text = string;
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
