//
//  CJUploadCollectionViewCell.m
//  AllScrollViewDemo
//
//  Created by lichq on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJUploadCollectionViewCell.h"

@interface CJUploadCollectionViewCell () {
    
}
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *progressMaskView; /**< 标记剩下多少没处理(即没上传) */
@property (nonatomic, strong) NSLayoutConstraint *progressMaskViewHeightConstraint;

@end

@implementation CJUploadCollectionViewCell

- (void)commonInit {
    [super commonInit];
    
    UIView *parentView = self.contentView;
    
    [self addCJImageViewWithEdgeInsets:UIEdgeInsetsZero];
    self.cjImageView.image = [UIImage imageNamed:@"cjCollectionViewCellAdd"];
    [self addCJDeleteButton];
    
    self.progressMaskView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.progressMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.progressMaskView.backgroundColor = [UIColor redColor];
    [parentView addSubview:self.progressMaskView];
    
    _progressMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:_progressMaskView
                                  attribute:NSLayoutAttributeLeft   //left
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0]];
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:_progressMaskView
                                  attribute:NSLayoutAttributeRight  //right
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0]];
    
    [parentView addConstraint:
     [NSLayoutConstraint constraintWithItem:_progressMaskView
                                  attribute:NSLayoutAttributeBottom //bottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0]];
    
    self.progressMaskViewHeightConstraint =
     [NSLayoutConstraint constraintWithItem:_progressMaskView
                                  attribute:NSLayoutAttributeHeight   //height
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:parentView
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:0
                                   constant:0];
    [parentView addConstraint:self.progressMaskViewHeightConstraint];
    
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //self.progressLabel.backgroundColor = [UIColor cyanColor];
    //self.progressLabel.text = [NSString stringWithFormat:@"0%%"];
    self.progressLabel.numberOfLines = 0;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:15];
    [self cj_makeView:parentView addSubView:self.progressLabel withEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.contentView bringSubviewToFront:self.cjDeleteButton]; //把cjDeleteButton移动最前
}

/** 完整的描述请参见文件头部 */
- (void)updateProgressText:(NSString *)progressText progressVaule:(CGFloat)progressValue {
    self.progressLabel.text = progressText;
    [self updateProgressMaskViewWithProgressVaule:progressValue];
}

/**
 *  更新上传状态的进度
 *
 *  @param progressValue    该上传状态的进度值[0-100]
 */
- (void)updateProgressMaskViewWithProgressVaule:(CGFloat)progressValue {
    //progressValue等于100不代表成功
    CGFloat remainProgressValue = (100.0-progressValue)/100.0;
    
    if (progressValue == 0) {
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reUpload:)];
        [self.progressMaskView addGestureRecognizer:tapGR];
    }
    
    UIView *parentView = self.contentView;
    
    [parentView removeConstraint:self.progressMaskViewHeightConstraint];
    self.progressMaskViewHeightConstraint =
    [NSLayoutConstraint constraintWithItem:_progressMaskView
                                 attribute:NSLayoutAttributeHeight   //height
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:parentView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:remainProgressValue
                                  constant:0];
    [parentView addConstraint:self.progressMaskViewHeightConstraint];
    
    [UIView animateWithDuration:0.09f animations:^{
        [self setNeedsLayout];
    }];
}


/** 重新上传 */
- (void)reUpload:(UITapGestureRecognizer *)tapGR {
    self.progressMaskView.hidden = NO;
    self.progressLabel.hidden = NO;
    [self.progressMaskView removeGestureRecognizer:tapGR];
    if (self.cjReUploadHandle) {
        self.cjReUploadHandle(self);
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
