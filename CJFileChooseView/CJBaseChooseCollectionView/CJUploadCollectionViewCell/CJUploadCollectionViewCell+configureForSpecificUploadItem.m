//
//  CJUploadCollectionViewCell+configureForSpecificUploadItem.m
//  ijinbu
//
//  Created by 李超前 on 2017/1/19.
//  Copyright © 2017年 haixiaedu. All rights reserved.
//

#import "CJUploadCollectionViewCell+configureForSpecificUploadItem.h"
#import <CJNetwork/UIView+AFNetworkingUpload.h>

#import "IjinbuNetworkClient+UploadFile.h"
#import "IjinbuHTTPSessionManager.h"

#import "IjinbuUploadItemResult.h"

#import <CJNetwork/AFNetworkingUploadUtil.h>
#import <CJNetwork/CJBaseUploadItem.h>

@implementation CJUploadCollectionViewCell (configureForSpecificUploadItem)

/**< 上传图片到服务器 */
- (void)uploadItems:(NSArray<CJUploadItemModel *> *)uploadModels
                                toWhere:(NSInteger)toWhere
                    uploadInfoSaveInItem:(CJImageUploadItem *)imageItem
                    uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *item))uploadInfoChangeBlock
{
    AFHTTPSessionManager *manager = [IjinbuHTTPSessionManager sharedInstance];
    
    NSString *Url = API_BASE_Url_ijinbu(@"ijinbu/app/public/batchUpload");
    NSDictionary *parameters = @{@"uploadType": @(toWhere)};
    NSArray<CJUploadItemModel *> *uploadItems = uploadModels;
    NSLog(@"Url = %@", Url);
    NSLog(@"params = %@", parameters);
    
    /* 从请求结果response中获取uploadInfo的代码块 */
    CJDealResopnseForUploadInfoBlock dealResopnseForUploadInfoBlock = ^CJUploadInfo *(id responseObject)
    {
        IjinbuResponseModel *responseModel = [MTLJSONAdapter modelOfClass:[IjinbuResponseModel class] fromJSONDictionary:responseObject error:nil];
        
        CJUploadInfo *uploadInfo = [[CJUploadInfo alloc] init];
        uploadInfo.responseModel = responseModel;
        if ([responseModel.status integerValue] == 1) {
            NSArray *operationUploadResult = [MTLJSONAdapter modelsOfClass:[IjinbuUploadItemResult class] fromJSONArray:responseModel.result error:nil];
            
            if (operationUploadResult == nil || operationUploadResult.count == 0) {
                uploadInfo.uploadState = CJUploadStateFailure;
                uploadInfo.uploadStatePromptText = @"点击重传";
                
            } else {
                BOOL findFailure = NO;
                for (IjinbuUploadItemResult *uploadItemResult in operationUploadResult) {
                    NSString *networkUrl = uploadItemResult.networkUrl;
                    if (networkUrl == nil || [networkUrl length] == 0) {
                        NSLog(@"Failure:文件上传后返回的网络地址为空");
                        findFailure = YES;
                        
                    }
                }
                
                if (findFailure) {
                    uploadInfo.uploadState = CJUploadStateFailure;
                    uploadInfo.uploadStatePromptText = @"点击重传";
                    
                } else {
                    uploadInfo.uploadState = CJUploadStateSuccess;
                    uploadInfo.uploadStatePromptText = @"上传成功";
                }
            }
            
        } else if ([responseModel.status integerValue] == 2) {
            uploadInfo.uploadState = CJUploadStateFailure;
            uploadInfo.uploadStatePromptText = responseModel.message;
            
        } else {
            uploadInfo.uploadState = CJUploadStateFailure;
            uploadInfo.uploadStatePromptText = @"点击重传";
        }
        
        return uploadInfo;
    };
    
    [self configureUploadRequestForItem:imageItem andUseUploadInfoConfigureView:self.uploadProgressView uploadRequestConfigureByManager:manager Url:Url parameters:parameters uploadItems:uploadItems uploadInfoChangeBlock:uploadInfoChangeBlock dealResopnseForUploadInfoBlock:dealResopnseForUploadInfoBlock];
    
    /*
    CJBaseUploadItem *saveUploadInfoToItem = imageItem;
    
    CJDetailedUploadRequestBlock createDetailedUploadRequestBlock = ^(AFHTTPSessionManager *manager, NSString *postUploadUrl, id parameters, NSArray<CJUploadItemModel *> *uploadItems, CJBaseUploadItem *uploadInfoSaveInItem, void (^uploadInfoChangeBlock)(CJBaseUploadItem *saveUploadInfoToItem), CJUploadInfo * (^dealResopnseForUploadInfoBlock)(id responseObject))
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
    [self.uploadProgressView setCjReUploadHandle:^(UIView *uploadProgressView) {
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
    [self.uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];//调用此方法避免reload时候显示错误
    //*/
}

@end
