//
//  CJFMDBFileDeleteResult.h
//  CommonFMDBUtilDemo
//
//  Created by lichq on 2016/1/4.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJFMDBFileDeleteResult : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *deleteFileName;
@property (nonatomic, copy) NSString *deleteFileInDirectoryName;

@end
