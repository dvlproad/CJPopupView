//
//  PickerViewController.m
//  CJPickerToolBarViewDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "PickerViewController.h"
#import "CJDatePickerToolBarView.h"
#import "CJIndependentPickerView.h"
//#import "CJRelatedPickerView.h"
#import "CJRelatedPickerRichView.h"
#import "GroupDataUtil.h"

#import <UIView+CJPopupInView.h>

@interface PickerViewController () <CJDatePickerToolBarViewDelegate,
                                    CJIndependentPickerViewDelegate,
                                    CJRelatedPickerRichViewDelegate>
{
    CJDatePickerToolBarView *picker_birthday;
    CJIndependentPickerView *picker_weight;
    CJRelatedPickerRichView *picker_area;
}

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)chooseBirthday:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if (picker_birthday == nil) {
        picker_birthday = [[CJDatePickerToolBarView alloc]initWithNibName:@"CJDatePickerToolBarView" delegate:self];
        picker_birthday.datePicker.datePickerMode = UIDatePickerModeDate;
        picker_birthday.datePicker.maximumDate = [NSDate date];
        picker_birthday.datePicker.minimumDate = [dateFormatter dateFromString:@"1900-01-01"];;
    }
    
    
    picker_birthday.datePicker.date = [dateFormatter dateFromString:@"1989-12-27"];
    
    [picker_birthday cj_popupInWindowAtPosition:CJWindowPositionBottom animationType:CJAnimationTypeNormal showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
        [picker_birthday cj_hidePopupView];
        
    }];
}


- (IBAction)chooseArea:(id)sender{
    if (picker_area == nil) {
        picker_area = [[CJRelatedPickerRichView alloc] initWithFrame:CGRectMake(0, 0, 200, 162)];
        
        NSMutableArray *componentDataModels = [GroupDataUtil groupDataAllArea];
        
        [picker_area setComponentDataModels:componentDataModels];
        [picker_area updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [picker_area updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [picker_area updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [picker_area setDelegate:self];
    }
    
//    picker_area.selecteds_default = @[@"福建", @"泉州", @"安溪县"];
    
    
    
    
    [picker_area cj_popupInWindowAtPosition:CJWindowPositionBottom animationType:CJAnimationTypeNormal showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
        [picker_area cj_hidePopupView];
    }];
}


- (IBAction)chooseWeight:(id)sender{
    if (picker_weight == nil) {
        picker_weight = [[CJIndependentPickerView alloc]initWithNibName:@"CJIndependentPickerView" delegate:self];
        NSMutableArray *integers = [[NSMutableArray alloc]init];
        for (int i = 40; i < 100; i++) {
            [integers addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        NSMutableArray *decimals = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i++) {
            [decimals addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        NSArray *units = @[@"kg", @"磅"];
        
        picker_weight.datas = @[integers, decimals, units];
        picker_weight.tag = 1000;
    }
    
    picker_weight.selecteds_default = @[@"60", @"5", @"kg"];
    
    
    [picker_weight cj_popupInWindowAtPosition:CJWindowPositionBottom animationType:CJAnimationTypeNormal showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
        [picker_weight cj_hidePopupView];
    }];
}



#pragma mark - ValueConfirm
- (void)confirmDelegate_pickerView:(CJIndependentPickerView *)pickerToolBarView{
    if (pickerToolBarView.tag == 1000) {
        NSString *integer = @"", *decimal = @"", *unit = @"";
        
        for (int indexC = 0; indexC < pickerToolBarView.datas.count; indexC++) {
            NSString *string = [pickerToolBarView.selecteds objectAtIndex:indexC];
            if (indexC == 0) {
                integer = string;
            }else if (indexC == 1){
                decimal = string;
            }else if (indexC == 2){
                unit = string;
            }
        }
        NSString *value = [NSString stringWithFormat:@"%@.%@.%@", integer, decimal, unit];
        [[[UIAlertView alloc]initWithTitle:@"最后的值为" message:value delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
        [pickerToolBarView cj_hidePopupView];
    }
}

//- (void)confirmDelegate_pickerArea:(CJRelatedPickerView *)pickerToolBarView{
//    NSString *integer = @"", *decimal = @"", *unit = @"";
//    
//    for (int indexC = 0; indexC < pickerToolBarView.datas.count; indexC++) {
//        NSString *string = [pickerToolBarView.selecteds objectAtIndex:indexC];
//        if (indexC == 0) {
//            integer = string;
//        }else if (indexC == 1){
//            decimal = string;
//        }else if (indexC == 2){
//            unit = string;
//        }
//    }
//    NSString *value = [NSString stringWithFormat:@"%@.%@.%@", integer, decimal, unit];
//    [[[UIAlertView alloc]initWithTitle:@"最后的值为" message:value delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//    
//    [pickerToolBarView cj_hidePopupView];
//}


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
    
//    if (groupTableView == self.groupTableView1) {
//        self.groupTextLabel1.text = string;
//    } else if (groupTableView == self.groupTableView3) {
//        self.groupTextLabel3.text = string;
//    }
    
    [[[UIAlertView alloc]initWithTitle:@"最后的值为" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    
    [picker_area cj_hidePopupView];

}

- (void)confirmDelegate_datePicker:(CJDatePickerToolBarView *)pickerToolBarView{
    NSDate *selDate = pickerToolBarView.datePicker.date;
    NSString *value = [NSString stringWithFormat:@"%@", selDate];
    [[[UIAlertView alloc]initWithTitle:@"所选日期为" message:value delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    
    [pickerToolBarView cj_hidePopupView];
}

#pragma mark - ValueChange
- (void)valueChangeDelegate_datePicker:(CJDatePickerToolBarView *)pickerToolBarView{
    UIDatePicker *m_datePicker = pickerToolBarView.datePicker;
    
    NSDate *date = m_datePicker.date;
    NSDate *maximumDate = m_datePicker.maximumDate;
    NSDate *minimumDate = m_datePicker.minimumDate;
    
    NSTimeZone *zone =[NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localDate =[date dateByAddingTimeInterval: interval];
    
    NSLog(@"1当前选择:%@",localDate);
    
    if ([date compare:minimumDate] == NSOrderedAscending) {
        NSLog(@"当前选择日期太小");
    }else if ([date compare:maximumDate] == NSOrderedDescending) {
        NSLog(@"当前选择日期太大");
    }
}

- (void)dealloc{
    [picker_birthday cj_hidePopupView];
    picker_birthday.delegate = nil;
    picker_birthday = nil;
    
    [picker_weight cj_hidePopupView];
    picker_weight.delegate = nil;
    picker_weight = nil;
    
    [picker_area cj_hidePopupView];
    picker_area.delegate = nil;
    picker_area = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
