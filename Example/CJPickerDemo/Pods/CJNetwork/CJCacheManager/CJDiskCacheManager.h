//
//  CJDiskCacheManager.h
//  SDWebData
//
//  Created by lichq on 7/31/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CJDiskCacheManager : NSObject
{

}

+ (CJDiskCacheManager *)sharedCacheManager;

/**
 *  保存文件
 *
 *  @param data                     要保存的数据
 *  @param name                     名字
 *  @param relativeDirectoryPath    保存到的文件的相对目录
 *
 *  return  是否保存成功
 */
- (BOOL)saveData:(NSData *)data withName:(NSString *)name toRelativeDirectoryPath:(NSString *)relativeDirectoryPath;


@end



