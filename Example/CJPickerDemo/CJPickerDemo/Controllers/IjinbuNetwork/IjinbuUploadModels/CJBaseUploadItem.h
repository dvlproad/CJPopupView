//
//  CJBaseUploadItem.h
//  FileChooseViewDemo
//
//  Created by lichq on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "IjinbuUploadItemResult.h"
#import "CJUploadItemModel.h"

//#import "UIImage+Helper.h"

#import "CJResponseModel.h"
#import "CJUploadResponseModel.h"


@interface CJBaseUploadItem : NSObject

@property (nonatomic, assign) BOOL isNetworkItem;   /**< (新增)是否是网络文件，如果是则不用进行上传 */

//必填参数
@property (nonatomic, strong) NSMutableArray<CJUploadItemModel *> *uploadItems;

@property (nonatomic, strong) NSURLSessionDataTask *operation;

//过程中参数
@property (nonatomic, assign) NSInteger progressValue;  /**< 当前加载进度[0,100] */

//返回结果
@property (nonatomic, strong) CJResponseModel *responseModel;  /**< 上传成功后后台返回的结果 */
@property (nonatomic, assign) CJUploadState uploadState;
@property (nonatomic, copy) NSString *uploadStatePromptText;

@end
