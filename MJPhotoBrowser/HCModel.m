//
//  HCModel.m
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "HCModel.h"

@interface HCModel ()

@end

@implementation HCModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

- (void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}

+ (NSDateFormatter *)dateFormatter:(NSString *)dateFormat
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:dateFormat];
    return fmt;
}

+ (id)modelFromJson:(id)data error:(NSError *__autoreleasing *)error
{
    return [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:data error:error];
}

+ (NSArray *)modelArrayFormJson:(NSArray *)array error:(NSError *__autoreleasing *)error
{
    return [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:array error:error];
}

//+ (NSDictionary *)jsonDictionaryFromModel:(id)data error:(NSError *__autoreleasing *)error
//{
//    return [MTLJSONAdapter JSONDictionaryFromModel:data error:error];
//}
//
//+ (NSArray *)jsonArrayFromModelArray:(NSArray *)array error:(NSError *__autoreleasing *)error
//{
//    return [MTLJSONAdapter JSONArrayFromModels:array error:error];
//}

@end
