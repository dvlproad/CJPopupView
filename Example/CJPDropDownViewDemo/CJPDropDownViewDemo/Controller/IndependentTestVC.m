//
//  IndependentTestVC.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "IndependentTestVC.h"

#define kChooseArrayTitle @"title"
#define kChooseArrayValue @"value"

@interface IndependentTestVC ()

@end

@implementation IndependentTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    RadioButton *btn = [[RadioButton alloc]initWithFrame:CGRectMake(60, 84, 200, 40)];
    [btn setTitle:@"测试,无下拉"];
    [self.view addSubview:btn];
    
    CGRect rect_radioButtons111 = CGRectMake(0, 164, self.view.frame.size.width, 40);
    commonRadioButtons111 = [[RadioButtons alloc]initWithFrame:rect_radioButtons111];
    [commonRadioButtons111 setTitles:@[@"人物", @"爱好"] radioButtonNidName:@"RadioButton_DropDown"];
    commonRadioButtons111.delegate = self;
    commonRadioButtons111.tag = 111;
    [self.view addSubview:commonRadioButtons111];
    
    CGRect rect_radioButtons222 = CGRectMake(0, 264, self.view.frame.size.width, 40);
    commonRadioButtons222 = [[RadioButtons alloc]initWithFrame:rect_radioButtons222];
    [commonRadioButtons222 setTitles:@[@"人物", @"爱好", @"其他", @"地区"] radioButtonNidName:@"RadioButton_DropDown"];
    commonRadioButtons222.delegate = self;
    commonRadioButtons222.tag = 222;
    [self.view addSubview:commonRadioButtons222];
}

- (void)radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index{
    
    if(index == 0){
        NSArray *C_0_data =
        @[
          @{kChooseArrayTitle:@"李",
            kChooseArrayValue:@[
                    @{kChooseArrayTitle:@"先生", kChooseArrayValue:@[@"李先生1", @"李先生2"]},
                    @{kChooseArrayTitle:@"女士", kChooseArrayValue:@[@"李女士3", @"李女士4"]}]
            },
          @{kChooseArrayTitle:@"0",
            kChooseArrayValue:@[@{kChooseArrayTitle:@"0-0", kChooseArrayValue:@[@"000", @"001", @"002"]},
                                @{kChooseArrayTitle:@"0-1", kChooseArrayValue:@[]},
                                @{kChooseArrayTitle:@"0-2", kChooseArrayValue:@[@"020", @"021", @"022"]},
                                @{kChooseArrayTitle:@"0-3", kChooseArrayValue:@[@"031", @"032", @"033"]}]
            },
          @{kChooseArrayTitle:@"1",
            kChooseArrayValue: @[@{kChooseArrayTitle:@"1-1", kChooseArrayValue:@[@"112", @"113"]},
                                 @{kChooseArrayTitle:@"1-2", kChooseArrayValue:@[@"122", @"123"]},
                                 @{kChooseArrayTitle:@"1-3", kChooseArrayValue:@[@"132", @"133"]}]
            }];
        NSArray *dic_chooseArray = @[
                                     @{kAD_Title: kChooseArrayTitle, kAD_Value: kChooseArrayValue},
                                     @{kAD_Title: kChooseArrayTitle, kAD_Value: kChooseArrayValue}
                                     ];
        
        ArrayDictonaryModel *adModel = [[ArrayDictonaryModel alloc]initWithC_0_data:C_0_data dicArray:dic_chooseArray];
        [adModel updateSelecteds_index:@[@"0", @"0", @"0"]];
        //adModel.selecteds_index = @[@"0", @"0", @"0"];
        
        TableViewsArrayDictionary *customView = [[TableViewsArrayDictionary alloc]initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        customView.adModel = adModel;
        [customView setDelegate:self];
        customView.tag = radioButtons.tag;
        [radioButtons showDropDownExtendView:customView inView:self.view complete:nil];
        
    }else if(index == 1){
        NSArray *C_0_data = @[
                              @{kChooseArrayTitle:@"娱乐", kChooseArrayValue: @[@"爱旅行", @"爱唱歌", @"爱电影"]},
                              @{kChooseArrayTitle:@"学习", kChooseArrayValue: @[@"爱读书", @"爱看报", @"爱书法", @"爱其他"]},
                              @{kChooseArrayTitle:@"0", kChooseArrayValue: @[@"0-0", @"0-1", @"0-2", @"0-3"]},
                              @{kChooseArrayTitle:@"1", kChooseArrayValue: @[@"1-1", @"1-2", @"1-3"]}
                              ];
        NSArray *dic_chooseArray = @[
                                     @{kAD_Title: kChooseArrayTitle, kAD_Value: kChooseArrayValue}
                                     ];
        
        ArrayDictonaryModel *adModel = [[ArrayDictonaryModel alloc]initWithC_0_data:C_0_data dicArray:dic_chooseArray];
        [adModel updateSelecteds_index:@[@"0", @"0"]];
        
        TableViewsArrayDictionary *customView = [[TableViewsArrayDictionary alloc]initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        customView.adModel = adModel;
        [customView setDelegate:self];
        customView.tag = radioButtons.tag;
        [radioButtons showDropDownExtendView:customView inView:self.view complete:nil];
    }else if(index == 2){
        NSArray *chooseArray = @[@"区域", @"鼓楼", @"台江", @"仓山"];
        
        TableViewArraySingle *customView = [[TableViewArraySingle alloc]initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(self.view.frame.size.width*2/4, 0, self.view.frame.size.width/4, 200)];
        customView.datas = chooseArray;
        [customView setDelegate:self];
        customView.tag = radioButtons.tag;
        [radioButtons showDropDownExtendView:customView inView:self.view complete:nil];
    }else if (index == 3){
        
        NSArray *C_0_data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        NSArray *dicArray = @[@{kAD_Title: @"state", kAD_Value: @"cities"},
                              @{kAD_Title: @"city",  kAD_Value: @"areas"}];
        
        ArrayDictonaryModel *adModel =[[ArrayDictonaryModel alloc]initWithC_0_data:C_0_data dicArray:dicArray];
        [adModel updateSelecteds_index:@[@"0", @"0", @"0"]];
        
        NSArray *titles = adModel.selecteds_titles;
        NSLog(@"datas_titles = %@", titles);
        
        TableViewsArrayDictionary *customView = [[TableViewsArrayDictionary alloc]initWithFrame:CGRectZero];
        [customView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        customView.adModel = adModel;
        [customView setDelegate:self];
        customView.tag = radioButtons.tag;
        [radioButtons showDropDownExtendView:customView inView:self.view complete:nil];
    }
}


- (void)tv_ArrayDictionary:(TableViewsArrayDictionary *)tv_ArrayDictionary didSelectText:(NSString *)text{
    NSLog(@"text1 = %@, %@", text, tv_ArrayDictionary.adModel.selecteds_titles);
    
    //通过tag，反取到弹出该视图的RadioButtons
    NSInteger tag = tv_ArrayDictionary.tag;
    RadioButtons *comRadioButtons = nil;
    if (tag == commonRadioButtons111.tag) {
        comRadioButtons = commonRadioButtons111;
    }else if (tag == commonRadioButtons222.tag){
        comRadioButtons = commonRadioButtons222;
    }
    [comRadioButtons didSelectInExtendView:text];
    
}

- (void)tv_ArraySingle:(TableViewArraySingle *)tv_ArraySingle didSelectText:(NSString *)text{
    NSLog(@"text2 = %@", text);
    
    //通过tag，反取到弹出该视图的RadioButtons
    NSInteger tag = tv_ArraySingle.tag;
    RadioButtons *comRadioButtons = nil;
    if (tag == commonRadioButtons111.tag) {
        comRadioButtons = commonRadioButtons111;
    }else if (tag == commonRadioButtons222.tag){
        comRadioButtons = commonRadioButtons222;
    }
    [comRadioButtons didSelectInExtendView:text];
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
