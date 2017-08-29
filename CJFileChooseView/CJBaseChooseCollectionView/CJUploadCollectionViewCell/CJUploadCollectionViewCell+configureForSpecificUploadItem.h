//
//  CJUploadCollectionViewCell+configureForSpecificUploadItem.h
//  ijinbu
//
//  Created by 李超前 on 2017/1/19.
//  Copyright © 2017年 haixiaedu. All rights reserved.
//

#import "CJUploadCollectionViewCell.h"
#import "CJImageUploadItem.h"

@interface CJUploadCollectionViewCell (configureForSpecificUploadItem)

/**< 上传图片到服务器 */
- (void)uploadItems:(NSArray<CJUploadItemModel *> *)uploadModels
            toWhere:(NSInteger)toWhere
uploadInfoSaveInItem:(CJImageUploadItem *)imageItem
uploadInfoChangeBlock:(void(^)(CJBaseUploadItem *item))uploadInfoChangeBlock;

@end
