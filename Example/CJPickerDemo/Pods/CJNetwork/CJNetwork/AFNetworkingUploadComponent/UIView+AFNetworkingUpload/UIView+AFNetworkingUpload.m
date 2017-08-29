//
//  UIView+AFNetworkingUpload.m
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2017/8/27.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "UIView+AFNetworkingUpload.h"

@implementation UIView (AFNetworkingUpload)

/* 完整的描述请参见文件头部 */
- (void)configureUploadRequestForItem:(CJBaseUploadItem *)saveUploadInfoToItem
        andUseUploadInfoConfigureView:(CJUploadProgressView *)uploadProgressView
      uploadRequestConfigureByManager:(AFHTTPSessionManager *)manager
                                  Url:(NSString *)Url
                           parameters:(id)parameters
                          uploadItems:(NSArray<CJUploadItemModel *> *)uploadItems
                uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *saveUploadInfoToItem))uploadInfoChangeBlock
       dealResopnseForUploadInfoBlock:(CJUploadInfo * (^)(id responseObject))dealResopnseForUploadInfoBlock
{
//    CJDetailedUploadRequestBlock createDetailedUploadRequestBlock = ^(AFHTTPSessionManager *manager, NSString *postUploadUrl, id parameters, NSArray<CJUploadItemModel *> *uploadItems, CJBaseUploadItem *uploadInfoSaveInItem, void(^uploadInfoChangeBlock)(CJBaseUploadItem *saveUploadInfoToItem), CJUploadInfo * (^dealResopnseForUploadInfoBlock)(id responseObject))
    NSURLSessionDataTask *(^createDetailedUploadRequestBlock)(void) = ^(void) //TOContinue:
    {
        NSURLSessionDataTask *operation =
        [AFNetworkingUploadUtil cj_UseManager:manager
                                postUploadUrl:Url
                                   parameters:parameters
                                  uploadItems:uploadItems
                         uploadInfoSaveInItem:saveUploadInfoToItem
                        uploadInfoChangeBlock:uploadInfoChangeBlock
               dealResopnseForUploadInfoBlock:dealResopnseForUploadInfoBlock];
        
        return operation;
    };
    
    NSURLSessionDataTask *operation = saveUploadInfoToItem.operation;
    if (operation == nil) {
        operation = createDetailedUploadRequestBlock(manager,
                                                     Url,
                                                     parameters,
                                                     uploadItems,
                                                     saveUploadInfoToItem,
                                                     uploadInfoChangeBlock,
                                                     dealResopnseForUploadInfoBlock);
        
        saveUploadInfoToItem.operation = operation;
    }
    
    
    //cjReUploadHandle
    __weak typeof(saveUploadInfoToItem)weakItem = saveUploadInfoToItem;
    [uploadProgressView setCjReUploadHandle:^(UIView *uploadProgressView) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        [strongItem.operation cancel];
        
        NSURLSessionDataTask *newOperation = nil;
        newOperation = createDetailedUploadRequestBlock(manager,
                                                        Url,
                                                        parameters,
                                                        uploadItems,
                                                        saveUploadInfoToItem,
                                                        uploadInfoChangeBlock,
                                                        dealResopnseForUploadInfoBlock);
        
        strongItem.operation = newOperation;
    }];
    
    
    CJUploadInfo *uploadInfo = saveUploadInfoToItem.uploadInfo;
    [uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];//调用此方法避免reload时候显示错误
}


@end
