//
//  PickerViewController.m
//  CJPickerDemo
//
//  Created by ciyouzen on 6/20/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import "PickerViewController.h"
#import "CJDefaultDatePicker.h"
#import "CJIndependentPickerView.h"
//#import "CJRelatedPickerView.h"
#import "CJRelatedPickerRichView.h"
#import "GroupDataUtil.h"

#import <CJBaseUIKit/CJDefaultToolbar.h>
#import <CJBaseUIKit/UIView+CJShowExtendView.h>

@interface PickerViewController () <CJRelatedPickerRichViewDelegate>
{
    CJDefaultDatePicker *birthdayPicker;
    CJIndependentPickerView *weightPicker;
    CJRelatedPickerRichView *areaPicker;
}

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


/// 生日选择
- (IBAction)chooseBirthday:(id)sender{
    if (birthdayPicker == nil) {
        birthdayPicker = [[CJDefaultDatePicker alloc] init];
        
        CJDefaultToolbar *toolbar = [[CJDefaultToolbar alloc] initWithFrame:CGRectZero];
        [birthdayPicker addToolbar:toolbar];
        
        NSDateFormatter *dateFormatter = birthdayPicker.dateFormatter;
        
        toolbar.option = CJDefaultToolbarOptionConfirm | CJDefaultToolbarOptionValue | CJDefaultToolbarOptionCancel;
        
        __weak typeof(birthdayPicker)weakbirthdayPicker = birthdayPicker;
        [birthdayPicker setValueChangedHandel:^(UIDatePicker *datePicker) {
            UIDatePicker *m_datePicker = datePicker;
            
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
            
            NSString *dateString = [dateFormatter stringFromDate:localDate];
            [toolbar updateShowingValue:dateString];
        }];
        
        [toolbar setCancelHandle:^{
            [weakbirthdayPicker cj_hidePopupView];
        }];
        
        [toolbar setConfirmHandle:^{
            NSDate *selDate = weakbirthdayPicker.datePicker.date;
            
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *selDateString = [dateFormatter stringFromDate:selDate];
            
            [[[UIAlertView alloc]initWithTitle:@"所选日期为" message:selDateString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            
            [weakbirthdayPicker cj_hidePopupView];
        }];
        
        
        birthdayPicker.datePicker.datePickerMode = UIDatePickerModeDate;
        birthdayPicker.datePicker.maximumDate = [NSDate date];
        birthdayPicker.datePicker.minimumDate = [dateFormatter dateFromString:@"1900-01-01"];
        
        birthdayPicker.datePicker.date = [dateFormatter dateFromString:@"1989-12-27"];
    }
    NSDateFormatter *dateFormatter = birthdayPicker.dateFormatter;
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:birthdayPicker.datePicker.date];
    
    CJDefaultToolbar *toolbar = (CJDefaultToolbar *)birthdayPicker.toolbar;
    [toolbar updateShowingValue:dateString];
    
    CGFloat popupViewHeight = CGRectGetHeight(birthdayPicker.frame);
    
    UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
    [birthdayPicker cj_popupInBottomWindow:CJAnimationTypeNormal withHeight:popupViewHeight blankBGColor:blankBGColor showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
        [birthdayPicker cj_hidePopupView];
        
    }];
    
}


/// 地区选择
- (IBAction)chooseArea:(id)sender{
    if (areaPicker == nil) {
        areaPicker = [[CJRelatedPickerRichView alloc] initWithFrame:CGRectMake(0, 0, 200, 162)];
        
        NSMutableArray *componentDataModels = [GroupDataUtil groupDataAllArea];
        
        [areaPicker setComponentDataModels:componentDataModels];
        [areaPicker updateTableViewBackgroundColor:[UIColor greenColor] inComponent:0];
        [areaPicker updateTableViewBackgroundColor:[UIColor yellowColor] inComponent:1];
        [areaPicker updateTableViewBackgroundColor:[UIColor greenColor] inComponent:2];
        [areaPicker setDelegate:self];
    }
    
//    areaPicker.selecteds_default = @[@"福建", @"泉州", @"安溪县"];
    
    
    areaPicker.frame = CGRectMake(0, 0, 400, 162);
    CGFloat popupViewHeight = CGRectGetHeight(areaPicker.frame);
    UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
    [areaPicker cj_popupInBottomWindow:CJAnimationTypeNormal withHeight:popupViewHeight blankBGColor:blankBGColor showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
        [areaPicker cj_hidePopupView];
    }];
}


/// 体重选择
- (IBAction)chooseWeight:(id)sender{
    if (weightPicker == nil) {
        weightPicker = [[CJIndependentPickerView alloc] init];
        
        __weak typeof(weightPicker)weakweightPicker = weightPicker;
        
        CJDefaultToolbar *toolbar = [[CJDefaultToolbar alloc] initWithFrame:CGRectZero];
        [weightPicker addToolbar:toolbar];
        
        [toolbar setConfirmHandle:^{
            NSString *integer = @"", *decimal = @"", *unit = @"";
            
            for (int indexC = 0; indexC < weakweightPicker.datas.count; indexC++) {
                NSString *string = [weakweightPicker.selecteds objectAtIndex:indexC];
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
            
            [weakweightPicker cj_hidePopupView];
        }];
        NSMutableArray *integers = [[NSMutableArray alloc]init];
        for (int i = 40; i < 100; i++) {
            [integers addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        NSMutableArray *decimals = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i++) {
            [decimals addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        NSArray *units = @[@"kg", @"磅"];
        
        weightPicker.datas = @[integers, decimals, units];
        weightPicker.tag = 1000;
    }
    
    weightPicker.selecteds_default = @[@"60", @"5", @"kg"];
    
    CGFloat popupViewHeight = CGRectGetHeight(weightPicker.frame);
    UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
    [weightPicker cj_popupInBottomWindow:CJAnimationTypeNormal withHeight:popupViewHeight blankBGColor:blankBGColor showComplete:^{
        NSLog(@"显示完成");
    } tapBlankComplete:^() {
        NSLog(@"点击背景完成");
        [weightPicker cj_hidePopupView];
    }];
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
    
    [areaPicker cj_hidePopupView];

}


- (void)dealloc{
    [birthdayPicker cj_hidePopupView];
    birthdayPicker = nil;
    
    [weightPicker cj_hidePopupView];
    weightPicker = nil;
    
    [areaPicker cj_hidePopupView];
    areaPicker.delegate = nil;
    areaPicker = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
