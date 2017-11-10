//
//  AreaModel.m
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/1/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AreaModel.h"

@implementation StateModel

+ (JSONKeyMapper *)keyMapper {
    //    NSDictionary *dictionary = @{@"text": @"categoryFirst",
    //                                 @"members": @"categoryValue"};
    NSDictionary *dictionary = @{@"text": @"state",
                                 @"members": @"cities"};
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:dictionary];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}


@end


@implementation CityModel

+ (JSONKeyMapper *)keyMapper {
    //    NSDictionary *dictionary = @{@"text": @"categorySecond",
    //                                 @"members": @"categoryValue"};
    NSDictionary *dictionary = @{@"text": @"city",
                                 @"members": @"areas"};
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:dictionary];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
