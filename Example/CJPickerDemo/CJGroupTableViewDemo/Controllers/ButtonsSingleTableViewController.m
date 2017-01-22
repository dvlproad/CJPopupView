//
//  ButtonsSingleTableViewController.m
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ButtonsSingleTableViewController.h"

@interface ButtonsSingleTableViewController ()

@end

@implementation ButtonsSingleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CJButtonsSingleTableView *buttonsSingleTableView = [[CJButtonsSingleTableView alloc]initWithFrame:CGRectMake(0, 164, 300, 40)];
    buttonsSingleTableView.datas = @[
                     @[@"区域", @"鼓楼", @"台江", @"仓山"],
                     @[@"面积", @"75平米以下", @"75-100平米", @"100-150平米", @"150平米以上"],
                     @[@"总价", @"80万以下", @"80-120万", @"120-200万", @"200万以上"]
                     ];
    buttonsSingleTableView.delegate = self;
    [self.view addSubview:buttonsSingleTableView];
}



- (void)cj_buttonsSingleTableView:(CJButtonsSingleTableView *)buttonsSingleTableView
                    didSelectText:(NSString *)text {
    NSLog(@"text3 = %@", text);
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
