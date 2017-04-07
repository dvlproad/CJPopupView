//
//  NSObject+Extension.m
//  iweilai
//
//  Created by yang on 2017/3/13.
//  Copyright © 2017年 haixiaedu. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (id)associatedObjectForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)removeAssociatedObjectForKey:(void *)key {
    [self removeAssociatedObjectForKey:key policy:OBJC_ASSOCIATION_RETAIN];
}

- (void)removeAssociatedObjectForKey:(void *)key policy:(objc_AssociationPolicy)policy {
    [self setAssociatedObject:nil forKey:key policy:policy];
}

- (void)setAssociatedObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(self, key, object, policy);
}

- (void)setAssociatedObject:(id)object forKey:(void *)key {
    [self setAssociatedObject:object forKey:key policy:OBJC_ASSOCIATION_RETAIN];
}


@end
