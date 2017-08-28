//
//  CJBaseCollectionViewCell.h
//  AllScrollViewDemo
//
//  Created by ciyouzen on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CJTextLabelPosition) {
    CJTextLabelPositionCenter,
    CJTextLabelPositionTop,
    CJTextLabelPositionBottom,
};

@interface CJBaseCollectionViewCell : UICollectionViewCell {
    
}
@property (nonatomic, copy) void(^deleteHandle)(CJBaseCollectionViewCell * cell);

@property (nonatomic, strong) UILabel *cjTextLabel;
@property (nonatomic, strong) UIImageView *cjImageView;
@property (nonatomic, strong) UIButton *cjDeleteButton;

/**
 *  在子类中对init做具体实现
 *
 */
- (void)cjBaseCollectionViewCell_commonInit;

//提供给init的方法
- (void)addCJImageViewWithEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)addCJTextLabelWithPosition:(CJTextLabelPosition)textLabelPosition;
- (void)addCJDeleteButton;

@end
