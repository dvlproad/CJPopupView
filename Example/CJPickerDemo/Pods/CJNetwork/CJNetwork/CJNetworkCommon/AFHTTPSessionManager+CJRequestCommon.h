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

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionManager (CJRequestCommon) {
    
}
#pragma mark - 网络操作
/// 将params拼接到Url后
- (NSString *)__appendUrl:(NSString *)Url withParams:(NSDictionary *)urlParams;

/// 在请求前根据设置做相应处理
- (BOOL)__didEventBeforeStartRequestWithUrl:(NSString *)Url
                                     params:(nullable NSDictionary *)params
                               settingModel:(nullable CJRequestSettingModel *)settingModel
                                    success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success;

///网络请求获取到数据时候执行的方法(responseObject必须是解密后的数据)
- (void)__didRequestSuccessForTask:(NSURLSessionDataTask * _Nonnull)task
                withResponseObject:(nullable id)responseObject
                       isCacheData:(BOOL)isCacheData
                            forUrl:(NSString *)Url
                            params:(nullable id)params
                      settingModel:(nullable CJRequestSettingModel *)settingModel
                           success:(nullable void (^)(CJSuccessRequestInfo * _Nullable successRequestInfo))success;

///网络请求不到数据的时候（无网 或者 有网但服务器异常等无数据时候）执行的方法
- (void)__didRequestFailureForTask:(NSURLSessionDataTask * _Nonnull)task
                 withResponseError:(NSError * _Nullable)error
                            forUrl:(NSString *)Url
                            params:(nullable id)params
                      settingModel:(nullable CJRequestSettingModel *)settingModel
                           failure:(nullable void (^)(CJFailureRequestInfo * _Nullable failureRequestInfo))failure;

NS_ASSUME_NONNULL_END

@end
