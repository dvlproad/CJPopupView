//
//  IjinbuUser.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/4/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IjinbuUser : MTLModel <MTLJSONSerializing>

+ (instancetype)current;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *imName;
@property (strong, nonatomic) NSString *imPassword;

@property (copy, nonatomic) NSString *token;

@end
