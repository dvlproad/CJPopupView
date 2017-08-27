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
 *  上传文件请求（uploadInfo：上传请求的各个时刻信息）
 *
 *  @param manager      manager
 *  @param Url          Url
 *  @param parameters   parameters
 *  @param uploadItems  要上传的数据组uploadItems
 *  @param saveUploadInfoToItem     上传请求的各个时刻信息(正在上传、上传完成)的保存位置
 *  @param uploadInfoChangeBlock    上传请求的时刻信息变化后(正在上传、上传完成都会导致其变化)要执行的操作
 *  @param dealResopnseForUploadInfoBlock   上传结束后从response中获取上传请求的该时刻信息(正在上传的时刻系统可自动获取)
 *
 *  @return 上传文件的请求
 */
+ (NSURLSessionDataTask *)cj_UseManager:(AFHTTPSessionManager *)manager
                          postUploadUrl:(NSString *)Url
                             parameters:(id)parameters
                            uploadItems:(NSArray<CJUploadItemModel *> *)uploadItems
                   uploadInfoSaveInItem:(CJBaseUploadItem *)saveUploadInfoToItem
                  uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *saveUploadInfoToItem))uploadInfoChangeBlock
         dealResopnseForUploadInfoBlock:(CJUploadInfo * (^)(id responseObject))dealResopnseForUploadInfoBlock;
@end
