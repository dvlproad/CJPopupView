//
//  CJDataGroupModel.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJDataGroupModel : NSObject

@property(nonatomic, strong) NSArray *sortOrders;
@property(nonatomic, strong) NSArray *categoryValueKeys;

@property(nonatomic, strong) NSArray *selectedIndexs;

@property(nonatomic, strong) NSMutableArray *datas;
@property(nonatomic, strong) NSMutableArray *selectedTitles;

/**
 *  初始化数据
 *
 *  @param component0Datas   数据
 *  @param categoryKeys      要取得分类所需的key
 *  @param categoryValueKeys 要取得该分类子值所需的key(eg:选择福建省，得到的值是福建省下的所有市)
 *
 *  @return 数据模型
 */
- (id)initWithComponent0Datas:(NSArray *)component0Datas
           sortByCategoryKeys:(NSArray *)categoryKeys
            categoryValueKeys:(NSArray *)categoryValueKeys;


- (void)updateSelectedIndexs:(NSArray *)selectedIndexs;

@end
