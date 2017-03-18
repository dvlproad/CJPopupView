//
//  CJIndependentPickerView.m
//  CJPickerDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJIndependentPickerView.h"

@implementation CJIndependentPickerView

- (id)initWithNibNameDefaultAndDelegate:(id<CJIndependentPickerViewDelegate>)delegate{
    self = [[CJIndependentPickerView alloc]initWithNibName:@"CJIndependentPickerView" delegate:self];
    return self;
}

- (id)initWithNibName:(NSString *)nibName delegate:(id<CJIndependentPickerViewDelegate>)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.datas count];
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[self.datas objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self.datas objectAtIndex:component] objectAtIndex:row];
}



#pragma mark - ValueChange_PickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *datasC = [self.datas objectAtIndex:component];
    NSString *string = [datasC objectAtIndex:row];
    [self.selecteds replaceObjectAtIndex:component withObject:string];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChangeDelegate_pickerView:)]) {
        [self.delegate valueChangeDelegate_pickerView:self];
    }
}

#pragma mark - 选择确认_PickerView
- (IBAction)confirm_pickerView:(id)sender{
    //self.block();
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmDelegate_pickerView:)]) {
        [self.delegate confirmDelegate_pickerView:self];
    }
}


#pragma mark - 设置初始默认值
- (void)setSelecteds_default:(NSArray *)selecteds_default{
    if (selecteds_default.count != self.datas.count) {
        NSLog(@"ERROR: 默认值个数不正确 应该是%zd个，而不是%zd个", self.datas.count, selecteds_default.count);
        return;
    }
    
    self.selecteds = [[NSMutableArray alloc] initWithArray:selecteds_default];
    
    for (int indexC = 0; indexC < self.datas.count; indexC++) {
        NSArray *datasC = [self.datas objectAtIndex:indexC];
        NSString *selected_default = [selecteds_default objectAtIndex:indexC];
        if ([datasC containsObject:selected_default] == NO) {
            NSLog(@"ERROR: %@ noContain", [NSString stringWithFormat:@"%s:%d", __func__, __LINE__]);
            continue;
        }
        NSInteger indexR = [datasC indexOfObject:selected_default];
        [self.pickerView selectRow:indexR inComponent:indexC animated:NO];
    }
    
}

@end
