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

@end

@implementation CJUploadCollectionViewCell

- (void)commonInit {
    [super commonInit];
    
    UIView *parentView = self.contentView;
    
    [self addCJImageViewWithEdgeInsets:UIEdgeInsetsZero];
    self.cjImageView.image = [UIImage imageNamed:@"cjCollectionViewCellAdd"];
    [self addCJDeleteButton];
    
    self.uploadProgressView = [[CJUploadProgressView alloc] initWithFrame:CGRectZero];
    [self cj_makeView:parentView addSubView:self.uploadProgressView withEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [parentView bringSubviewToFront:self.cjDeleteButton]; //把cjDeleteButton移动最前
}

@end
