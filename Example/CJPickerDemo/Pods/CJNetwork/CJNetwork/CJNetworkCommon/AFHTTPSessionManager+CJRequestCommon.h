//
//  AFHTTPSessionManager+CJRequestCommon.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/6/13.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJRequestSettingModel.h"
#import "CJRequestInfoModel.h"

@interface AFHTTPSessionManager (CJRequestCommon) {
    
}
#pragma mark - 网络操作

/// 在请求前根据设置做相应处理
- (BOOL)__didEventBeforeStartRequestWithUrl:(nullable NSString *)Url
                                     params:(nullable NSDictionary *)params
                               settingModel:(CJRequestSettingModel *)settingModel
                                    success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success;

///网络请求获取到数据时候执行的方法(responseObject必须是解密后的数据)
- (void)__didRequestSuccessForTask:(NSURLSessionDataTask * _Nonnull)task
                withResponseObject:(nullable id)responseObject
                       isCacheData:(BOOL)isCacheData
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success;

///网络请求不到数据的时候（无网 或者 有网但服务器异常等无数据时候）执行的方法
- (void)__didRequestFailureForTask:(NSURLSessionDataTask * _Nonnull)task
                 withResponseError:(NSError * _Nullable)error
                            forUrl:(nullable NSString *)Url
                            params:(nullable id)params
                      settingModel:(CJRequestSettingModel *)settingModel
                           failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure;

@end
