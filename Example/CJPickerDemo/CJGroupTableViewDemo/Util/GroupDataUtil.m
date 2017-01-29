//
//  GroupDataUtil.m
//  CJRelatedPickerRichViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "GroupDataUtil.h"

#define kCategoryFirst      @"categoryFirst"    //eg:state  省
#define kCategoryFirstID    @"categoryFirstID"  //eg:state  省ID
#define kCategorySecond     @"categorySecond"   //eg:city   市
#define kCategorySecondID   @"categorySecondID" //eg:city   市ID
#define kCategoryThird      @"categoryThird"    //eg:area   区
#define kCategoryThirdID    @"categoryThirdID"  //eg:area   区
#define kCategoryFourth     @"categoryFourth"   //eg:
#define kCategoryFourthID   @"categoryFourthID" //eg:

#define kCategoryValue  @"categoryValue"

@implementation GroupDataUtil

+ (NSMutableArray<CJComponentDataModel *> *)groupData1 {
    NSArray *titles = @[@"区域", @"鼓楼", @"台江", @"仓山"];
    
    NSMutableArray *componentDataModels = [CJComponentDataModelUtil selectedIndexs:@[@"0"] inTitles:titles];
    
    return componentDataModels;
}


+ (NSMutableArray<CJComponentDataModel *> *)groupData2 {
    NSArray *component0Datas =
    @[
      @{kCategoryFirst:@"福建省",
        kCategoryValue:@[@"福州", @"厦门", @"漳州", @"泉州"]
        },
      @{kCategoryFirst:@"四川",
        kCategoryValue:@[@"成都", @"眉山", @"乐山", @"达州"]
        },
      @{kCategoryFirst:@"北京",
        kCategoryValue:@[@"通州", @"房山", @"昌平", @"顺义"]
        },
      @{kCategoryFirst:@"云南",
        kCategoryValue: @[@"昆明", @"丽江", @"大理", @"西双版纳"]
        }];
    NSArray *sortOrders = @[kCategoryFirst, @""];
    NSArray *categoryValueKeys = @[kCategoryValue, @""];
    
    NSMutableArray *componentDataModels = [CJComponentDataModelUtil selectedIndexs:@[@"0", @"0"] inDictionarys:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
    
    NSArray *array = [StateModel arrayOfModelsFromDictionaries:component0Datas error:nil];
    NSLog(@"array = %@", array);
    
//    for (NSDictionary *dictionary in component0Datas) {
//        CJDataModelSample2 *dataModelSample = [[CJDataModelSample2 alloc] initWithDictionary:dictionary error:nil];
//        NSLog(@"dataModelSample = %@", dataModelSample);
//    }
    
    
    return componentDataModels;
}

+ (NSMutableArray<CJComponentDataModel *> *)groupData3 {
    NSArray *component0Datas =
    @[
      @{kCategoryFirst:@"福建省",
        kCategoryValue:@[
                @{kCategorySecond:@"福州", kCategoryValue:@[@"鼓楼", @"台江", @"晋安", @"仓山", @"马尾"]},
                @{kCategorySecond:@"厦门", kCategoryValue:@[@"思明", @"湖里", @"集美", @"同安", @"海沧", @"翔安"]},
                @{kCategorySecond:@"漳州", kCategoryValue:@[@"龙海市", @"南靖县", @"云霄区", @"诏安县", @"华安县"]},
                @{kCategorySecond:@"泉州", kCategoryValue:@[@"丰泽", @"鲤城", @"洛江"]}]
        },
      @{kCategoryFirst:@"四川",
        kCategoryValue:@[
                @{kCategorySecond:@"成都", kCategoryValue:@[@"锦江", @"武侯", @"都江堰", @"青羊"]},
                @{kCategorySecond:@"眉山", kCategoryValue:@[@"1区", @"2区", @"3区"]},
                @{kCategorySecond:@"乐山", kCategoryValue:@[@"4区", @"5区", @"6区"]},
                @{kCategorySecond:@"达州", kCategoryValue:@[@"7区", @"8区", @"9区"]}]
        },
      @{kCategoryFirst:@"北京",
        kCategoryValue:@[
                @{kCategorySecond:@"通州", kCategoryValue:@[]},
                @{kCategorySecond:@"房山", kCategoryValue:@[]},
                @{kCategorySecond:@"昌平", kCategoryValue:@[@"4区", @"5区", @"6区"]},
                @{kCategorySecond:@"顺义", kCategoryValue:@[@"7区", @"8区", @"9区"]}]
        },
      @{kCategoryFirst:@"云南",
        kCategoryValue: @[
                @{kCategorySecond:@"昆明", kCategoryValue:@[@"1区", @"2区", @"3区"]},
                @{kCategorySecond:@"丽江", kCategoryValue:@[@"4区", @"5区", @"6区"]},
                @{kCategorySecond:@"大理", kCategoryValue:@[@"7区", @"8区", @"9区"]},
                @{kCategorySecond:@"西双版纳", kCategoryValue:@[@"10区"]}]
        }];
    NSArray *sortOrders = @[kCategoryFirst, kCategorySecond, @""];
    NSArray *categoryValueKeys = @[kCategoryValue, kCategoryValue, @""];
    
    
    NSArray *array = [StateModel arrayOfModelsFromDictionaries:component0Datas error:nil];
    NSLog(@"array = %@", array);
    
    
    NSMutableArray *componentDataModels = [CJComponentDataModelUtil selectedIndexs:@[@"0", @"1", @"0"] inDictionarys:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
    
    return componentDataModels;
}

+ (NSMutableArray<CJComponentDataModel *> *)groupDataYule {
    NSArray *component0Datas = @[
                                 @{kCategoryFirst:@"娱乐",
                                   kCategoryValue:@[@"爱旅行", @"爱唱歌", @"爱电影"]},
                                 @{kCategoryFirst:@"学习",
                                   kCategoryValue:@[@"爱读书", @"爱看报", @"爱书法", @"爱其他"]},
                                 @{kCategoryFirst:@"0",
                                   kCategoryValue:@[@"0-0", @"0-1", @"0-2", @"0-3"]},
                                 @{kCategoryFirst:@"1",
                                   kCategoryValue:@[@"1-1", @"1-2", @"1-3"]}
                                 ];
    NSArray *sortOrders = @[kCategoryFirst, @""];
    NSArray *categoryValueKeys = @[kCategoryValue, @""];
    
    NSMutableArray *componentDataModels = [CJComponentDataModelUtil selectedIndexs:@[@"0", @"0"] inDictionarys:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
    
    return componentDataModels;
}

+ (NSMutableArray<CJComponentDataModel *> *)groupDataAllArea {
    NSArray *component0Datas = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    NSArray *sortOrders = @[@"state", @"city", @""];
    NSArray *categoryValueKeys = @[@"cities", @"areas", @""];
    
    NSArray *array = [StateModel arrayOfModelsFromDictionaries:component0Datas error:nil];
    NSLog(@"array = %@", array);
    
    NSMutableArray *componentDataModels = [CJComponentDataModelUtil selectedIndexs:@[@"0", @"0", @"0"] inDictionarys:component0Datas sortByCategoryKeys:sortOrders categoryValueKeys:categoryValueKeys];
    
    return componentDataModels;
}


+ (NSArray<StateModel *> *)groupDataAllArea22 {
    NSArray *component0Datas = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];

    NSArray *array = [StateModel arrayOfModelsFromDictionaries:component0Datas error:nil];
    NSLog(@"array = %@", array);
    
    return array;
}

@end
