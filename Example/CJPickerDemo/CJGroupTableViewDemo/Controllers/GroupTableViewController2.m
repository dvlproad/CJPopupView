//
//  GroupTableViewController2.m
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "GroupTableViewController2.h"

#define kDefaultMaxShowCount    5

@interface GroupTableViewController2 ()

@property (nonatomic, strong) RadioButtons *operationRadioButtons;

@end

@implementation GroupTableViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.titles =  @[@"人物", @"爱好", @"其他", @"地区"];
    self.radioButtons.dataSource = self;
    self.radioButtons.delegate = self;

}

#pragma mark - RadioButtonsDataSource & RadioButtonsDelegate
- (NSInteger)cj_defaultShowIndexInRadioButtons:(RadioButtons *)radioButtons {
    return -1;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(RadioButtons *)radioButtons {
    return self.titles.count;
}

- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    NSInteger showViewCount = MIN(self.titles.count, kDefaultMaxShowCount);
    CGFloat sectionWidth = CGRectGetWidth(radioButtons.frame)/showViewCount;
    sectionWidth = ceilf(sectionWidth);
    
    return sectionWidth;
}

- (RadioButton *)cj_radioButtons:(RadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    NSArray *radioButtonNib = [[NSBundle mainBundle]loadNibNamed:@"RadioButton_Slider" owner:nil options:nil];
    RadioButton *radioButton = [radioButtonNib lastObject];
    [radioButton setTitle:self.titles[index]];
    radioButton.textNormalColor = [UIColor blackColor];
    radioButton.textSelectedColor = [UIColor greenColor];
    
    return radioButton;
}

- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    NSLog(@"index_old = %ld, index_cur = %ld", index_old, index_cur);
    
    if (index_cur == index_old) {
        return;
    }
    if (radioButtons.isCJPopupViewShowing) {
        [self.operationRadioButtons cj_hideExtendViewAnimated:YES];
    }
    self.operationRadioButtons = radioButtons;
    
    if (index_cur == 0) {
        
    }
    
    UIView *popupView = nil;
    switch (index_cur) {
        case 0:
        {
            popupView = self.groupTableView1;
            break;
        }
        case 1:
        {
            popupView = self.groupTableView2;
            break;
        }
        case 2:
        {
            popupView = self.groupTableView3;
            break;
        }
        case 3:
        {
            popupView = self.groupTableView4;
            break;
        }
        default:
        {
            break;
        }
    }
    
    [radioButtons cj_showExtendView:popupView inView:self.view locationAccordingView:self.view relativePosition:CJPopupViewPositionUnder showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
        [radioButtons cj_hideExtendViewAnimated:YES];
    }];
}


#pragma mark - 设置数据
- (CJRelatedPickerRichView *)groupTableView1 {
    if (_groupTableView1 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupData1];
        
        _groupTableView1 = [[CJRelatedPickerRichView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        [_groupTableView1 setComponentDataModels:componentDataModels];
        [_groupTableView1 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [_groupTableView1 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [_groupTableView1 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [_groupTableView1 setDelegate:self];
    }
    return _groupTableView1;
}

- (CJRelatedPickerRichView *)groupTableView2 {
    if (_groupTableView2 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupData2];
        
        _groupTableView2 = [[CJRelatedPickerRichView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        [_groupTableView2 setComponentDataModels:componentDataModels];
        [_groupTableView2 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [_groupTableView2 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [_groupTableView2 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [_groupTableView2 setDelegate:self];
    }
    return _groupTableView2;
}

- (CJRelatedPickerRichView *)groupTableView3 {
    if (_groupTableView3 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupDataAllArea];
        
        _groupTableView3 = [[CJRelatedPickerRichView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        [_groupTableView3 setComponentDataModels:componentDataModels];
        [_groupTableView3 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [_groupTableView3 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [_groupTableView3 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [_groupTableView3 setDelegate:self];
    }
    return _groupTableView3;
}

- (CJRelatedPickerRichView *)groupTableView4 {
    if (_groupTableView4 == nil) {
        NSMutableArray *componentDataModels = [GroupDataUtil groupDataYule];
        
        _groupTableView4 = [[CJRelatedPickerRichView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        [_groupTableView4 setComponentDataModels:componentDataModels];
        [_groupTableView4 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [_groupTableView4 updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [_groupTableView4 updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [_groupTableView4 setDelegate:self];
    }
    return _groupTableView4;
}

#pragma mark - CJSingleTableViewDelegate
- (void)cj_singleTableView:(CJSingleTableView *)singleTableView didSelectText:(NSString *)text {
    NSLog(@"text2 = %@", text);
}

#pragma mark - CJRelatedPickerRichViewDelegate
- (void)cj_groupTableView:(CJRelatedPickerRichView *)groupTableView didSelectText:(NSString *)text {
    NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
    for (CJComponentDataModel *componentDataModel in groupTableView.componentDataModels) {
        CJDataModelSample *selectedDataModel = componentDataModel.selectedDataModel;
        if (selectedDataModel) {
            [selectedTitles addObject:selectedDataModel.text];
        } else {
            [selectedTitles addObject:@""];
        }
    }
    NSLog(@"text1 = %@, %@", text, selectedTitles);
    
    [self.operationRadioButtons cj_hideExtendViewAnimated:YES];
    [self.operationRadioButtons changeCurrentRadioButtonStateAndTitle:text];
    [self.operationRadioButtons setSelectedNone];
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
