//
//  IjinbuUploadItemRequest.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/1/20.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IjinbuUploadItemRequest.h"

@implementation IjinbuUploadItemRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"localUrl":       NSNull.null,
             @"block":          NSNull.null,
             @"uploadItemToWhere":   @"uploadType",
             };
}

@end
