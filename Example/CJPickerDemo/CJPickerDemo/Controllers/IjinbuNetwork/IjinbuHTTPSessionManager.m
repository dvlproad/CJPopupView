//
//  IjinbuHTTPSessionManager.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "IjinbuHTTPSessionManager.h"
#import <OpenUDID/OpenUDID.h>
#import "CJJSONResponseSerializer.h"

#import "IjinbuSession.h"

static NSString *const HPServerAPIVer = @"2.5.1207";
NSString * ijinbuBaseUrl = @"http://www.ijinbu.com";

@implementation IjinbuHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance {
    static AFHTTPSessionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self createSessionManager];
    });
    
    //登录成功后，有session，添加适当的token
    if ([[IjinbuSession current].nid length] > 0) {
        [[_sharedInstance requestSerializer] setValue:[IjinbuSession current].nid forHTTPHeaderField:@"sid"];
    }
    
    if ([IjinbuSession current].user.token.length > 0) {
        [[_sharedInstance requestSerializer] setValue:[IjinbuSession current].user.token forHTTPHeaderField:@"token"];
    }
    
    return _sharedInstance;
}

+ (AFHTTPSessionManager *)createSessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ijinbuBaseUrl]];
    
    //-->ijinbu
    NSString *deviceId = [OpenUDID value];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:deviceId forHTTPHeaderField:@"imei"];
    [requestSerializer setValue:@"1" forHTTPHeaderField:@"clientType"];
    [requestSerializer setValue:@"2" forHTTPHeaderField:@"appType"];
    //NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey];
    [requestSerializer setValue:HPServerAPIVer forHTTPHeaderField:@"ver"];
    [requestSerializer setValue:[[NSString stringWithFormat:@"%@123456", deviceId] MD5] forHTTPHeaderField:@"sign"];
    [requestSerializer setValue:[NSBundle mainBundle].bundleIdentifier forHTTPHeaderField:@"bundleId"];
    manager.requestSerializer  = requestSerializer;
    
    CJJSONResponseSerializer *responseSerializer = [CJJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                 @"text/plain",
                                                 @"text/html",
                                                 @"application/json",
                                                 @"application/json;charset=utf-8", nil];
    manager.responseSerializer = responseSerializer;
    
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return manager;
}

@end
