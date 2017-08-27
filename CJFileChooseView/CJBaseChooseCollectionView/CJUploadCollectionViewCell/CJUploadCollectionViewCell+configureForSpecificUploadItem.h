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

- (void)configureForImageUploadItem:(CJImageUploadItem *)imageUploadItem
                   andUploadToWhere:(NSInteger)toWhere
                       requestBlock:(void(^)(CJBaseUploadItem *item))requestBlock;

@end
