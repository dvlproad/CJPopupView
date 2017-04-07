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

@implementation CJUploadCollectionViewCell (configureForSpecificUploadItem)

- (void)configureForImageUploadItem:(CJImageUploadItem *)imageUploadItem
                   andUploadToWhere:(NSInteger)toWhere
                       requestBlock:(void(^)(CJImageUploadItem *item))requestBlock
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
    [self setCjReUploadHandle:^(CJUploadCollectionViewCell *cell) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        [strongItem.operation cancel];
        
        NSURLSessionDataTask *newOperation = [weakSelf uploadItems:imageUploadItem.uploadItems
                                                             toWhere:toWhere
                                                  andSetResultToItem:imageUploadItem
                                                        requestBlock:requestBlock];
        
        strongItem.operation = newOperation;
    }];
    
    
    [self updateProgressText:imageUploadItem.uploadStatePromptText progressVaule:imageUploadItem.progressValue];//调用此方法避免reload时候显示错误
    
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
                           requestBlock:(void(^)(CJImageUploadItem *item))requestBlock
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(imageItem)weakItem = imageItem;
    
    NSURLSessionDataTask *operation =
    [[IjinbuNetworkClient sharedInstance] requestUploadItems:uploadModels toWhere:toWhere progress:^(NSProgress *progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            __strong __typeof(weakItem)strongItem = weakItem;
            
            CGFloat progressValue = progress.fractionCompleted * 100;
            
            strongItem.uploadState = CJUploadStateUploading;
            strongItem.uploadStatePromptText = [NSString stringWithFormat:@"%.0lf%%", progressValue];;
            strongItem.progressValue = progressValue;
            
            if (requestBlock) {
                requestBlock(strongItem);
            }
        });
        
    } success:^(IjinbuResponseModel *responseModel) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        strongItem.responseModel = responseModel;
        
        if ([responseModel.status integerValue] == 1) {
            NSArray *operationUploadResult = [MTLJSONAdapter modelsOfClass:[IjinbuUploadItemResult class] fromJSONArray:responseModel.result error:nil];
            
            if (operationUploadResult == nil || operationUploadResult.count == 0) {
                strongItem.uploadState = CJUploadStateFailure;
                
                NSString *promptText = [NSString stringWithFormat:@"点击重传"];
                strongItem.uploadStatePromptText = promptText;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (requestBlock) {
                        requestBlock(strongItem);
                    }
                });
                
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
                    strongItem.uploadState = CJUploadStateFailure;
                    
                    NSString *promptText = [NSString stringWithFormat:@"点击重传"];
                    strongItem.uploadStatePromptText = promptText;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (requestBlock) {
                            requestBlock(strongItem);
                        }
                    });
                } else {
                    strongItem.uploadState = CJUploadStateSuccess;
                    
                    NSString *promptText = [NSString stringWithFormat:@"上传成功"];
                    strongItem.uploadStatePromptText = promptText;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (requestBlock) {
                            requestBlock(strongItem);
                        }
                    });
                }
            }
            
        } else if ([responseModel.status integerValue] == 2) {
            strongItem.uploadState = CJUploadStateFailure;
            
            NSString *failureMessage = responseModel.message;
            NSString *promptText = [NSString stringWithFormat:@"%@", failureMessage];
            strongItem.uploadStatePromptText = promptText;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (requestBlock) {
                    requestBlock(strongItem);
                }
            });
            
            return;
            
        } else {
            strongItem.uploadState = CJUploadStateFailure;
            
            //NSString *failureMessage = responseModel.msg;
            NSString *promptText = [NSString stringWithFormat:@"点击重传"];
            strongItem.uploadStatePromptText = promptText;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (requestBlock) {
                    requestBlock(strongItem);
                }
            });
            
            return;
        }
        
        
    } failure:^(NSError *error) {
        __strong __typeof(weakItem)strongItem = weakItem;
        
        strongItem.uploadState = CJUploadStateFailure;
        
        NSString *promptText = [NSString stringWithFormat:@"点击重传"];
        strongItem.uploadStatePromptText = promptText;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (requestBlock) {
                requestBlock(strongItem);
            }
        });
        
        NSLog(@"error: %@", [error localizedDescription]);
        
    }];
    
    return operation;
    //*/
    return nil;
}

@end
