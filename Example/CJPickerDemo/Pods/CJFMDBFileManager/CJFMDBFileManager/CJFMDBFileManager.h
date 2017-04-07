//
//  CJFMDBFileManager.h
//  CommonFMDBUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJFileManager.h"
#import "CJFMDBFileDeleteResult.h"

typedef NS_ENUM(NSUInteger, CJFMDBFileExistActionType) {
    CJFMDBFileExistActionTypeShowError,
    CJFMDBFileExistActionTypeUseOld,
    CJFMDBFileExistActionTypeRerecertIt,
};

/**
 *  数据库文件管理类（每个数据库的管理类都必须继承此类，并实现单例方法）
 */
@interface CJFMDBFileManager : CJFileManager {
    
}
@property (nonatomic, copy, readonly) NSString *databaseDirectory;
@property (nonatomic, copy, readonly) NSString *databaseName;

/**
 *  取消对任何数据库的管理（账号切换的时候使用,即重新登录的时候）
 */
- (void)cancelManagerAnyDatabase;

#pragma mark - 创建数据库、数据表
/**
 *  复制数据库到某个目录下
 *
 *  @param databaseName         新建的数据库的名字
 *  @param subDirectoryPath     复制数据库到哪里
 *  @param bundleDatabaseName   要复制的数据库的名字
 *  @param FMDBFileExistAction  如果存在执行什么操作
 *
 *  return  是否新建成功
 */
- (BOOL)createDatabaseWithName:(NSString *)databaseName
            toSubDirectoryPath:(NSString *)subDirectoryPath
          byCopyBundleDatabase:(NSString *)bundleDatabaseName
               ifExistDoAction:(CJFMDBFileExistActionType)FMDBFileExistAction;

/**
 *  创建数据库
 *
 *  @param databaseName         数据库名字
 *  @param subDirectoryPath     数据库所在目录
 *  @param createTableSqls      数据表的创建语句
 *  @param FMDBFileExistAction  如果存在执行什么操作
 *
 *  return  是否新建成功
 */
- (BOOL)createDatabaseWithName:(NSString *)databaseName
              subDirectoryPath:(NSString *)subDirectoryPath
               createTableSqls:(NSArray<NSString *> *)createTableSqls
               ifExistDoAction:(CJFMDBFileExistActionType)FMDBFileExistAction;

/**
 *  重新创建新数据库（新数据库的数据库名和位置和原来的一样）
 *
 *  @param createTableSqls      新数据库数据表的创建语句
 */
- (void)recreateDatabase:(NSArray<NSString *> *)createTableSqls;

#pragma mark - 删除数据库目录/数据库文件
/**
 *  删除当前数据库文件（清除缓存的时候使用）
 *
 *  return 删除后的结果状态
 */
- (CJFMDBFileDeleteResult *)deleteCurrentFMDBFile;

/**
 *  删除数据库所在的文件夹（应用更新的时候使用）
 *
 *  return 是否删除成功
 */
- (BOOL)deleteCurrentFMDBDirectory;

#pragma mark - 数据库表操作
- (BOOL)create:(NSString *)sql;

- (BOOL)insert:(NSString *)sql;

- (BOOL)remove:(NSString *)sql;

- (BOOL)update:(NSString *)sql;

- (NSMutableArray *)query:(NSString *)sql;

@end
