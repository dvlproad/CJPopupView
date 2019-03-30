//
//  RelatedPickerViewController2.m
//  CJRelatedPickerRichViewDemo
//
//  Created by ciyouzen on 9/7/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "RelatedPickerViewController2.h"

#define kDefaultMaxShowCount    5
#import "DemoPopupRadioButtons.h"

@interface RelatedPickerViewController2 () <DemoPopupRadioButtonsDataSource>

@property (nonatomic, strong) DemoPopupRadioButtons *radioButtonsDropDownSample;
@property (nonatomic, strong) DemoPopupRadioButtons *radioButtonsDropDownSample2;

@end

@implementation RelatedPickerViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titles = @[@"人物", @"爱好", @"其他", @"地区"];
    DemoPopupRadioButtons *radioButtonsDropDownSample = [[DemoPopupRadioButtons alloc] init];
    [radioButtonsDropDownSample setFrame:CGRectMake(20, 200, 380, 40)];
    [radioButtonsDropDownSample setupWithTitles:titles
                                  dropDownImage:[UIImage imageNamed:@"arrowDown_dark"]
                                 popupSuperview:self.view
                                      popupType:CJRadioButtonsPopupTypeUnderAll];
    radioButtonsDropDownSample.radioButtonsPopupSampleDataSource = self;
    [self.view addSubview:radioButtonsDropDownSample];
    self.radioButtonsDropDownSample = radioButtonsDropDownSample;
    self.radioButtonsDropDownSample.tag = 1001;
    
//    @[@"区域", @"鼓楼", @"台江", @"仓山"];
//    @[@"面积", @"75平米以下", @"75-100平米", @"100-150平米", @"150平米以上"];
//    @[@"总价", @"80万以下", @"80-120万", @"120-200万", @"200万以上"];
    
    NSArray *titles2 = @[@"人物", @"爱好", @"其他", @"地区"];
    DemoPopupRadioButtons *radioButtonsDropDownSample2 = [[DemoPopupRadioButtons alloc] init];
    [radioButtonsDropDownSample2 setFrame:CGRectMake(20, 400, 380, 40)];
    [radioButtonsDropDownSample2 setupWithTitles:titles2
                                  dropDownImage:[UIImage imageNamed:@"arrowDown_dark"]
                                 popupSuperview:self.view
                                       popupType:CJRadioButtonsPopupTypeUnderCurrent];
    radioButtonsDropDownSample2.radioButtonsPopupSampleDataSource = self;
    [self.view addSubview:radioButtonsDropDownSample2];
    self.radioButtonsDropDownSample2 = radioButtonsDropDownSample2;
    self.radioButtonsDropDownSample2.tag = 1002;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.radioButtonsDropDownSample scollToCurrentSelectedViewWithAnimated:NO];
}

- (UIView *)cj_RadioButtonsPopupSample:(DemoPopupRadioButtons *)radioButtonsPopupSample viewForButtonIndex:(NSInteger)index {
    /*
    UIView *popupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 200)];
    popupView.backgroundColor = [UIColor greenColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, 50, 280, 44)];
    NSString *title = [NSString stringWithFormat:@"%ld.生成随机数，并设置", index];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:btn];
    
    //    popupView.clipsToBounds = YES;
    
    return popupView;
    */
    
    CJRelatedPickerRichView *popupView = nil;
    if (radioButtonsPopupSample.tag == 1001) {
        switch (index) {
            case 0: {
                popupView = self.groupTableView1;
                break;
            }
            case 1: {
                popupView = self.groupTableView2;
                break;
            }
            case 2: {
                popupView = self.groupTableView3;
                break;
            }
            case 3: {
                popupView = self.groupTableView4;
                break;
            }
            default: {
                break;
            }
        }
    } else {
        popupView = self.groupTableView1;
    }
    
    popupView.pickActionView = radioButtonsPopupSample;
    popupView.clipsToBounds = YES;
    
    return popupView;
}

- (IBAction)btnAction:(id)sender {
    NSString *title = [NSString stringWithFormat:@"%d", rand()%10];
    
    [self.radioButtonsDropDownSample cj_hideExtendViewAnimated:YES];
    [self.radioButtonsDropDownSample changeCurrentRadioButtonStateAndTitle:title];
    [self.radioButtonsDropDownSample setSelectedNone];
}


#pragma mark - 设置数据
- (CJRelatedPickerRichView *)groupTableView1 {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.radioButtonsDropDownSample.frame), 200);
    if (_groupTableView1 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupData1];
        
        CJRelatedPickerRichView *relatedPickerView = [[CJRelatedPickerRichView alloc] init];
        [relatedPickerView setFrame:frame];
        [relatedPickerView setComponentDataModels:componentDataModels];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [relatedPickerView setDelegate:self];
        
        _groupTableView1 = relatedPickerView;
    }
    [_groupTableView1 setFrame:frame];
    
    return _groupTableView1;
}

- (CJRelatedPickerRichView *)groupTableView2 {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.radioButtonsDropDownSample.frame), 200);
    if (_groupTableView2 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupData2];
        
        CJRelatedPickerRichView *relatedPickerView = [[CJRelatedPickerRichView alloc] initWithFrame:frame];
        [relatedPickerView setComponentDataModels:componentDataModels];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [relatedPickerView setDelegate:self];
        
        _groupTableView2 = relatedPickerView;
    }
    [_groupTableView2 setFrame:frame];
    
    return _groupTableView2;
}

- (CJRelatedPickerRichView *)groupTableView3 {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.radioButtonsDropDownSample.frame), 200);
    if (_groupTableView3 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupDataAllArea];
        
        CJRelatedPickerRichView *relatedPickerView = [[CJRelatedPickerRichView alloc] initWithFrame:frame];
        [relatedPickerView setComponentDataModels:componentDataModels];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [relatedPickerView setDelegate:self];
        
        _groupTableView3 = relatedPickerView;
    }
    [_groupTableView3 setFrame:frame];
    
    return _groupTableView3;
}

- (CJRelatedPickerRichView *)groupTableView4 {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.radioButtonsDropDownSample.frame), 200);
    if (_groupTableView4 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupDataYule];
        
        CJRelatedPickerRichView *relatedPickerView = [[CJRelatedPickerRichView alloc] initWithFrame:frame];
        [relatedPickerView setComponentDataModels:componentDataModels];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [relatedPickerView updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [relatedPickerView setDelegate:self];
        
        _groupTableView4 = relatedPickerView;
    }
    [_groupTableView4 setFrame:frame];
    
    return _groupTableView4;
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
    
    UIView *pickActionView = relatedPickerRichView.pickActionView;
    [pickActionView cj_hideExtendViewAnimated:YES];
    if ([pickActionView isKindOfClass:[DemoPopupRadioButtons class]]) {
        DemoPopupRadioButtons *radioButtonsDropDownSample = (DemoPopupRadioButtons *)pickActionView;
        
        [radioButtonsDropDownSample changeCurrentRadioButtonStateAndTitle:text];
        [radioButtonsDropDownSample setSelectedNone];
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
