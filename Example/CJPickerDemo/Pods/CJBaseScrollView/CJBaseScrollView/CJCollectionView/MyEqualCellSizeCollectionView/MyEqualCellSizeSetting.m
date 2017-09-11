//
//  MyEqualCellSizeSetting.m
//  AllScrollViewDemo
//
//  Created by ciyouzen on 2017/9/11.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "MyEqualCellSizeSetting.h"

@implementation MyEqualCellSizeSetting

- (instancetype)init {
    self = [super init];
    if (self) {
        self.extralItemSetting = CJExtralItemSettingNone;
        self.maxDataModelShowCount = NSIntegerMax;
        //NSLog(@"maxDataModelShowCount = %ld", self.maxDataModelShowCount);
    }
    return self;
}

@end
