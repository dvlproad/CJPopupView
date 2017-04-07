//
//  CJFileManager+CalculateFileSize.h
//  CommonFMDBUtilDemo
//
//  Created by 李超前 on 2017/1/5.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "CJFileManager.h"

@interface CJFileManager (CalculateFileSize)

/**
 *  计算对应路径下的文件/文件夹大小(计算出来的单位为B)
 *
 *  @param filePath    要计算大小的文件/文件夹路径
 */
+ (NSInteger)calculateFileSizeForFilePath:(NSString *)filePath;

/**
 *  采用什么单位来表示fileSize
 *
 *  @param fileSize         fileSize当前是以B为单位的
 *  @param fileSizeUnitType fileSize要采用的单位
 */
+ (NSString *)showFileSize:(NSInteger)fileSize unitType:(CJFileSizeUnitType)fileSizeUnitType;

@end
