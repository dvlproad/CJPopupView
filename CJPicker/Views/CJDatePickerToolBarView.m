//
//  CJDatePickerToolBarView.m
//  CJPickerToolBarViewDemo
//
//  Created by lichq on 6/20/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJDatePickerToolBarView.h"

@implementation CJDatePickerToolBarView

- (id)initWithNibNameDefaultAndDelegate:(id<CJDatePickerToolBarViewDelegate>)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CJDatePickerToolBarView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibName delegate:(id<CJDatePickerToolBarViewDelegate>)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    //    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"PickerViewToolBarView" owner:self options:nil] objectAtIndex:0];
    
    if (self) {
        // Initialization code
        
        //        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        //        UIBarButtonItem *bbitem_flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //        UIBarButtonItem *bbitem_confirm = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewConfirm:)];
        //        [bbitem_confirm setTitleTextAttributes:[NSDictionary dictionaryWithObject:Color(43, 76, 171, 255) forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
        //        [toolBar setItems:@[bbitem_flex, bbitem_confirm]];
        //
        //
        //        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 1)];
        //        imageV.image = [UIImage imageNamed:@"line_gray"];
        
        
        //        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, 200)];
        //        self.pickerView.dataSource = self;
        //        self.pickerView.delegate = self;
        //
        //
        //
        //        [self addSubview:toolBar];
        //        [self addSubview:imageV];
        //        [self addSubview:self.pickerView];
    }
    return self;
}



#pragma mark - ValueChange_DatePicker
- (IBAction)valueChange_datePicker:(UIDatePicker *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChangeDelegate_datePicker:)]) {
        [self.delegate valueChangeDelegate_datePicker:self];
    }
}


#pragma mark - 选择确认_DatePicker
- (IBAction)confirm_datePicker:(id)sender{
    //self.block();
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmDelegate_datePicker:)]) {
        [self.delegate confirmDelegate_datePicker:self];
    }
}




#pragma mark - 设置初始默认值
- (void)setSelecteds_default:(NSArray *)selecteds_default{
//    if (selecteds_default.count != self.datas.count) {
//        NSLog(@"ERROR: 默认值个数不正确 应该是%d个，而不是%d个", self.datas.count, selecteds_default.count);
//        return;
//    }
//    
//    self.selecteds = [[NSMutableArray alloc] initWithArray:selecteds_default];
//    
//    for (int indexC = 0; indexC < self.datas.count; indexC++) {
//        NSArray *datasC = [self.datas objectAtIndex:indexC];
//        NSString *selected_default = [selecteds_default objectAtIndex:indexC];
//        if ([datasC containsObject:selected_default] == NO) {
//            NSLog(@"ERROR: %@ noContain", [NSString stringWithFormat:@"%s:%d", __func__, __LINE__]);
//            continue;
//        }
//        NSInteger indexR = [datasC indexOfObject:selected_default];
//        [self.pickerView selectRow:indexR inComponent:indexC animated:NO];
//    }
//    
    
}

@end
