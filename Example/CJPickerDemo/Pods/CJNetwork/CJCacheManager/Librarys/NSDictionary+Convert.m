//
//  NSDictionary+Convert.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "NSDictionary+Convert.h"

@implementation NSDictionary (Convert)

- (NSString *)convertToString{
    NSString *resultString = nil;
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        resultString = [string stringByAppendingString:string];
    }
    return resultString;
}

- (NSData *)convertToData{
    NSData *data = nil;
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    }
    return data;
}


@end
