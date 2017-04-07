//
//  IjinbuNetworkClient+Login.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/6.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IjinbuNetworkClient.h"

@interface IjinbuNetworkClient (Login)

- (NSURLSessionDataTask *)requestijinbuLogin_name:(NSString *)name
                                             pasd:(NSString*)pasd
                                          success:(HPSuccess)success
                                          failure:(HPFailure)failure;

@end
