//
//  CJFullBottomCollectionViewCell.m
//  AllScrollViewDemo
//
//  Created by ciyouzen on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJFullBottomCollectionViewCell.h"

@implementation CJFullBottomCollectionViewCell

- (void)cjBaseCollectionViewCell_commonInit {
    [self addCJImageViewWithEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self addCJTextLabelWithPosition:CJTextLabelPositionBottom];
}

@end
