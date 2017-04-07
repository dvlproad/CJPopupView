//
//  NSData+Convert.m
//  CommonAFNUtilDemo
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "NSData+Convert.h"

@implementation NSData (Convert)

- (NSDictionary *)convertToDictionary{
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:object];
    if (error) {
        return nil;
    }
    return dic;
}

@end
