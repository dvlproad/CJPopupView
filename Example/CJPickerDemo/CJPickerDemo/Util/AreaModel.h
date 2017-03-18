//
//  AreaModel.h
//  CJPickerDemo
//
//  Created by 李超前 on 2017/1/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//
#import <JSONModel/JSONModel.h>

@protocol CityModel

@end

@interface StateModel : JSONModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger containValueCount;
@property (nonatomic, strong) NSArray<CityModel> *members;

@end


@interface CityModel : JSONModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger containValueCount;
@property (nonatomic, strong) NSArray *members;

@end





