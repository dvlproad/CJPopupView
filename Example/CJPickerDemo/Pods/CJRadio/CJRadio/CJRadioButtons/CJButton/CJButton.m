//
//  CJButton.m
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import "CJButton.h"

@implementation CJButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self cjButton_commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self cjButton_commonInit];
    }
    return self;
}

- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)cjButton_commonInit {
    [self addTapGestureRecognizer];
    
    self.imagePosition = CJButtonImagePositionNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.textColor = self.isSelected ? self.textSelectedColor : self.textNormalColor;
}

- (void)setTitle:(NSString *)title {
    //[self.button  setTitle:title forState:UIControlStateNormal];
    [self.label setText:title];
}

- (void)setSelected:(BOOL)selected {
    if (selected == _selected) {    //如果选中的一样则不进行操作，比如imageV就不进行transform了
        return;
    }
    
    _selected = selected;
    self.label.textColor = selected ? self.textSelectedColor : self.textNormalColor;
    
    
    if (self.stateChangeCompleteBlock) {
        self.stateChangeCompleteBlock(self);
    }
}

- (void)tapAction:(id)sender {
    if (self.tapAction) {
        self.tapAction(self);
    }
}




- (void)setImagePosition:(CJButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    
    if (self.label) {
        [self.label removeFromSuperview];
    }
    
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    //self.label.backgroundColor = [UIColor greenColor];
    
    switch (imagePosition) {
        case CJButtonImagePositionNone:
        {
            //label
            [self cj_makeView:self addSubView:self.label withEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
            break;
        }
        case CJButtonImagePositionLeft:
        case CJButtonImagePositionRight:
        {
            //imageView
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:self.imageView];
            self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.imageView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.imageView
                                          attribute:NSLayoutAttributeHeight //height
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:12]];
            
            [self.imageView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.imageView
                                          attribute:NSLayoutAttributeWidth    //width
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:12]];
            
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:self.imageView
                                          attribute:NSLayoutAttributeCenterY    //centerY
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1
                                           constant:0]];
            
            if (imagePosition == CJButtonImagePositionLeft) {
                [self addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.imageView
                                              attribute:NSLayoutAttributeLeft      //left
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1
                                               constant:10]];
            } else {
                [self addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.imageView
                                              attribute:NSLayoutAttributeRight      //right
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1
                                               constant:-10]];
            }
            
            //label
            [self addSubview:self.label];
            self.label.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:self.label
                                          attribute:NSLayoutAttributeTop    //top
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1
                                           constant:0]];
            
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:self.label
                                          attribute:NSLayoutAttributeBottom //bottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
            if (imagePosition == CJButtonImagePositionLeft) {
                [self addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.label
                                              attribute:NSLayoutAttributeLeft   //left
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.imageView
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1
                                               constant:0]];
                [self addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.label
                                              attribute:NSLayoutAttributeRight  //right
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1
                                               constant:0]];
            } else {
                [self addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.label
                                              attribute:NSLayoutAttributeLeft  //left
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1
                                               constant:0]];
                [self addConstraint:
                 [NSLayoutConstraint constraintWithItem:self.label
                                              attribute:NSLayoutAttributeRight   //right
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.imageView
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1
                                               constant:0]];
            }
            
            break;
        }
        default:
            break;
    }
}


#pragma mark - addSubView
- (void)cj_makeView:(UIView *)superView addSubView:(UIView *)subView withEdgeInsets:(UIEdgeInsets)edgeInsets {
    [superView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeLeft   //left
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:edgeInsets.left]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeRight  //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:edgeInsets.right]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeTop    //top
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:edgeInsets.top]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeBottom //bottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:edgeInsets.bottom]];
}


@end
