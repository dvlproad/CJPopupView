//
//  CJObjectConvertUtil.h
//  CommonAFNUtilDemo
//
//  Created by 李超前 on 2017/8/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJObjectConvertUtil : NSObject

+ (NSData *)dataFromDictionary:(NSDictionary *)dictionary;

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary;

+ (NSDictionary *)dictionaryFromData:(NSData *)data;

/* Source : http://iphonedevelopertips.com/core-services/create-md5-hash-from-nsstring-nsdata-or-file.html */
+ (NSString*)MD5StringFromString:(NSString *)string;

@end
