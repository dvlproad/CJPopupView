//
//  CJDataGroupModel.m
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJDataGroupModel.h"

@interface CJDataGroupModel ()

@property(nonatomic, strong) NSArray *component0Datas;

@property(nonatomic, strong) NSMutableArray *datas_titles;

@end



@implementation CJDataGroupModel

/** 完整的描述请参见文件头部 */
- (id)initWithComponent0Datas:(NSArray *)component0Datas
           sortByCategoryKeys:(NSArray *)categoryKeys
            categoryValueKeys:(NSArray *)categoryValueKeys
{
    self = [super init];
    if (self) {
        self.component0Datas = component0Datas;
        self.sortOrders = categoryKeys;
        self.categoryValueKeys = categoryValueKeys;
        
        NSInteger componentCount = categoryKeys.count;
        self.datas = [[NSMutableArray alloc] initWithCapacity:componentCount];
        self.datas_titles = [[NSMutableArray alloc] initWithCapacity:componentCount];
        self.selectedTitles = [[NSMutableArray alloc] init];
        
        NSMutableArray *selectedIndexs = [[NSMutableArray alloc] init];
        for (int i = 0; i < componentCount; i++) {
            [selectedIndexs addObject:@"0"];
        }
        self.selectedIndexs = selectedIndexs;
        
    }
    return self;
}

- (void)updateSelectedIndexs:(NSArray *)selectedIndexs {
    if (self.selectedIndexs.count != self.sortOrders.count) {
        NSLog(@"error: 默认值个数设置出错.请检查");
        return;
    }
    
    self.selectedIndexs = selectedIndexs;
    self.selectedTitles = [[NSMutableArray alloc] init];//每次更新selectedIndexs的时候，重新初始化selectedTitles，防止切换选项时，当两个选项的下属值个数不一样时出现问题。如：选择"福建"时，有“市”和"县"，而选择"北京"时，只要"区"，即上一选项有三个component可操作，而另一个比如只有两个component可操作的时候，会出现在另一个选项操作的时候，选出来的的第三个值不是空""，而是上一个选项的第三个值
    
    BOOL isInitialized = NO;
    if (self.datas == nil || self.datas.count == 0) {
        isInitialized = YES;
    }
    
    
    //从第component个更新后面的数据，如：选择由"福建-福州-鼓楼"变为"福建-福州-晋安",变的只为最后一个选项，所以前面两个我们可以不用重新取
    
    //因为第一个component的C_0_data始终是固定的，所以我们要做的只是确定在不同的component中选择不同的selectedIndex，整个datas会变成什么样。
    if (isInitialized) { //如果是第一次初始化，则使用addObject，以后再使用replaceObjectAtIndex
        [self.datas addObject:self.component0Datas];
    }else{
        [self.datas replaceObjectAtIndex:0 withObject:self.component0Datas]; //可省略
    }
    
    NSInteger componentCount = selectedIndexs.count;  //默认值有几对，则有几组
    for (int componentIndex = 0; componentIndex < componentCount; componentIndex++) {
        //获取第component部分的值及该component部分的当前选项索引
        NSArray *componentDatas = [self.datas objectAtIndex:componentIndex];
        NSInteger selectedIndex = [selectedIndexs[componentIndex] integerValue];
        
        if (componentDatas.count == 0) {
            NSLog(@"当前component里的可选项为0，则当前无可选，则之后的component都默认是选为空");
            for (int indexC_new = componentIndex; indexC_new < componentCount; indexC_new++) {
                NSString *C_0_title = @"";
                [self.selectedTitles addObject:C_0_title];
            }
            return;
        }
        //第component部分选择了 第selectedIndex个,即第component部分选择的选项为:份是否是最后一个componentCount两种情况
        if (componentIndex == componentCount - 1) {
            NSString *C_0_title = [componentDatas objectAtIndex:selectedIndex];
            [self.selectedTitles addObject:C_0_title];
            return;
        }
        
        
        
        NSDictionary *C_0_dicSelected = [componentDatas objectAtIndex:selectedIndex];
        
        //则①第component部分的值为
        NSString *categoryKey = [self.sortOrders objectAtIndex:componentIndex];
        NSString *C_0_title = [C_0_dicSelected objectForKey:categoryKey];
        
        [self.selectedTitles addObject:C_0_title];
        
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
//        NSString *C_0_keyValue = [[self.dicArray objectAtIndex:indexC] objectForKey:@"value"];
        
        NSString *categoryValueKey =[self.categoryValueKeys objectAtIndex:componentIndex];
        NSArray *C_1_data = [C_0_dicSelected objectForKey:categoryValueKey];
        
        //[datas replaceObjectAtIndex:iii+1 withObject:C_1_data];
        if (isInitialized) { //如果是第一次初始化，则使用addObject，以后再使用replaceObjectAtIndex
            [self.datas addObject:C_1_data];
        }else{
            [self.datas replaceObjectAtIndex:componentIndex+1 withObject:C_1_data];
        }
    }
    return;
}


@end
