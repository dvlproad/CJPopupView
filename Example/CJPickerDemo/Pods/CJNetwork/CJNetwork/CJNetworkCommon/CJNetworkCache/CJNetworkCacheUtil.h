//
//  CJNetworkCacheUtil.h
//  CJNetworkDemo
//
//  Created by ciyouzen on 2017/3/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, CJRequestCacheFailureType) {
//    CJRequestCacheFailureTypeCacheKeyNil,            /**< cacheKey == nil */
//    CJRequestCacheFailureTypeCacheDataNil,           /**< 未读到缓存数据,如第一次就是无网请求,提示网络不给力 */
//};


@interface CJNetworkCacheUtil : NSObject

/**
 *  缓存网络请求的数据
 *
 *  @param responseObject       要缓存的数据
 *  @param Url                  Url
 *  @param params               params
 *  @param cacheTimeInterval    cacheTimeInterval
 */
+ (void)cacheResponseObject:(nullable id)responseObject
                     forUrl:(nullable NSString *)Url
                     params:(nullable NSDictionary *)params
          cacheTimeInterval:(NSTimeInterval)cacheTimeInterval;

/**
 *  获取请求的缓存数据
 *
 *  @param Url          Url
 *  @param params       params
 *
 *  return 获取到缓存数据
 */
+ (id<NSCoding>)requestCacheDataByUrl:(nullable NSString *)Url params:(nullable id)params;


/**
 *  删除指定key的缓存数据
 *
 *  @param Url          Url
 *  @param params       params
 *
 *  return  是否删除成功
 */
+ (BOOL)removeCacheForUrl:(nullable NSString *)Url params:(nullable id)params;

/**
 *  清空所有缓存数据
 */
+ (void)clearAllCache;

@end
