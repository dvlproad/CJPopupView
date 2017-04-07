//
//  CJFMDBFileManager.m
//  CommonFMDBUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJFMDBFileManager.h"
#import "FMDB.h"

static NSString *CJFMDBFileManagerDBName = @"CJFMDBFileManagerDBName";/**< 该数据库管理器被用来管理哪个数据库(如果为空，则表示该数据库管理器未被使用来管理任何数据库)  */
static NSString *CJFMDBFileDirectory = @"CJFMDBFileDirectory";
static NSString *CJFMDBFileName = @"CJFMDBFileName";

@interface CJFMDBFileManager ()

@property (nonatomic, copy) NSString *databasePath;   /**< 当前数据库路径 */

@end

@implementation CJFMDBFileManager

/** 完整的描述请参见文件头部 */
- (void)cancelManagerAnyDatabase {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentFMDBFileManagerName = NSStringFromClass([self class]);
    NSString *managerDBNameKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileManagerDBName];
    [userDefaults removeObjectForKey:managerDBNameKey];
}

#pragma mark - 创建数据库、数据表
/** 完整的描述请参见文件头部 */
- (BOOL)createDatabaseWithName:(NSString *)databaseName
            toSubDirectoryPath:(NSString *)subDirectoryPath
          byCopyBundleDatabase:(NSString *)bundleDatabaseName
               ifExistDoAction:(CJFMDBFileExistActionType)FMDBFileExistAction
{
    NSString *databasePath = [self setDatabaseName:databaseName subDirectoryPath:subDirectoryPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        if (FMDBFileExistAction == CJFMDBFileExistActionTypeShowError) {
            NSAssert(NO, @"复制mainBundle中的数据库到指定目录失败，因为该目录已存在同名文件%@ !", databasePath);
            return NO;
            
        } else if (FMDBFileExistAction == CJFMDBFileExistActionTypeUseOld) {
            //NSLog(@"该目录已存在同名文件%@ !，故不重复创建，继续使用之前的", databasePath);
            return YES;
            
        } else if (FMDBFileExistAction == CJFMDBFileExistActionTypeRerecertIt) {
            [self deleteCurrentFMDBFile];
        }
    }
    
    
    //复制文件到我们指定的目录
    NSError *error = nil;
    NSString *bunldeDatabasePath = [[NSBundle mainBundle] pathForResource:bundleDatabaseName ofType:nil];
    BOOL copySuccess = [[NSFileManager defaultManager] copyItemAtPath:bunldeDatabasePath toPath:databasePath error:&error];
    if (copySuccess) {
        NSLog(@"复制数据库文件到指定目录%@成功", databasePath);
    } else {
        NSLog(@"复制数据库文件到指定目录%@失败，因为%@", databasePath, [error localizedDescription]);
    }
    
    return copySuccess;
}

/** 完整的描述请参见文件头部 */
- (BOOL)createDatabaseWithName:(NSString *)databaseName
              subDirectoryPath:(NSString *)subDirectoryPath
               createTableSqls:(NSArray<NSString *> *)createTableSqls
               ifExistDoAction:(CJFMDBFileExistActionType)FMDBFileExistAction
{
    NSString *databasePath = [self setDatabaseName:databaseName subDirectoryPath:subDirectoryPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        if (FMDBFileExistAction == CJFMDBFileExistActionTypeShowError) {
            NSAssert(NO, @"创建数据库到指定目录失败，因为该目录已存在同名文件%@ !", databasePath);
            return NO;
            
        } else if (FMDBFileExistAction == CJFMDBFileExistActionTypeUseOld) {
            //NSLog(@"该目录已存在同名文件%@ !，故不重复创建，继续使用之前的", databasePath);
            return YES;
            
        } else if (FMDBFileExistAction == CJFMDBFileExistActionTypeRerecertIt) {
            [self deleteCurrentFMDBFile];
        }
    }
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    if (![db open]) { //执行open的时候，如果数据库不存在则会自动创建
        NSAssert(NO, @"创建数据库文件失败!", databaseName);
        return NO;
        
    } else {
        NSLog(@"创建数据库到指定目录%@成功", databasePath);
        for (NSString *createTableSql in createTableSqls) {
            BOOL result = [db executeUpdate:createTableSql];
            if (result == NO) {
                NSLog(@"操作数据表失败:%@", createTableSql);
            }
        }
        
        [db close];
        
        return YES;
    }
}

/** 完整的描述请参见文件头部 */
- (void)recreateDatabase:(NSArray<NSString *> *)createTableSqls {
    CJFMDBFileDeleteResult *deleteResult = [self deleteCurrentFMDBFile];
    
    NSString *subDirectoryPath = deleteResult.deleteFileInDirectoryName;
    NSString *fileName = deleteResult.deleteFileName;
    
    [self createDatabaseWithName:fileName
                subDirectoryPath:subDirectoryPath
                 createTableSqls:createTableSqls
                 ifExistDoAction:CJFMDBFileExistActionTypeRerecertIt];
}

#pragma mark - 删除数据库目录/数据库文件
/** 完整的描述请参见文件头部 */
- (CJFMDBFileDeleteResult *)deleteCurrentFMDBFile {
    CJFMDBFileDeleteResult *deleteResult = [[CJFMDBFileDeleteResult alloc] init];
    
    NSString *subDirectoryPath = self.databaseDirectory; //不使用此方法的原因：重启后内存释放会导致获取不到
    NSString *fileName = self.databaseName;
    if ([fileName length] == 0) {
        //NSLog(@"删除数据库文件时候，获取不到文件名（原因可能为重启后内存释放）,故这里改为通过plist方式获取");
        
        NSString *currentFMDBFileManagerName = NSStringFromClass([self class]);
        NSString *subDirectoryPathKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileDirectory];
        NSString *fileNameKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileName];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        subDirectoryPath = [userDefaults objectForKey:subDirectoryPathKey];
        fileName = [userDefaults objectForKey:fileNameKey];
    }
    
    deleteResult.deleteFileName = fileName;
    deleteResult.deleteFileInDirectoryName = subDirectoryPath;
    
    BOOL deleteFileSuccess = NO;
    if ([fileName length] == 0) {
        NSLog(@"删除数据库文件时候，还是获取不到文件名，默认删除成功(有可能是重复删除)");
        deleteFileSuccess = YES;
        
    } else {
        NSString *filePath = [self getDatabasePathWithName:fileName
                                          subDirectoryPath:subDirectoryPath];
        if ([filePath length] == 0) {
            NSLog(@"删除数据库文件时候，%@文件不存在，默认删除成功", fileName);
            deleteFileSuccess = YES;
            
        } else {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            deleteFileSuccess = [fileManager removeItemAtPath:filePath error:nil];
            if (deleteFileSuccess) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *currentFMDBFileManagerName = NSStringFromClass([self class]);
                NSString *fileNameKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileName];
                
                [userDefaults removeObjectForKey:fileNameKey];
                _databaseName = nil;
            }
            NSLog(@"删除数据库文件%@%@", filePath, deleteFileSuccess ? @"成功" : @"失败");
        }
        
        
    }
    deleteResult.success = deleteFileSuccess;
    
    NSLog(@"总结：删除%@中的%@数据库文件%@", deleteResult.deleteFileInDirectoryName, deleteResult.deleteFileName, deleteResult.success ? @"成功":@"失败");
    
    
    return deleteResult;
}

/** 完整的描述请参见文件头部 */
- (BOOL)deleteCurrentFMDBDirectory {
    NSString *subDirectoryPath = self.databaseDirectory; //重启后为空
    if (subDirectoryPath == nil) {
        NSString *currentFMDBFileManagerName = NSStringFromClass([self class]);
        NSString *subDirectoryPathKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileDirectory];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        subDirectoryPath = [userDefaults objectForKey:subDirectoryPathKey];
    }
    
    BOOL deleteDirectorySuccess = [CJFileManager deleteDirectoryBySubDirectoryPath:subDirectoryPath inSearchPathDirectory:NSDocumentDirectory];
    if (deleteDirectorySuccess) {
        NSString *currentFMDBFileManagerName = NSStringFromClass([self class]);
        NSString *subDirectoryPathKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileDirectory];
        NSString *fileNameKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileName];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults removeObjectForKey:subDirectoryPathKey];
        [userDefaults removeObjectForKey:fileNameKey];
        _databaseDirectory = nil;
        _databaseName = nil;
    }
    
    return deleteDirectorySuccess;
}



#pragma mark - 数据库表操作
- (BOOL)create:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}


- (BOOL)insert:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

- (BOOL)remove:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

- (BOOL)update:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self executeUpdate:sql args:nil];
}

- (NSMutableArray *)query:(NSString *)sql
{
    NSAssert(sql, @"sql cannot be nil!");
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
        
        [db close];
    }
    
    db = nil;
    
    return result;
}



#pragma mark - private method

- (BOOL)executeUpdate:(NSString *)sql args:(NSArray *)args
{
    BOOL success = NO;
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    
    if ([db open]) {
        success = [db executeUpdate:sql withArgumentsInArray:args];
        
        [db close];
    }
    
    db = nil;
    
    return success;
}

- (NSString *)setDatabaseName:(NSString *)databaseName subDirectoryPath:(NSString *)subDirectoryPath {
    NSAssert(databaseName, @"databaseName cannot be nil!");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentFMDBFileManagerName = NSStringFromClass([self class]);
    NSString *managerDBNameKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileManagerDBName];
    NSString *managerDBName = [userDefaults objectForKey:managerDBNameKey];
    if ([managerDBName length] > 0 && ![managerDBName isEqualToString:databaseName]) {
        NSLog(@"%@数据库控制器已用来管理数据库%@,请重新选择其他控制器来管理%@。或者您可以在创建/复制数据库前，通过cancelManagerAnyDatabase方法来取消%@对之前的数据库%@的管理，以此来让它管理现在的数据库%@", NSStringFromClass([self class]), managerDBName, databaseName, NSStringFromClass([self class]), managerDBName, databaseName);
        NSAssert(NO, @"%@数据库控制器已用来管理数据库%@,请重新选择其他控制器来管理%@。或者您可以在创建/复制数据库前，通过cancelManagerAnyDatabase方法来取消%@对之前的数据库%@的管理，以此来让它管理现在的数据库%@", NSStringFromClass([self class]), managerDBName, databaseName, NSStringFromClass([self class]), managerDBName, databaseName);
    }
    [userDefaults setObject:databaseName forKey:managerDBNameKey];
    
    NSString *subDirectoryPathKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileDirectory];
    NSString *databaseNameKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileName];
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:subDirectoryPath forKey:subDirectoryPathKey];
    [userDefaults setObject:databaseName forKey:databaseNameKey];
    [userDefaults synchronize];
    
    _databaseName = databaseName;
    _databaseDirectory = subDirectoryPath;
    
    NSString *databasePath = [self getDatabasePathWithName:databaseName
                                          subDirectoryPath:subDirectoryPath];
    
    _databasePath = databasePath;
    return databasePath;
}


- (NSString *)databasePath {
    if (_databasePath && [_databasePath length] > 0) {
        return _databasePath;
    }
    
    NSString *currentFMDBFileManagerName = NSStringFromClass([self class]);
    NSString *subDirectoryPathKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileDirectory];
    NSString *fileNameKey = [NSString stringWithFormat:@"%@_%@", currentFMDBFileManagerName, CJFMDBFileName];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *subDirectoryPath = [userDefaults objectForKey:subDirectoryPathKey];
    NSString *fileName = [userDefaults objectForKey:fileNameKey];
    
    NSString *databasePath = [self getDatabasePathWithName:fileName subDirectoryPath:subDirectoryPath];
    _databasePath = databasePath;
    
    return _databasePath;
}

/**
 *  获取数据库路径
 *
 *  @param databaseName         数据库名字
 *  @param subDirectoryPath     子文件夹的路径/名字(可多层xx/yy，也可为空)
 *
 *  return 数据库路径
 */

- (NSString *)getDatabasePathWithName:(NSString *)databaseName
                     subDirectoryPath:(NSString *)subDirectoryPath {
    NSString *databaseDirectory = [CJFileManager getLocalDirectoryPathType:CJLocalPathTypeAbsolute
                                                        bySubDirectoryPath:subDirectoryPath
                                                     inSearchPathDirectory:NSDocumentDirectory
                                                           createIfNoExist:YES];
    NSString *databasePath = [databaseDirectory stringByAppendingPathComponent:databaseName];
    //NSLog(@"数据库路径 = %@", databasePath);
    
    return databasePath;
}


@end
