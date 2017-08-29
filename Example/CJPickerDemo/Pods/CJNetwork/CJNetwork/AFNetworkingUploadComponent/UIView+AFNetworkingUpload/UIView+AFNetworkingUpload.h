//
//  UIView+AFNetworkingUpload.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2017/8/27.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworkingUploadUtil.h"
#import "CJUploadProgressView.h"

//typedef int (^Sum) (int,  int);

///创建包含会将上传过程中的各个时刻信息返回给制定item的请求
typedef NSURLSessionDataTask * (^CJDetailedUploadRequestBlock) (AFHTTPSessionManager *manager, NSString *postUploadUrl, id parameters, NSArray<CJUploadItemModel *> *uploadItems, CJBaseUploadItem *uploadInfoSaveInItem, void(^uploadInfoChangeBlock)(CJBaseUploadItem *saveUploadInfoToItem), CJUploadInfo * (^dealResopnseForUploadInfoBlock)(id responseObject));

///从请求结果response中获取uploadInfo的代码块
typedef CJUploadInfo * (^CJDealResopnseForUploadInfoBlock)(id responseObject);

@interface UIView (AFNetworkingUpload)

#pragma mark - TODO:有上传操作的那个视图要重写的方法
/**
 *  给item设置上传请求，并将上传请求的各个时刻信息uploadInfo①保存到该item上，②同时利用这些uploadInfo设置uploadProgressView
 *
 *  @param saveUploadInfoToItem     上传请求的各个时刻信息(正在上传、上传完成)的保存位置
 *  @param uploadProgressView       上传请求的各个时刻信息(正在上传、上传完成)要用来设置的视图
 *  @param manager      manager
 *  @param Url          Url
 *  @param parameters   parameters
 *  @param uploadItems  要上传的数据组uploadItems
 *  @param uploadInfoChangeBlock    上传请求的时刻信息变化后(正在上传、上传完成都会导致其变化)要执行的操作
 *  @param dealResopnseForUploadInfoBlock   上传结束后从response中获取上传请求的该时刻信息(正在上传的时刻系统可自动获取)
 */
- (void)configureUploadRequestForItem:(CJBaseUploadItem *)saveUploadInfoToItem
        andUseUploadInfoConfigureView:(CJUploadProgressView *)uploadProgressView
      uploadRequestConfigureByManager:(AFHTTPSessionManager *)manager
                                  Url:(NSString *)Url
                           parameters:(id)parameters
                          uploadItems:(NSArray<CJUploadItemModel *> *)uploadItems
                uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *saveUploadInfoToItem))uploadInfoChangeBlock
       dealResopnseForUploadInfoBlock:(CJUploadInfo * (^)(id responseObject))dealResopnseForUploadInfoBlock;

@end
