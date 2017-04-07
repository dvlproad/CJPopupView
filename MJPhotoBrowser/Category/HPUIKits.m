//
//  HPUIKits.m
//  ijinbu
//
//  Created by Michael on 3/31/16.
//  Copyright © 2016 haixiaedu. All rights reserved.
//

#import "HPUIKits.h"
#import <Masonry/Masonry.h>

@implementation HCView


- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIColor * color = [UIColor colorWithPatternImage:backgroundImage];
    [self setBackgroundColor:color];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}


@end

@interface HCControl ()

@property (nonatomic, weak) UIImageView * bgImageView;
@end

@implementation HCControl

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (self.bgImageView == nil) {
        UIImageView * bg = [[UIImageView alloc] initWithImage:backgroundImage];
        [self insertSubview:bg atIndex:0];
        self.bgImageView = bg;
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    self.bgImageView.image = backgroundImage;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (_highlightedColor != nil) {
        self.backgroundColor = _highlightedColor;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (_defaultColor != nil) {
        self.backgroundColor = _defaultColor;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (_defaultColor != nil) {
        self.backgroundColor = _defaultColor;
    }
}


@end

@implementation HCButton

- (void)setImageCapInsets:(CGRect)imageCapInsets
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(imageCapInsets.origin.x, imageCapInsets.origin.y, imageCapInsets.size.width, imageCapInsets.size.height);
    UIImage * imgNormal = [self imageForState:UIControlStateNormal];
    UIImage * imgHighlighted = [self imageForState:UIControlStateHighlighted];
    UIImage * bgImgNormal = [self backgroundImageForState:UIControlStateNormal];
    UIImage * bgImgHighlighted = [self backgroundImageForState:UIControlStateHighlighted];
    
    if (imgNormal) {
        [self setImage:[imgNormal resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
    }
    if (imgHighlighted) {
        [self setImage:[imgHighlighted resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
    }
    if (bgImgNormal) {
        [self setBackgroundImage:[bgImgNormal resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
    }
    if (bgImgHighlighted) {
        [self setBackgroundImage:[bgImgHighlighted resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

@end

@implementation HCLabel


- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

//- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
//    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
//    // http://blog.csdn.net/yexiaozi_007/article/details/8636522
////    switch (self.verticalAlignment) {
////        case VerticalAlignmentTop:
////            textRect.origin.y = bounds.origin.y;
////            break;
////        case VerticalAlignmentBottom:
////            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
////            break;
////        case VerticalAlignmentMiddle:
////            // Fall through.
////        default:
////            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
////    }
//    textRect.origin.y = bounds.origin.y;
//    return textRect;
//}
//
//-(void)drawTextInRect:(CGRect)requestedRect {
//    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
//    [super drawTextInRect:actualRect];
//}

@end

@implementation HCTextView


- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

@end


@implementation HCImageView

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (void)setImageCapInsets:(CGRect)imageCapInsets
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(imageCapInsets.origin.x, imageCapInsets.origin.y, imageCapInsets.size.width, imageCapInsets.size.height);
    self.image = [self.image resizableImageWithCapInsets:edgeInsets];
}

@end
