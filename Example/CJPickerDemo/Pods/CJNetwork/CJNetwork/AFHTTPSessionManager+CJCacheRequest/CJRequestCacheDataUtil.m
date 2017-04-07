//
//  CJRequestCacheDataUtil.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/29.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "CJRequestCacheDataUtil.h"

#import "CJMemoryDiskCacheManager.h"

#import "NSDictionary+Convert.h"
#import "NSData+Convert.h"
#import "NSString+MD5.h"

static NSString *relativeDirectoryPath = @"CJNetworkCache";

@implementation CJRequestCacheDataUtil

/** 完整的描述请参见文件头部 */
+ (void)cacheNetworkData:(nullable id)responseObject
            byRequestUrl:(nullable NSString *)Url
              parameters:(nullable NSDictionary *)parameters
{
    NSString *requestCacheKey = [self getRequestCacheKeyByRequestUrl:Url parameters:parameters];
    if (nil == requestCacheKey) {
        NSLog(@"error: cacheKey == nil, 无法进行缓存");
        
    }else{
        if (!responseObject){
            [[CJMemoryDiskCacheManager sharedInstance] removeCacheForCacheKey:requestCacheKey diskRelativeDirectoryPath:relativeDirectoryPath];
            
            
        } else {
            //TODO:responseObject(json) 转data
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            NSData *cacheData = [dic convertToData];
            
            [[CJMemoryDiskCacheManager sharedInstance] cacheData:cacheData forCacheKey:requestCacheKey andSaveInDisk:YES withDiskRelativeDirectoryPath:relativeDirectoryPath];
        }
    }
}

/** 完整的描述请参见文件头部 */
+ (BOOL)requestNetworkDataFromCache:(BOOL)fromRequestCacheData
                       byRequestUrl:(nullable NSString *)Url
                         parameters:(nullable NSDictionary *)parameters
                            success:(nullable CJRequestCacheSuccess)success
                            failure:(nullable CJRequestCacheFailure)failure
{
    NSURLSessionDataTask *task = nil;
    
    if (fromRequestCacheData == NO) {
        NSLog(@"提示：这里之前未缓存，无法读取缓存，提示网络不给力");
        //[self hud_showNoNetwork];
        
        if (failure) {
            NSString *errorMessage = NSLocalizedString(@"网络不给力", nil);
            NSError *error = [self networkErrorWithLocalizedDescription:errorMessage];
            failure(task, error, fromRequestCacheData);
        }
        return NO;
    }
    
    NSString *requestCacheKey = [self getRequestCacheKeyByRequestUrl:Url parameters:parameters];
    if (nil == requestCacheKey) {
        NSLog(@"error: cacheKey == nil, 无法读取缓存，提示网络不给力");
        //[self hud_showNoNetwork];
        
        if (failure) {
            NSString *errorMessage = NSLocalizedString(@"网络不给力", nil);
            NSError *error = [self networkErrorWithLocalizedDescription:errorMessage];
            failure(task, error, fromRequestCacheData);
        }
        return NO;
    }
    
    
    
    NSData *requestCacheData = [[CJMemoryDiskCacheManager sharedInstance] getCacheDataByCacheKey:requestCacheKey diskRelativeDirectoryPath:relativeDirectoryPath];
    if (requestCacheData) {
        //NSLog(@"读到缓存数据，但不保证该数据是最新的，因为网络还是不给力");
        
        if (success) {
            NSDictionary *responseObject = [requestCacheData convertToDictionary];
            success(task, responseObject, fromRequestCacheData);
        }
        return YES;
        
    } else {
        NSLog(@"未读到缓存数据，提示网络不给力");
        //[self hud_showNoNetwork];
        
        if (failure) {
            NSString *errorMessage = NSLocalizedString(@"网络不给力", nil);
            NSError *error = [self networkErrorWithLocalizedDescription:errorMessage];
            failure(task, error, fromRequestCacheData);
        }
        return NO;
    }
}

/**
 *  获取请求的缓存key
 *
 *  @param Url          Url
 *  @param parameters   parameters
 *
 *  return 请求的缓存key
 */
+ (NSString *)getRequestCacheKeyByRequestUrl:(NSString *)Url
                                  parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary addEntriesFromDictionary:parameters];
    [mutableDictionary setObject:Url forKey:@"cjRequestUrl"];
    
    NSString *string = [mutableDictionary convertToString];
    NSString *requestCacheKey = [string MD5];
    
    return requestCacheKey;
}


/** 网络不给力时候，默认返回的error */
+ (NSError *)networkErrorWithLocalizedDescription:(NSString *)localizedDescription {
    //NSString *localizedDescription = NSLocalizedString(@"网络不给力", nil);
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:localizedDescription forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [[NSError alloc] initWithDomain:@"com.dvlproad.network.error" code:-1 userInfo:userInfo];
    
    return error;
}


@end
