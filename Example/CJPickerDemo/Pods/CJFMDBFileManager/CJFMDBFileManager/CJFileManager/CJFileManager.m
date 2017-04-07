//
//  CJFileManager.m
//  CommonFMDBUtilDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "CJFileManager.h"

@implementation CJFileManager

#pragma mark - 文件夹操作
/** 完整的描述请参见文件头部 */
+ (BOOL)deleteDirectoryBySubDirectoryPath:(NSString *)subDirectoryPath
                    inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory
{
    NSString *absoluteDirectory = [CJFileManager getLocalDirectoryPathType:CJLocalPathTypeAbsolute
                                                        bySubDirectoryPath:subDirectoryPath
                                                     inSearchPathDirectory:searchPathDirectory
                                                           createIfNoExist:NO];
    if ([absoluteDirectory length] == 0) {
        //NSLog(@"文件夹不存在，默认删除成功");
        return  YES;
        
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager removeItemAtPath:absoluteDirectory error:nil];
    }
}

/** 完整的描述请参见文件头部 */
+ (NSString *)getLocalDirectoryPathType:(CJLocalPathType)localPathType
                     bySubDirectoryPath:(NSString *)subDirectoryPath
                  inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory
                        createIfNoExist:(BOOL)createIfNoExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    
    NSString *absoluteDirectory = nil; //absoluteDirectory、relativeDirectory
    if (subDirectoryPath == nil || [subDirectoryPath length] == 0) {
        absoluteDirectory = pathDocuments;
    } else {
        absoluteDirectory = [NSString stringWithFormat:@"%@/%@", pathDocuments, subDirectoryPath];
    }
    
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDirectoryExists = [[NSFileManager defaultManager] fileExistsAtPath:absoluteDirectory];
    if (isDirectoryExists == NO) {      //文件夹不存在
        if (createIfNoExist == NO) {    //文件夹不存在时也不创建该文件夹
            return nil;                 //此时绝对路径、相对路径都是nil
        } else {
            BOOL createDirectorySuccess = [fileManager createDirectoryAtPath:absoluteDirectory
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:nil];
            if (!createDirectorySuccess) {
                NSLog(@"Failure: 文件夹存在时创建该文件夹失败");
                return nil;
            }
        }
    }
    
    
    if (localPathType == CJLocalPathTypeAbsolute) {
        return absoluteDirectory;
        
    } else {
        NSString *relativeDirectoryPre = nil;
        switch (searchPathDirectory) {
            case NSDocumentDirectory: {
                relativeDirectoryPre = @"Documents";
                break;
            }
            case NSLibraryDirectory: {
                relativeDirectoryPre = @"Library";
                break;
            }
            case NSCachesDirectory: {
                relativeDirectoryPre = [@"Library" stringByAppendingPathComponent:@"Caches"];
                break;
            }
            default: {
                NSAssert(NO, @"目前只支持把文件放在Documents、Library和Library下的Caches的文件路径的读取");
                break;
            }
        }
        
        NSString *relativeDirectory = @"";
        if (subDirectoryPath == nil || [subDirectoryPath length] == 0) {
            relativeDirectory = relativeDirectoryPre;
        } else {
            relativeDirectory = [relativeDirectoryPre stringByAppendingPathComponent:subDirectoryPath];
        }
        
        return relativeDirectory;
    }
}

#pragma mark - 文件操作
/** 完整的描述请参见文件头部 */
+ (BOOL)deleteFileWithFileName:(NSString *)fileName
              subDirectoryPath:(NSString *)subDirectoryPath
         inSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory
{
    NSAssert(fileName, @"fileName cannot be nil!");
    
    NSString *absoluteDirectory = [CJFileManager getLocalDirectoryPathType:CJLocalPathTypeAbsolute
                                                        bySubDirectoryPath:subDirectoryPath
                                                     inSearchPathDirectory:searchPathDirectory
                                                           createIfNoExist:NO];
    NSString *absoluteFilePath = [absoluteDirectory stringByAppendingPathComponent:fileName];
    if ([absoluteFilePath length] == 0) {
        //NSLog(@"%@文件不存在，默认删除成功", fileName);
        return YES;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL deleteFileSuccess = [fileManager removeItemAtPath:absoluteFilePath error:nil];
    return deleteFileSuccess;
}

/** 完整的描述请参见文件头部 */
+ (NSString *)saveFileData:(NSData *)data
              withFileName:(NSString *)fileName
        inSubDirectoryPath:(NSString *)subDirectoryPath
       searchPathDirectory:(NSSearchPathDirectory)searchPathDirectory
{
    //文件所在目录
    NSString *absoluteDirectory = [CJFileManager getLocalDirectoryPathType:CJLocalPathTypeAbsolute
                                                        bySubDirectoryPath:subDirectoryPath
                                                     inSearchPathDirectory:searchPathDirectory
                                                           createIfNoExist:YES];

    //由文件所在目录和文件名组成的文件路径
    NSString *absoluteFilePath = [absoluteDirectory stringByAppendingPathComponent:fileName];
    BOOL success = [data writeToFile:absoluteFilePath atomically:YES];
    if (success) {
        NSString *relativeDirectory = [CJFileManager getLocalDirectoryPathType:CJLocalPathTypeRelative
                                                            bySubDirectoryPath:subDirectoryPath
                                                         inSearchPathDirectory:searchPathDirectory
                                                               createIfNoExist:YES];
        NSString *relativeFilePath = [relativeDirectory stringByAppendingPathComponent:fileName];
        return relativeFilePath;
    }
    return nil;
}

@end
