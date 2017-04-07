//
//  UIImage+Helper.m
//  ijinbu
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 haixiaedu. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

+ (UIImage*)originalRenderImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)])
        return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

- (UIImage*)stretchImageWithCapInsets:(UIEdgeInsets)inset
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        return [self resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    }
    else
    {
        return [self stretchableImageWithLeftCapWidth:inset.left topCapHeight:inset.top];
    }
}
+ (UIImage *)adjustImageWithImage:(UIImage *)image
{
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    NSLog(@"origin --imageData : %f MB size:%@",(unsigned long)[imageData length]/(1024*1024.f),[NSValue valueWithCGSize:image.size]);
    
    if ([imageData length] > 0.5 * 1024 * 1024) {
        imageData = UIImageJPEGRepresentation(image, 0.8);
        if ([imageData length] > 0.5 * 1024 * 1024) {
            image = [UIImage imageWithImageSimple:[UIImage imageWithData:imageData] scaledToSize:CGSizeMake(1920, 1920)];
        }
        
        imageData = UIImageJPEGRepresentation(image,0.8);
        NSLog(@"result has scaled -- imageData : %f MB size:%@",(unsigned long)imageData.length/(1024*1024.f),[NSValue valueWithCGSize:image.size]);

        image = [UIImage imageWithData:imageData];
        return image;
    }
    else
    {
        return image;
    }
}

/**
 * 修发图片大小
 * 压缩图片分辨率(宽高限制的最大值1920) 按比例裁切图片
 * 图片质量压缩0.8
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) maxSize
{
    if (image.size.width > image.size.height)
    {
        if (image.size.width > maxSize.width)
        {
            maxSize.height=image.size.height*(maxSize.width/image.size.width);
            UIGraphicsBeginImageContext(maxSize);
            [image drawInRect:CGRectMake(0, 0, maxSize.width, maxSize.height)];
            UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return  newImage;
        }
    }
    else
    {
        if (image.size.height > maxSize.height)
        {
            maxSize.width=image.size.width*(maxSize.height/image.size.height);
            UIGraphicsBeginImageContext(maxSize);
            [image drawInRect:CGRectMake(0, 0, maxSize.width, maxSize.height)];
            UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return  newImage;
        }
    }
    return image;
}

@end
