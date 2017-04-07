//
//  CJBaseCollectionViewCell.h
//  AllScrollViewDemo
//
//  Created by lichq on 2016/06/07.
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

- (void)commonInit;
- (void)addCJImageViewWithEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)addCJTextLabelWithPosition:(CJTextLabelPosition)textLabelPosition;
- (void)addCJDeleteButton;

@end
