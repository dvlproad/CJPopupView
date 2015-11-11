//
//  DropDownRadioButtons.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "DropDownRadioButtons.h"

@implementation DropDownRadioButtons

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        comRadioButtons = [[RadioButtons alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        comRadioButtons.delegate = self;
        [self addSubview:comRadioButtons];
    }
    return self;
}

- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    NSMutableArray *titles_head = [[NSMutableArray alloc]init];
    for (NSArray *array in datas) {
        NSString *title = [array firstObject];
        [titles_head addObject:title];
    }
    [comRadioButtons setTitles:titles_head radioButtonNidName:@"RadioButton_DropDown"];
}

- (void)radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index{
    
    NSArray *chooseArray = [self.datas objectAtIndex:index];
    
    TableViewArraySingle *customView = [[TableViewArraySingle alloc]initWithFrame:CGRectZero];
    [customView setFrame:CGRectMake(self.frame.size.width*index/3, 264, self.frame.size.width/3, 200)];
    customView.datas = chooseArray;
    [customView setDelegate:self];
    [comRadioButtons showDropDownExtendView:customView inView:self.superview complete:nil];
}

- (void)tv_ArraySingle:(TableViewArraySingle *)tv_ArraySingle didSelectText:(NSString *)text{
    [comRadioButtons didSelectInExtendView:text];
    
    if([self.delegate respondsToSelector:@selector(ddRadioButtons:didSelectText:)]){
        [self.delegate ddRadioButtons:self didSelectText:text];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
