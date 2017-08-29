//
//  IjinbuNetworkClient+UploadFile.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/4/5.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "IjinbuNetworkClient.h"
#import "AFHTTPSessionManager+CJUploadFile.h"
#import "IjinbuUploadItemRequest.h"

@interface IjinbuNetworkClient (UploadFile)

/** 多个文件上传 */
- (NSURLSessionDataTask *)requestUploadItems:(NSArray<CJUploadItemModel *> *)uploadItems
                                     toWhere:(NSInteger)uploadItemToWhere
                                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                     success:(HPSuccess)success
                                     failure:(HPFailure)failure;

/** 单个文件上传1 */
- (NSURLSessionDataTask *)requestUploadLocalItem:(NSString *)localRelativePath
                                        itemType:(CJUploadItemType)uploadItemType
                                         toWhere:(NSInteger)uploadItemToWhere
                                         success:(HPSuccess)success
                                         failure:(HPFailure)failure;

/** 单个文件上传2 */
- (NSURLSessionDataTask *)requestUploadItemData:(NSData *)data
                                       itemName:(NSString *)fileName
                                       itemType:(CJUploadItemType)uploadItemType
                                        toWhere:(NSInteger)uploadItemToWhere
                                        success:(HPSuccess)success
                                        failure:(HPFailure)failure;

/** 上传文件 */
- (NSURLSessionDataTask *)requestUploadFile:(IjinbuUploadItemRequest *)request
                                   progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                    success:(HPSuccess)success
                                    failure:(HPFailure)failure;


/**
 *  创建上传文件到服务器的方法的代码块：给item设置上传请求，并将上传请求的各个时刻信息uploadInfo①保存到该item上，②同时利用这些uploadInfo设置uploadProgressView
 *
 *  @param saveUploadInfoToItem     上传请求的各个时刻信息(正在上传、上传完成)的保存位置
 *  @param uploadItems              要上传的数据组uploadItems
 *  @param toWhere                  上传请求需要的参数
 *  @param uploadInfoChangeBlock    上传请求的时刻信息变化后(正在上传、上传完成都会导致其变化)要执行的操作
 *
 *  @return 返回上传文件到服务器的方法的代码块
 */
+ (NSURLSessionDataTask *(^)(void))createDetailedUploadRequestBlockByRequestUploadItems:(NSArray<CJUploadItemModel *> *)uploadItems toWhere:(NSInteger)toWhere andsaveUploadInfoToItem:(CJBaseUploadItem *)saveUploadInfoToItem uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *item))uploadInfoChangeBlock;


@end
