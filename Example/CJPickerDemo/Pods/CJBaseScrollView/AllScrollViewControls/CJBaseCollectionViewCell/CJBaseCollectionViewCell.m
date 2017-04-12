//
//  CJBaseCollectionViewCell.m
//  AllScrollViewDemo
//
//  Created by lichq on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJBaseCollectionViewCell.h"

@interface CJBaseCollectionViewCell ()


@end


@implementation CJBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
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
    [self addCJTextLabelWithPosition:CJTextLabelPositionBottom];
    [self addCJImageViewWithEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

/**
 *  添加cjImageView
 *
 *  @param edgeInsets    cjImageView的edgeInsets
 */
- (void)addCJImageViewWithEdgeInsets:(UIEdgeInsets)edgeInsets {
    UIView *parentView = self.contentView;
    
    self.cjImageView = [[UIImageView alloc] init];
    self.cjImageView.contentMode = UIViewContentModeScaleToFill;
    self.cjImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cjImageView.layer.borderWidth = 1;
    self.cjImageView.layer.masksToBounds = YES;
    [parentView addSubview:self.cjImageView];
    self.cjImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjImageView
                                  attribute:NSLayoutAttributeLeft   //left
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:edgeInsets.left]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjImageView
                                  attribute:NSLayoutAttributeRight  //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:edgeInsets.right]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjImageView
                                  attribute:NSLayoutAttributeTop    //top
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:edgeInsets.top]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjImageView
                                  attribute:NSLayoutAttributeBottom //bottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:edgeInsets.bottom]];
}

/**
 *  添加cjTextLabel
 *
 *  @param textLabelPosition    cjTextLabel的textLabelPosition
 */
- (void)addCJTextLabelWithPosition:(CJTextLabelPosition)textLabelPosition {
    UIView *parentView = self.contentView;
    
    self.cjTextLabel = [[UILabel alloc] init];
    self.cjTextLabel.contentMode = UIViewContentModeScaleToFill;
    self.cjTextLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cjTextLabel.layer.borderWidth = 1;
    self.cjTextLabel.layer.masksToBounds = YES;
    self.cjTextLabel.textAlignment = NSTextAlignmentCenter;
    [parentView addSubview:self.cjTextLabel];
    self.cjTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                  attribute:NSLayoutAttributeLeft   //left
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:10]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                  attribute:NSLayoutAttributeRight  //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:-10]];
    
    switch (textLabelPosition) {
        case CJTextLabelPositionCenter:
        {
            [parentView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                          attribute:NSLayoutAttributeTop    //top
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:parentView
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1
                                           constant:0]];
            [parentView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                          attribute:NSLayoutAttributeBottom //bottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:parentView
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
            break;
        }
        case CJTextLabelPositionTop:
        {
            [parentView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                          attribute:NSLayoutAttributeTop    //top
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:parentView
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1
                                           constant:0]];
            [parentView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                          attribute:NSLayoutAttributeHeight //height
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:30]];
            break;
        }
        default:
        {
            [parentView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                          attribute:NSLayoutAttributeBottom //bottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:parentView
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
            [parentView addConstraint:
             [NSLayoutConstraint constraintWithItem:self.cjTextLabel
                                          attribute:NSLayoutAttributeHeight //height
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:30]];
            break;
        }
    }
    
}

/**
 *  添加cjDeleteButton
 *
 */
- (void)addCJDeleteButton {
    UIView *parentView = self.contentView;
    self.cjDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cjDeleteButton setImage:[UIImage imageNamed:@"cjCollectionViewCellDelete"] forState:UIControlStateNormal];
    [self.cjDeleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:self.cjDeleteButton];
    self.cjDeleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjDeleteButton
                                  attribute:NSLayoutAttributeTop    //top
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjDeleteButton
                                  attribute:NSLayoutAttributeHeight //height
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:25]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjDeleteButton
                                  attribute:NSLayoutAttributeRight  //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.cjDeleteButton
                                  attribute:NSLayoutAttributeWidth   //width
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:25]];
    //[self.contentView bringSubviewToFront:self.cjDeleteButton];
}


- (void)deleteButtonAction:(UIButton *)sender {
    if (self.deleteHandle) {
        self.deleteHandle(self);
    }
}

@end
