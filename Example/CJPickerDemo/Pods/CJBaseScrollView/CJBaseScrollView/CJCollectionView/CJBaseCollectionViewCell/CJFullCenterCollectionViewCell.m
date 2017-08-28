//
//  CJFullCenterCollectionViewCell.m
//  AllScrollViewDemo
//
//  Created by ciyouzen on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJFullCenterCollectionViewCell.h"

@implementation CJFullCenterCollectionViewCell

- (void)cjBaseCollectionViewCell_commonInit {
    [self addCJImageViewWithEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self addCJTextLabelWithPosition:CJTextLabelPositionCenter];
}

@end
