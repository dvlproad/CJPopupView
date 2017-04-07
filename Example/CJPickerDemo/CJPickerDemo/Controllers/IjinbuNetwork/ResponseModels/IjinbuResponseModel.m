//
//  IjinbuResponseModel.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "IjinbuResponseModel.h"

@implementation IjinbuResponseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return  @{
              @"status":    @"status",
              @"msg":       @"message",
              @"result":    @"result"
              };
}

@end
