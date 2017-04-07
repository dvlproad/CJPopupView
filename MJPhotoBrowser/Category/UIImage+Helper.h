//
//  UIImage+Helper.h
//  ijinbu
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

+ (UIImage*)originalRenderImageNamed:(NSString*)name;
- (UIImage*)stretchImageWithCapInsets:(UIEdgeInsets)inset;
+ (UIImage *)adjustImageWithImage:(UIImage *)image;
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
@end
