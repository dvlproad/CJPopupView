//
//  RadioButton.m
//  CJRadioDemo
//
//  Created by lichq on 9/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.button addTarget:self action:@selector(radioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    [self cj_makeView:self addSubView:self.label withEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(radioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self cj_makeView:self addSubView:self.button withEdgeInsets:UIEdgeInsetsZero];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self.imageView
                                  attribute:NSLayoutAttributeCenterY    //centerY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.imageView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.imageView
                                  attribute:NSLayoutAttributeHeight //height
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:12]];
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self.imageView
                                  attribute:NSLayoutAttributeRight      //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:-10]];
    [self.imageView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.imageView
                                  attribute:NSLayoutAttributeWidth    //width
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:12]];
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
    self.button.selected = selected;
    self.label.textColor = selected ? self.textSelectedColor : self.textNormalColor;
    
    
    if (self.stateChangeCompleteBlock) {
        self.stateChangeCompleteBlock(self);
    }
}

- (void)radioButtonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(radioButtonClick:)]) {
        [self.delegate radioButtonClick:self];
    }
}

#pragma mark - addSubView
- (void)cj_makeView:(UIView *)superView addSubView:(UIView *)subView withEdgeInsets:(UIEdgeInsets)edgeInsets {
//- (void)cj_addSubView:(UIView *)subView toSuperView:(UIView *)superView withEdgeInsets:(UIEdgeInsets)edgeInsets {
    [superView addSubview:subView];
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:edgeInsets.left]];
    //right
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:edgeInsets.right]];
    //top
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:edgeInsets.top]];
    //bottom
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem:subView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:edgeInsets.bottom]];
}


@end
