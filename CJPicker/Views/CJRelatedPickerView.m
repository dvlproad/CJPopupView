//
//  CJRelatedPickerView.m
//  CJPickerToolBarViewDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJRelatedPickerView.h"

@implementation CJRelatedPickerView

- (id)initWithNibNameDefaultAndDelegate:(id<CJRelatedPickerViewDelegate>)delegate{
    self = [[CJRelatedPickerView alloc]initWithNibName:@"CJRelatedPickerView" delegate:delegate];
    return self;
}

- (id)initWithNibName:(NSString *)nibName delegate:(id<CJRelatedPickerViewDelegate>)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
}

+ (NSMutableArray *)getDatasByDatasC_0:(NSArray *)m_datasC_0 dicArray:(NSArray *)m_dicArray{
//    NSArray *datasC_0 = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
//    self.dicArray = @[@{@"head": @"state", @"value": @"cities"},
//                      @{@"head": @"city",  @"value": @"areas"}];
    NSArray *datasC_0 = m_datasC_0;
    
    NSString *datasC_value_0 = [[m_dicArray objectAtIndex:0] objectForKey:@"value"];
    NSString *datasC_value_1 = [[m_dicArray objectAtIndex:1] objectForKey:@"value"];
    
    NSDictionary *dataC_0 = [datasC_0 objectAtIndex:0];
    NSArray *array0 = [dataC_0 objectForKey:datasC_value_0];
    NSArray *datasC_1 = array0;
    
    NSDictionary *dataC_1 = [datasC_1 objectAtIndex:0];
    NSArray *array1 = [dataC_1 objectForKey:datasC_value_1];
    NSArray *datasC_2 = array1;
    
    return [NSMutableArray arrayWithArray:@[datasC_0, datasC_1, datasC_2]];
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.datas count];
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[self.datas objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *datasC = [self.datas objectAtIndex:component];
    if ([datasC count] == 0) {
        return @"kong";
    }
    
    if (component == self.datas.count-1) { //if current component is the last component
        NSString *data = [datasC objectAtIndex:row];
        return data;
    }else{
        NSDictionary *data = [datasC objectAtIndex:row];
        NSString *datasC_head = [[self.dicArray objectAtIndex:component] objectForKey:@"head"];
        return [data objectForKey:datasC_head];
    }
}



#pragma mark - ValueChange_PickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            NSArray *datasC = [self.datas objectAtIndex:component];
            NSDictionary *dataC_0 = [datasC objectAtIndex:row];
            NSString *datasC_head_0 = [[self.dicArray objectAtIndex:0] objectForKey:@"head"];
            NSString *datasC_value_0 = [[self.dicArray objectAtIndex:0] objectForKey:@"value"];
            NSString *string0 = [dataC_0 objectForKey:datasC_head_0];
            NSArray *array0 = [dataC_0 objectForKey:datasC_value_0];//datasC_1 = array0;
            [self.datas replaceObjectAtIndex:1 withObject:array0];
            
            NSDictionary *dataC_1 = [array0 objectAtIndex:0];
            NSString *datasC_head_1 = [[self.dicArray objectAtIndex:1] objectForKey:@"head"];
            NSString *datasC_value_1 = [[self.dicArray objectAtIndex:1] objectForKey:@"value"];
            NSString *string1 = [dataC_1 objectForKey:datasC_head_1];
            NSArray *array1 = [dataC_1 objectForKey:datasC_value_1];//datasC_2 = array1;
            [self.datas replaceObjectAtIndex:2 withObject:array1];
            
            NSString *string2 = @"";
            if ([array1 count] > 0) {
                string2 = [array1 objectAtIndex:0];
            }
            //NSLog(@"%@-%@-%@", string0, string1, string2);
            [self.selecteds replaceObjectAtIndex:0 withObject:string0];
            [self.selecteds replaceObjectAtIndex:1 withObject:string1];
            [self.selecteds replaceObjectAtIndex:2 withObject:string2];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            break;
        }
        case 1:
        {
            NSArray *datasC = [self.datas objectAtIndex:component];
            NSDictionary *dataC_1 = [datasC objectAtIndex:row];
            NSString *datasC_head_1 = [[self.dicArray objectAtIndex:1] objectForKey:@"head"];
            NSString *datasC_value_1 = [[self.dicArray objectAtIndex:1] objectForKey:@"value"];
            NSString *string1 = [dataC_1 objectForKey:datasC_head_1];
            NSArray *array1 = [dataC_1 objectForKey:datasC_value_1];
            [self.datas replaceObjectAtIndex:2 withObject:array1];
            
            NSString *string2 = @"";
            if ([array1 count] > 0) {
                string2 = [array1 objectAtIndex:0];
            }
            //NSLog(@"%@-%@", string1, string2);
            [self.selecteds replaceObjectAtIndex:1 withObject:string1];
            [self.selecteds replaceObjectAtIndex:2 withObject:string2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
            break;
        }
        case 2:
        {
            NSArray *datasC = [self.datas objectAtIndex:component];
            NSString *string2 = @"";
            if ([datasC count] > 0) {
                string2 = [datasC objectAtIndex:row];
            }
            //NSLog(@"%@", string2);
            [self.selecteds replaceObjectAtIndex:2 withObject:string2];
            
            break;
        }
        default:
        {
            
            break;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChangeDelegate_pickerArea:)]) {
        [self.delegate valueChangeDelegate_pickerArea:self];
    }
}


#pragma mark - 选择确认_PickerView
- (IBAction)confirm_pickerView:(id)sender{
    //self.block();
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmDelegate_pickerArea:)]) {
        [self.delegate confirmDelegate_pickerArea:self];
    }
}



#pragma mark - 设置初始默认值
- (void)setSelecteds_default:(NSArray *)selecteds_default{
    if (selecteds_default.count != self.datas.count) {
        NSLog(@"ERROR: 默认值个数不正确 应该是%zd个，而不是%zd个", [self.datas count], [selecteds_default count]);
        return;
    }
    
    self.selecteds = [[NSMutableArray alloc] initWithArray:selecteds_default];
    
    
    
    for (int indexC = 0; indexC < self.datas.count; indexC++) {
        NSArray *dataC = [self.datas objectAtIndex:indexC];
        NSMutableArray *array_string = [[NSMutableArray alloc]init];
        
        if (indexC == self.datas.count-1) { //if current component is the last component
            array_string = [NSMutableArray arrayWithArray:dataC];
        }else{
            NSString *datasC_head_0 = [[self.dicArray objectAtIndex:indexC] objectForKey:@"head"];
            for (int index = 0; index < dataC.count; index++) {
                NSDictionary *dataC_0 = [dataC objectAtIndex:index];
                
                NSString *string0 = [dataC_0 objectForKey:datasC_head_0];
                [array_string addObject:string0];
            }
        }
        
        
        NSInteger indexR = 0;
        NSString *selected_default = [selecteds_default objectAtIndex:indexC];
        if ([array_string containsObject:selected_default] == NO) {
            NSLog(@"Debug: noContain %@", selected_default);
            indexR = 0;
            [self.selecteds replaceObjectAtIndex:indexC withObject:array_string[0]];
        }else{
            indexR = [array_string indexOfObject:selected_default];
        }
        
        [self.pickerView selectRow:indexR inComponent:indexC animated:NO];
        [self.pickerView reloadComponent:indexC]; //don't lose this line
        
        
        
        if (indexC < self.datas.count-1) { //if current component is not the last component
            NSString *datasC_value_0 = [[self.dicArray objectAtIndex:indexC] objectForKey:@"value"];
            NSArray *datasC_1_etet = [[dataC objectAtIndex:indexR] objectForKey:datasC_value_0];
            [self.datas replaceObjectAtIndex:indexC+1 withObject:datasC_1_etet];
        }
    }
}

@end
