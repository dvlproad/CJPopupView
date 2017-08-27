//
//  AFNetworkingUploadUtil.h
//  CommonAFNUtilDemo
//
//  Created by ciyouzen on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+CJUploadFile.h"   //上传请求的接口

#import "CJBaseUploadItem.h"    //上传请求的时刻信息要保存到的位置

#import "CJUploadItemModel.h"   //要上传的数据模型
#import "CJUploadInfo.h"        //上传请求的时刻信息（已包括 CJUploadState 和 CJResponseModel）

@interface AFNetworkingUploadUtil : NSObject

#pragma mark - 上传文件请求的接口
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
