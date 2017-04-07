//
//  HCModel.h
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HCModel : MTLModel <MTLJSONSerializing>

// 快速构造指定格式的日期格式化对象
+ (NSDateFormatter *)dateFormatter:(NSString *)dateFormat;

// 从JSON对象转为实体
+ (id)modelFromJson:(id)data error:(NSError *__autoreleasing *)error;

// 从JSON对象转为实体集合
+ (NSArray *)modelArrayFormJson:(NSArray *)array error:(NSError *__autoreleasing *)error;

// 从实体转为JSON对象
+ (NSDictionary *)jsonDictionaryFromModel:(id)data error:(NSError *__autoreleasing *)error;

// 从实体集合转为JSON数组对象
+ (NSArray *)jsonArrayFromModelArray:(NSArray *)array error:(NSError *__autoreleasing *)error;

@end
