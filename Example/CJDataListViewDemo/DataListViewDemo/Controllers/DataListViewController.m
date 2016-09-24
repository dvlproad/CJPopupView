//
//  DataListViewController.m
//  DataListViewDemo
//
//  Created by 李超前 on 16/6/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "DataListViewController.h"

#define kCategoryFirst  @"categoryFirst"    //eg:state  省
#define kCategorySecond @"categorySecond"   //eg:city   市
#define kCategoryThird  @"categoryThird"    //eg:area   区
#define kCategoryFourth @"categoryFourth"   //eg:

#define kCategoryValue  @"categoryValue"

@interface DataListViewController ()

@end

@implementation DataListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupDataListViewSingle];
    [self setupDataListViewGroup];
}


- (void)setupDataListViewSingle {
    NSArray *chooseArray = @[@"区域", @"鼓楼", @"台江", @"仓山"];
    
    [self.dataListViewSingle setDatas:chooseArray];
    [self.dataListViewSingle setDelegate:self];
}

#pragma mark - 注意增加此行
- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)setupDataListViewGroup {
    NSArray *component0Datas =
    @[
      @{kCategoryFirst:@"福建省",
        kCategoryValue:@[
                @{kCategorySecond:@"福州", kCategoryValue:@[@"鼓楼", @"台江", @"晋安", @"仓山", @"马尾"]},
                @{kCategorySecond:@"厦门", kCategoryValue:@[@"思明", @"湖里", @"集美", @"同安", @"海沧", @"翔安"]},
                @{kCategorySecond:@"漳州", kCategoryValue:@[@"龙海市", @"南靖县", @"云霄区", @"诏安县", @"华安县"]},
                @{kCategorySecond:@"泉州", kCategoryValue:@[@"丰泽", @"鲤城", @"洛江"]}]
        },
      @{kCategoryFirst:@"四川",
        kCategoryValue:@[
                @{kCategorySecond:@"成都", kCategoryValue:@[@"锦江", @"武侯", @"都江堰", @"青羊"]},
                @{kCategorySecond:@"眉山", kCategoryValue:@[@"1区", @"2区", @"3区"]},
                @{kCategorySecond:@"乐山", kCategoryValue:@[@"4区", @"5区", @"6区"]},
                @{kCategorySecond:@"达州", kCategoryValue:@[@"7区", @"8区", @"9区"]}]
        },
      @{kCategoryFirst:@"北京",
        kCategoryValue:@[
                @{kCategorySecond:@"北京1", kCategoryValue:@[]},
                @{kCategorySecond:@"北京", kCategoryValue:@[]},
                @{kCategorySecond:@"北京3", kCategoryValue:@[@"4区", @"5区", @"6区"]},
                @{kCategorySecond:@"北京4", kCategoryValue:@[@"7区", @"8区", @"9区"]}]
        },
      @{kCategoryFirst:@"云南",
        kCategoryValue: @[
                @{kCategorySecond:@"昆明", kCategoryValue:@[@"1区", @"2区", @"3区"]},
                @{kCategorySecond:@"丽江", kCategoryValue:@[@"4区", @"5区", @"6区"]},
                @{kCategorySecond:@"大理", kCategoryValue:@[@"7区", @"8区", @"9区"]},
                @{kCategorySecond:@"西双版纳", kCategoryValue:@[@"10区"]}]
        }];
    NSArray *sortOrders = @[kCategoryFirst, kCategorySecond, kCategoryThird];
    NSArray *categoryValueKeys = @[kCategoryValue, kCategoryValue, kCategoryValue];
    
    CJDataGroupModel *dataGroupModel = [[CJDataGroupModel alloc] initWithComponent0Datas:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
    [dataGroupModel updateSelectedIndexs:@[@"0", @"0", @"0"]];
    
    [self.dataListViewGroup setDataGroupModel:dataGroupModel];
    [self.dataListViewGroup updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
    [self.dataListViewGroup updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
    [self.dataListViewGroup setDelegate:self];
}

- (void)cj_dataListViewSingle:(CJDataListViewSingle *)dataListViewSingle didSelectText:(NSString *)text {
    NSLog(@"text2 = %@", text);
}

- (void)cj_dataListViewGroup:(CJDataListViewGroup *)dataListViewGroup didSelectText:(NSString *)text {
    NSLog(@"text1 = %@, %@", text, dataListViewGroup.dataGroupModel.selectedTitles);
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
