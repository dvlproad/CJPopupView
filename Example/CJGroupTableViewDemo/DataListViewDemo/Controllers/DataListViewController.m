//
//  DataListViewController.m
//  DataListViewDemo
//
//  Created by 李超前 on 16/6/18.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "DataListViewController.h"

#define kCategoryFirst      @"categoryFirst"    //eg:state  省
#define kCategoryFirstID    @"categoryFirstID"  //eg:state  省ID
#define kCategorySecond     @"categorySecond"   //eg:city   市
#define kCategorySecondID   @"categorySecondID" //eg:city   市ID
#define kCategoryThird      @"categoryThird"    //eg:area   区
#define kCategoryThirdID    @"categoryThirdID"  //eg:area   区
#define kCategoryFourth     @"categoryFourth"   //eg:
#define kCategoryFourthID   @"categoryFourthID" //eg:

#define kCategoryValue  @"categoryValue"

@interface DataListViewController ()

@end

@implementation DataListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupDataListViewSingle];
    
    [self setupGroupTableView1];
    [self setupGroupTableView2];
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

- (void)setupGroupTableView2 {
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
                @{kCategorySecond:@"通州", kCategoryValue:@[]},
                @{kCategorySecond:@"房山", kCategoryValue:@[]},
                @{kCategorySecond:@"昌平", kCategoryValue:@[@"4区", @"5区", @"6区"]},
                @{kCategorySecond:@"顺义", kCategoryValue:@[@"7区", @"8区", @"9区"]}]
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
    
    CJDataGroupModel *dataGroupModel = [[CJDataGroupModel alloc] initWithSelectedIndexs:@[@"0", @"1", @"0"] InComponent0Datas:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
    
    [self.groupTableView2 setDataGroupModel:dataGroupModel];
    [self.groupTableView2 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
    [self.groupTableView2 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
    [self.groupTableView2 setDelegate:self];
}

- (void)setupGroupTableView1 {
    NSArray *component0Datas = @[@"福建省", @"四川", @"北京", @"云南"];
    NSArray *sortOrders = nil;
    NSArray *categoryValueKeys = nil;
    
    CJDataGroupModel *dataGroupModel = [[CJDataGroupModel alloc] initWithSelectedIndexs:@[@"0"] InComponent0Datas:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
    
    [self.groupTableView1 setDataGroupModel:dataGroupModel];
    [self.groupTableView1 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
    [self.groupTableView1 setDelegate:self];
    
//    NSArray *component0Datas =
//    @[
//      @{kCategoryFirst:@"福建省",
//        kCategoryValue:@[@"福州", @"厦门", @"漳州", @"泉州"]
//        },
//      @{kCategoryFirst:@"四川",
//        kCategoryValue:@[@"成都", @"眉山", @"乐山", @"达州"]
//        },
//      @{kCategoryFirst:@"北京",
//        kCategoryValue:@[@"通州", @"房山", @"昌平", @"顺义"]
//        },
//      @{kCategoryFirst:@"云南",
//        kCategoryValue: @[@"昆明", @"丽江", @"大理", @"西双版纳"]
//        }];
//    NSArray *sortOrders = @[kCategoryFirst, kCategorySecond];
//    NSArray *categoryValueKeys = @[kCategoryValue, kCategoryValue];
//    
//    CJDataGroupModel *dataGroupModel = [[CJDataGroupModel alloc] initWithSelectedIndexs:@[@"0", @"0"] InComponent0Datas:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
//    
//    [self.dataListViewGroup setDataGroupModel:dataGroupModel];
//    [self.dataListViewGroup updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
//    [self.dataListViewGroup updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
//    [self.dataListViewGroup setDelegate:self];
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
