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
    CJBaseUploadItem *saveUploadInfoToItem = imageItem;
    
    NSURLSessionDataTask *(^createDetailedUploadRequestBlock)(void) = [IjinbuNetworkClient createDetailedUploadRequestBlockByRequestUploadItems:uploadModels toWhere:toWhere andsaveUploadInfoToItem:imageItem uploadInfoChangeBlock:uploadInfoChangeBlock];
    
    NSURLSessionDataTask *operation = saveUploadInfoToItem.operation;
    if (operation == nil) {
        operation = createDetailedUploadRequestBlock();
        
        saveUploadInfoToItem.operation = operation;
    }
    
    
    //cjReUploadHandle
    __weak typeof(saveUploadInfoToItem)weakItem = saveUploadInfoToItem;
    [self.uploadProgressView setCjReUploadHandle:^(UIView *uploadProgressView) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        [strongItem.operation cancel];
        
        NSURLSessionDataTask *newOperation = nil;
        newOperation = createDetailedUploadRequestBlock();
        
        strongItem.operation = newOperation;
    }];
    
    
    CJUploadInfo *uploadInfo = saveUploadInfoToItem.uploadInfo;
    [self.uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];//调用此方法避免reload时候显示错误
}




@end
