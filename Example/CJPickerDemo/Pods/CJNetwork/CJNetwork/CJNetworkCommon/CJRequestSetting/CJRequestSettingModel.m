//
//  CJRequestSettingModel.m
//  CJNetworkDemo
//
//  Created by ciyouzen on 2018/5/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJRequestSettingModel.h"

@implementation CJRequestSettingModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.logType = CJRequestLogTypeConsoleLog;
    }
    return self;
}


@end
