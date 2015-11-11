//
//  ArrayDictonaryModel.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ArrayDictonaryModel.h"

@implementation ArrayDictonaryModel

- (id)initWithC_0_data:(NSArray *)C_0_data dicArray:(NSArray *)dicArray{
    self = [super init];
    if (self) {
        self.C_0_data = C_0_data;
        self.dicArray = dicArray;
        
        
        NSInteger componentCount = dicArray.count+1;
        self.datas = [[NSMutableArray alloc]initWithCapacity:componentCount];
        self.datas_titles = [[NSMutableArray alloc]initWithCapacity:componentCount];
        self.selecteds_index = [[NSMutableArray alloc]initWithCapacity:componentCount];
        self.selecteds_titles = [[NSMutableArray alloc]init];
        
        NSMutableArray *selecteds_index = [[NSMutableArray alloc]init];
        for (int i = 0; i < componentCount; i++) {
            [selecteds_index addObject:@"0"];
        }
        self.selecteds_index = selecteds_index;
        
    }
    return self;
}

//- (void)setSelecteds_index:(NSArray *)selecteds_index{ //使用重写 setSelecteds_index: 方法，为什么无法self.selecteds_index的count始终为0
- (void)updateSelecteds_index:(NSArray *)selecteds_index{
    if (self.selecteds_index.count != self.dicArray.count+1) {
        NSLog(@"error: 默认值个数设置出错.请检查");
        return;
    }
    
    self.selecteds_index = selecteds_index;
    self.selecteds_titles = [[NSMutableArray alloc]init];//每次更新selecteds_index的时候，重新初始化selecteds_titles，防止上一操作有三个component可操作，而下一个component只有比上一个少component，比如只有两个的时候，会出现在下一个component中操作时候，选出来的的第三个值不是空""，而是上一个component的第三个值
    
    BOOL isInitialized = NO;
    if (self.datas == nil || self.datas.count == 0) {
        isInitialized = YES;
    }
    
    
    //从第component个更新后面的数据，如：选择由"福建-福州-鼓楼"变为"福建-福州-晋安",变的只为最后一个选项，所以前面两个我们可以不用重新取
    
    //因为第一个component的C_0_data始终是固定的，所以我们要做的只是确定在不同的component中选择不同的selectedIndex，整个datas会变成什么样。
    if (isInitialized) { //如果是第一次初始化，则使用addObject，以后再使用replaceObjectAtIndex
        [self.datas addObject:self.C_0_data];
    }else{
        [self.datas replaceObjectAtIndex:0 withObject:self.C_0_data]; //可省略
    }
    
    NSInteger componentCount = selecteds_index.count;  //默认值有几对，则有几组
    for (int indexC = 0; indexC < componentCount; indexC++) {
        //获取第component部分的值及该component部分的当前选项索引
        NSArray *C_0_data = [self.datas objectAtIndex:indexC];
        NSInteger selectedIndex = [selecteds_index[indexC] integerValue];
        
        if (C_0_data.count == 0) {
            NSLog(@"当前component里的可选项为0，则当前无可选，则之后的component都默认是选为空");
            for (int indexC_new = indexC; indexC_new < componentCount; indexC_new++) {
                NSString *C_0_title = @"";
                [self.selecteds_titles addObject:C_0_title];
            }
            return;
        }
        //第component部分选择了 第selectedIndex个,即第component部分选择的选项为:份是否是最后一个componentCount两种情况
        if (indexC == componentCount - 1) {
            NSString *C_0_title = [C_0_data objectAtIndex:selectedIndex];
            [self.selecteds_titles addObject:C_0_title];
            return;
        }
        
        
        
        NSDictionary *C_0_dicSelected = [C_0_data objectAtIndex:selectedIndex];//values = datasC
        
        //则①第component部分的值为
        NSString *C_0_keyTitle = [[self.dicArray objectAtIndex:indexC] objectForKey:@"head"];
        NSString *C_0_title = [C_0_dicSelected objectForKey:C_0_keyTitle];
        [self.selecteds_titles addObject:C_0_title];
        
        /*
         NSMutableArray *C_0_titles = [[NSMutableArray alloc]init];
         for (NSDictionary *dic in C_0_data) {
         NSString *C_0_title = [dic objectForKey:C_0_keyTitle];
         [C_0_titles addObject:C_0_title];
         }
         if (isInitialized) {
         [datas_titles addObject:C_0_title];
         }else{
         [datas_titles replaceObjectAtIndex:iii withObject:C_0_title];
         }
         */
        //则②第component+1部分即component+1后的部分的值为
        NSString *C_0_keyValue = [[self.dicArray objectAtIndex:indexC] objectForKey:@"value"];
        NSArray *C_1_data = [C_0_dicSelected objectForKey:C_0_keyValue];
        
        //[datas replaceObjectAtIndex:iii+1 withObject:C_1_data];
        if (isInitialized) { //如果是第一次初始化，则使用addObject，以后再使用replaceObjectAtIndex
            [self.datas addObject:C_1_data];
        }else{
            [self.datas replaceObjectAtIndex:indexC+1 withObject:C_1_data];
        }
    }
    return;
}


@end
