//
//  CJCacheDataModel.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2017/3/9.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJCacheDataModel : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cacheToRelativeDirectoryPath; /**< 相对路径 */

@end
