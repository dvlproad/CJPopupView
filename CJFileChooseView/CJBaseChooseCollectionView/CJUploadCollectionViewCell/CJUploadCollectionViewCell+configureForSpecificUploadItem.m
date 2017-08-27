//
//  CJUploadCollectionViewCell+configureForSpecificUploadItem.m
//  ijinbu
//
//  Created by 李超前 on 2017/1/19.
//  Copyright © 2017年 haixiaedu. All rights reserved.
//

#import "CJUploadCollectionViewCell+configureForSpecificUploadItem.h"
//#import "NetworkClient+CJUploadFile.h"
#import "IjinbuNetworkClient+UploadFile.h"
#import "IjinbuHTTPSessionManager.h"

#import "IjinbuUploadItemResult.h"

@implementation CJUploadCollectionViewCell (configureForSpecificUploadItem)

- (void)configureForImageUploadItem:(CJImageUploadItem *)imageUploadItem
                   andUploadToWhere:(NSInteger)toWhere
                       requestBlock:(void(^)(CJBaseUploadItem *item))requestBlock
{
//    NSURLSessionDataTask * (^createUploadRequest)(AFHTTPSessionManager *manager, NSString *UploadUrl, NSDictionary *parameters, NSArray<CJUploadItemModel *> *uploadItems, CJBaseUploadItem *saveUploadInfoToItem, void(^)(CJBaseUploadItem *itemThatSaveResopnse)requestChangeBlock, CJUploadInfo * (^)(id responseObject)dealResopnseForUploadInfoBlock)
    

    NSArray<CJUploadItemModel *> *uploadItemModels = imageUploadItem.uploadItems;
    [self uploadItems:uploadItemModels
              toWhere:toWhere
   uploadInfoSaveInItem:imageUploadItem
         uploadInfoChangeBlock:requestBlock];
    
    if (imageUploadItem.image) {
        self.cjImageView.image  = imageUploadItem.image;
    }else{
//        HPResponseEntity *responseModel = imageUploadItem.responseModel;
//        NSArray<IjinbuUploadItemResult *> *result = [MTLJSONAdapter modelsOfClass:[IjinbuUploadItemResult class] fromJSONArray:responseModel.result error:nil];
//        
//        IjinbuUploadItemResult *imageUploadResult = [result firstObject];
//        NSURL *imageURL = [NSURL URLWithString:imageUploadResult.networkUrl];
//        [self.cjImageView sd_setImageWithURL:imageURL];
    }
}





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
    
    [self cj_UseManager:manager postUploadUrl:Url parameters:parameters uploadItems:uploadItems uploadInfoSaveInItem:imageItem uploadInfoChangeBlock:uploadInfoChangeBlock dealResopnseForUploadInfoBlock:^CJUploadInfo *(id responseObject) {
        
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
        
    }];
}


/**
 *  视图的上传文件操作（uploadInfo：上传请求的各个时刻信息）
 *
 *  @param manager      manager
 *  @param Url          Url
 *  @param parameters   parameters
 *  @param uploadItems  要上传的数据组uploadItems
 *  @param saveUploadInfoToItem     上传请求的各个时刻信息(正在上传、上传完成)的保存位置
 *  @param uploadInfoChangeBlock    上传请求的时刻信息变化后(正在上传、上传完成都会导致其变化)要执行的操作
 *  @param dealResopnseForUploadInfoBlock   上传结束后从response中获取上传请求的该时刻信息(正在上传的时刻系统可自动获取)
 */
- (void)cj_UseManager:(AFHTTPSessionManager *)manager
        postUploadUrl:(NSString *)Url
           parameters:(id)parameters
          uploadItems:(NSArray<CJUploadItemModel *> *)uploadItems
 uploadInfoSaveInItem:(CJBaseUploadItem *)saveUploadInfoToItem
uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *saveUploadInfoToItem))uploadInfoChangeBlock
dealResopnseForUploadInfoBlock:(CJUploadInfo * (^)(id responseObject))dealResopnseForUploadInfoBlock
{
    
    NSURLSessionDataTask *operation = saveUploadInfoToItem.operation;
    if (operation == nil) {
        operation = [IjinbuNetworkClient cj_UseManager:manager postUploadUrl:Url parameters:parameters uploadItems:uploadItems uploadInfoSaveInItem:saveUploadInfoToItem uploadInfoChangeBlock:uploadInfoChangeBlock dealResopnseForUploadInfoBlock:dealResopnseForUploadInfoBlock];
        
        saveUploadInfoToItem.operation = operation;
    }
    
    
    //cjReUploadHandle
    __weak typeof(saveUploadInfoToItem)weakItem = saveUploadInfoToItem;
    [self.uploadProgressView setCjReUploadHandle:^(UIView *uploadProgressView) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        [strongItem.operation cancel];
        
        NSURLSessionDataTask *newOperation = [IjinbuNetworkClient cj_UseManager:manager postUploadUrl:Url parameters:parameters uploadItems:uploadItems uploadInfoSaveInItem:saveUploadInfoToItem uploadInfoChangeBlock:uploadInfoChangeBlock dealResopnseForUploadInfoBlock:dealResopnseForUploadInfoBlock];
        
        strongItem.operation = newOperation;
    }];
    
    
    CJUploadInfo *uploadInfo = saveUploadInfoToItem.uploadInfo;
    [self.uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];//调用此方法避免reload时候显示错误
}

//- (CJUploadInfo *)createFailureUploadInfo {
//    CJUploadInfo *uploadInfo = [[CJUploadInfo alloc] init];
//    if (uploadSuccess) {
//        uploadInfo.uploadState = CJUploadStateSuccess;
//        uploadInfo.responseModel = 
//    } else {
//        uploadInfo.uploadState = CJUploadStateFailure;
//    }
//    ;
//    uploadSuccess
//    
//    return uploadInfo;
//}

@end
