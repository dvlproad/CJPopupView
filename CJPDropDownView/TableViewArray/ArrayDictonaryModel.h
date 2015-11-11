//
//  ArrayDictonaryModel.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/7/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayDictonaryModel : NSObject

@property(nonatomic, strong) NSArray *C_0_data;
@property(nonatomic, strong) NSArray *dicArray;
@property(nonatomic, strong) NSArray *selecteds_index;
@property(nonatomic, strong) NSMutableArray *selecteds_titles;
@property(nonatomic, strong) NSMutableArray *datas;
@property(nonatomic, strong) NSMutableArray *datas_titles;

- (id)initWithC_0_data:(NSArray *)C_0_data dicArray:(NSArray *)dicArray;
- (void)updateSelecteds_index:(NSArray *)selecteds_index;

@end
