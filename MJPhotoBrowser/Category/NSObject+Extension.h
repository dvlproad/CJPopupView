//
//  NSObject+Extension.h
//  iweilai
//
//  Created by yang on 2017/3/13.
//  Copyright © 2017年 haixiaedu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Extension)

- (id)associatedObjectForKey:(void *)key;

- (void)setAssociatedObject:(id)object forKey:(void *)key;
- (void)setAssociatedObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy;

- (void)removeAssociatedObjectForKey:(void *)key;
- (void)removeAssociatedObjectForKey:(void *)key policy:(objc_AssociationPolicy)policy;

@end
