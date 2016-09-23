//
//  IndependentTestVC.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "IndependentTestVC.h"

#define kCategoryFirst  @"categoryFirst"    //eg:state  省
#define kCategorySecond @"categorySecond"   //eg:city   市
#define kCategoryThird  @"categoryThird"    //eg:area   区
#define kCategoryFourth @"categoryFourth"   //eg:

#define kCategoryValue  @"categoryValue"

@interface IndependentTestVC ()

@end

@implementation IndependentTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_radioButton setTitle:@"测试,无下拉"];//TODO
    
    CGRect rect_radioButtons111 = CGRectMake(0, 164, self.view.bounds.size.width+30, 40);
    commonRadioButtons111 = [[RadioButtonsCanDrop alloc]initWithFrame:rect_radioButtons111];
    [commonRadioButtons111 setTitles:@[@"人物", @"爱好"] radioButtonNidName:@"RadioButton_DropDown"];
    commonRadioButtons111.delegate = self;
    commonRadioButtons111.tag = 111;
    [self.view addSubview:commonRadioButtons111];
    
    CGRect rect_radioButtons222 = CGRectMake(0, 264, self.view.frame.size.width, 40);
    commonRadioButtons222 = [[RadioButtonsCanDrop alloc]initWithFrame:rect_radioButtons222];
    [commonRadioButtons222 setTitles:@[@"人物", @"爱好", @"其他", @"地区"] radioButtonNidName:@"RadioButton_DropDown"];
    commonRadioButtons222.delegate = self;
    commonRadioButtons222.tag = 222;
    [self.view addSubview:commonRadioButtons222];
}

- (void)radioButtonsCanDrop:(RadioButtonsCanDrop *)radioButtonsCanDrop chooseIndex:(NSInteger)index{
    
    if(index == 0){
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
        
        
        CJDataListViewGroup *customView = [[CJDataListViewGroup alloc]initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        customView.dataGroupModel = dataGroupModel;
        [customView setDelegate:self];
        customView.tag = radioButtonsCanDrop.tag;
        [radioButtonsCanDrop radioButtonsCanDrop_showDropDownExtendView:customView inView:self.view complete:nil];
        
    }else if(index == 1){
        NSArray *component0Datas = @[
            @{kCategoryFirst:@"娱乐",
              kCategoryValue:@[@"爱旅行", @"爱唱歌", @"爱电影"]},
            @{kCategoryFirst:@"学习",
              kCategoryValue:@[@"爱读书", @"爱看报", @"爱书法", @"爱其他"]},
            @{kCategoryFirst:@"0",
              kCategoryValue:@[@"0-0", @"0-1", @"0-2", @"0-3"]},
            @{kCategoryFirst:@"1",
              kCategoryValue:@[@"1-1", @"1-2", @"1-3"]}
            ];
        NSArray *sortOrders = @[kCategoryFirst, kCategorySecond];
        NSArray *categoryValueKeys = @[kCategoryValue, kCategoryValue];
        
        CJDataGroupModel *dataGroupModel = [[CJDataGroupModel alloc] initWithComponent0Datas:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
        [dataGroupModel updateSelectedIndexs:@[@"0", @"0"]];
        
        CJDataListViewGroup *customView = [[CJDataListViewGroup alloc]initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        customView.dataGroupModel = dataGroupModel;
        [customView setDelegate:self];
        customView.tag = radioButtonsCanDrop.tag;
        [radioButtonsCanDrop radioButtonsCanDrop_showDropDownExtendView:customView inView:self.view complete:nil];
    }else if(index == 2){
        NSArray *chooseArray = @[@"区域", @"鼓楼", @"台江", @"仓山"];
        
        CJDataListViewSingle *customView = [[CJDataListViewSingle alloc] initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(self.view.frame.size.width*2/4, 0, self.view.frame.size.width/4, 200)];
        customView.datas = chooseArray;
        [customView setDelegate:self];
        customView.tag = radioButtonsCanDrop.tag;
        [radioButtonsCanDrop radioButtonsCanDrop_showDropDownExtendView:customView inView:self.view complete:nil];
    }else if (index == 3){
        
        NSArray *component0Datas = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        NSArray *sortOrders = @[@"state", @"city", @"area"];
//        NSArray *dicArray = @[@{kAD_Title: @"state", kAD_Value: @"cities"},
//                              @{kAD_Title: @"city",  kAD_Value: @"areas"}]
        
        NSArray *categoryValueKeys = @[@"cities", @"areas"];
        
        CJDataGroupModel *dataGroupModel = [[CJDataGroupModel alloc] initWithComponent0Datas:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
        [dataGroupModel updateSelectedIndexs:@[@"0", @"0", @"0"]];
        
        NSArray *titles = dataGroupModel.selectedTitles;
        NSLog(@"datas_titles = %@", titles);
        
        CJDataListViewGroup *customView = [[CJDataListViewGroup alloc]initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        customView.dataGroupModel = dataGroupModel;
        [customView setDelegate:self];
        customView.tag = radioButtonsCanDrop.tag;
        [radioButtonsCanDrop radioButtonsCanDrop_showDropDownExtendView:customView inView:self.view complete:nil];
    }
}


- (void)cj_dataListViewGroup:(CJDataListViewGroup *)dataListViewGroup didSelectText:(NSString *)text
{
    NSLog(@"text1 = %@, %@", text, dataListViewGroup.dataGroupModel.selectedTitles);
    
    //通过tag，反取到弹出该视图的RadioButtons
    NSInteger tag = dataListViewGroup.tag;
    RadioButtonsCanDrop *comRadioButtons = nil;
    if (tag == commonRadioButtons111.tag) {
        comRadioButtons = commonRadioButtons111;
    }else if (tag == commonRadioButtons222.tag){
        comRadioButtons = commonRadioButtons222;
    }
    [comRadioButtons radioButtonsCanDrop_didSelectInExtendView:text];
    
}

- (void)cj_dataListViewSingle:(CJDataListViewSingle *)dataListViewSingle didSelectText:(NSString *)text
{
    NSLog(@"text2 = %@", text);
    
    //通过tag，反取到弹出该视图的RadioButtons
    NSInteger tag = dataListViewSingle.tag;
    RadioButtonsCanDrop *comRadioButtons = nil;
    if (tag == commonRadioButtons111.tag) {
        comRadioButtons = commonRadioButtons111;
    }else if (tag == commonRadioButtons222.tag){
        comRadioButtons = commonRadioButtons222;
    }
    [comRadioButtons radioButtonsCanDrop_didSelectInExtendView:text];
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
