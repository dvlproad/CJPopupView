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

@implementation CJUploadCollectionViewCell (configureForSpecificUploadItem)

- (void)configureForImageUploadItem:(CJImageUploadItem *)imageUploadItem
                   andUploadToWhere:(NSInteger)toWhere
                       requestBlock:(void(^)(CJBaseUploadItem *item))requestBlock
{
    NSURLSessionDataTask *operation = imageUploadItem.operation;
    if (operation == nil) {
        NSArray<CJUploadItemModel *> *uploadItemModels = imageUploadItem.uploadItems;
        operation = [self uploadItems:uploadItemModels
                              toWhere:toWhere
                   andSetResultToItem:imageUploadItem
                         requestBlock:requestBlock];
        
        imageUploadItem.operation = operation;
    }
    
    
    //cjReUploadHandle
    __weak typeof(self)weakSelf = self;
    __weak typeof(imageUploadItem)weakItem = imageUploadItem;
    [self.uploadProgressView setCjReUploadHandle:^(UIView *uploadProgressView) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        [strongItem.operation cancel];
        
        NSURLSessionDataTask *newOperation = [weakSelf uploadItems:imageUploadItem.uploadItems
                                                           toWhere:toWhere
                                                andSetResultToItem:imageUploadItem
                                                      requestBlock:requestBlock];
        
        strongItem.operation = newOperation;
    }];
    
    
    CJUploadInfo *uploadInfo = imageUploadItem.uploadInfo;
    [self.uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];//调用此方法避免reload时候显示错误
    
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
- (NSURLSessionDataTask *)uploadItems:(NSArray<CJUploadItemModel *> *)uploadModels
                                toWhere:(NSInteger)toWhere
                     andSetResultToItem:(CJImageUploadItem *)imageItem
                           requestBlock:(void(^)(CJBaseUploadItem *item))requestBlock
{
    AFHTTPSessionManager *manager = [IjinbuHTTPSessionManager sharedInstance];
    
    NSString *Url = API_BASE_Url_ijinbu(@"ijinbu/app/public/batchUpload");
    NSDictionary *parameters = @{@"uploadType": @(toWhere)};
    NSArray<CJUploadItemModel *> *uploadItems = uploadModels;
    NSLog(@"Url = %@", Url);
    NSLog(@"params = %@", parameters);
    
    return [IjinbuNetworkClient cj_UseManager:manager postUploadUrl:Url parameters:parameters uploadItems:uploadItems andSaveUploadInfoToItem:imageItem requestChangeBlock:requestBlock dealResopnseForUploadInfoBlock:^CJUploadInfo *(id responseObject) {
        
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
