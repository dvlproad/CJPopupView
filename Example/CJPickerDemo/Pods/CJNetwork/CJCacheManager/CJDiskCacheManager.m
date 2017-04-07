//
//  CJDiskCacheManager.m
//  SDWebData
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJDiskCacheManager.h"

@implementation CJDiskCacheManager

+ (CJDiskCacheManager *)sharedCacheManager {
    static CJDiskCacheManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

/**
 *  保存文件
 *
 *  @param data                     要保存的数据
 *  @param name                     名字
 *  @param relativeDirectoryPath    保存到的文件的相对目录
 *
 *  return  是否保存成功
 */
- (BOOL)saveData:(NSData *)data withName:(NSString *)name toRelativeDirectoryPath:(NSString *)relativeDirectoryPath
{
    NSAssert(data && name && relativeDirectoryPath, @"要缓存到磁盘的数据、地址等都不能为空");
    
    NSString *absoluteDirectoryPath = [NSHomeDirectory() stringByAppendingPathComponent:relativeDirectoryPath];
    NSString *absoluteFilePath = [absoluteDirectoryPath stringByAppendingPathComponent:name];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:absoluteDirectoryPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:absoluteDirectoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:absoluteFilePath contents:data attributes:nil];
}

@end
