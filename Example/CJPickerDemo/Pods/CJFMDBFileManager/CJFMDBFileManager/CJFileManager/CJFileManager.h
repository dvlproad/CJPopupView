//
//  CJFileManager.h
//  CommonFMDBUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CJFileSizeUnitType) {
    CJFileSizeUnitTypeBestUnit,
    CJFileSizeUnitTypeB,
    CJFileSizeUnitTypeKB,
    CJFileSizeUnitTypeMB,
    CJFileSizeUnitTypeGB
};

typedef NS_ENUM(NSUInteger, CJLocalPathType) {
    CJLocalPathTypeAbsolute,    /**< 绝对路径 */
    CJLocalPathTypeRelative,    /**< 相对于Home的路径 */
};

@interface CJFileManager : NSObject

#pragma mark - 文件夹操作
/**
 *  删除searchPathDirectory文件夹下子文件夹
 *
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *
 *  return 是否删除成功
 */
+ (BOOL)deleteDirectoryBySubDirectoryPath:(NSString *)subDirectoryPath
                    inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;

/**
 *  获取searchPathDirectory文件夹下子文件夹的路径
 *
 *  @param localPathType        返回什么样的路径(绝对路径还是相对路径)
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *  @param createIfNoExist      createIfNoExist（文件夹不存在的时候是否创建）
 *
 *  return 文件夹的路径(绝对路径或者相对于home的路径)
 */
+ (NSString *)getLocalDirectoryPathType:(CJLocalPathType)localPathType
                     bySubDirectoryPath:(NSString *)subDirectoryPath
                  inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory
                        createIfNoExist:(BOOL)createIfNoExist;


#pragma mark - 文件操作
/**
 *  删除searchPathDirectory文件夹下子文件夹中的文件
 *
 *  @param fileName             文件名
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *
 *  return 是否删除成功
 */

+ (BOOL)deleteFileWithFileName:(NSString *)fileName
              subDirectoryPath:(NSString *)subDirectoryPath
         inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;


/**
 *  保存文件到searchPathDirectory文件夹下的子文件夹中
 *
 *  @param data                 文件数据
 *  @param fileName             文件以什么名字保存
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *  @param searchPathDirectory  searchPathDirectory
 *
 *  return 文件相对于home目录的相对路径（如果保存失败，返回nil）
 */
+ (NSString *)saveFileData:(NSData *)data
              withFileName:(NSString *)fileName
        inSubDirectoryPath:(NSString *)subDirectoryPath
       searchPathDirectory:(NSSearchPathDirectory)searchPathDirectory;

@end
