//
//  AFHTTPSessionManager+CJCacheRequest.h
//  CommonAFNUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJNetworkMonitor.h"
#import "CJNetworkDefine.h"

#import "CJRequestCacheDataUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface AFHTTPSessionManager (CJCategory)

/**
 *  POST请求
 *
 *  @param Url              Url
 *  @param parameters       parameters
 *  @param uploadProgress   uploadProgress
 *  @param success          success
 *  @param failure          failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postRequestUrl:(nullable NSString *)Url
                                 parameters:(nullable id)parameters
                                   progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                    success:(nullable AFRequestSuccess)success
                                    failure:(nullable AFRequestFailure)failure;

/**
 *  POST请求
 *
 *  @param Url              Url
 *  @param parameters       parameters
 *  @param cacheReuqestData 是否缓存网络数据(如果有缓存，而也即代表可以从缓存中获取数据)
 *  @param uploadProgress   uploadProgress
 *  @param success          success
 *  @param failure          failure
 *
 *  return NSURLSessionDataTask
 */
- (nullable NSURLSessionDataTask *)cj_postRequestUrl:(nullable NSString *)Url
                                          parameters:(nullable id)parameters
                                    cacheReuqestData:(BOOL)cacheReuqestData
                                            progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                             success:(nullable CJRequestCacheSuccess)success
                                             failure:(nullable CJRequestCacheFailure)failure;

@end
