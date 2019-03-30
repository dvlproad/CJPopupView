//
//  AreaModel.h
//  CJPickerDemo
//
//  Created by ciyouzen on 2017/1/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger containValueCount;
@property (nonatomic, strong) NSMutableArray *members;

@end



@interface StateModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger containValueCount;
@property (nonatomic, strong) NSMutableArray<CityModel *> *members;

@end








