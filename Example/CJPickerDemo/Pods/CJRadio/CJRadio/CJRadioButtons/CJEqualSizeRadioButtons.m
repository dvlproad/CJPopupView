//
//  CJEqualSizeRadioButtons.m
//  CJRadioDemo
//
//  Created by ciyouzen on 2017/9/27.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJEqualSizeRadioButtons.h"

@interface CJEqualSizeRadioButtons ()<CJRadioButtonsDataSource, CJRadioButtonsDelegate> {
    
}
//readonly
@property (nonatomic, copy, readonly) CJConfigureScrollViewCellBlock configureDataCellBlock;
@property (nonatomic, copy, readonly) CJDidTapScrollViewItemBlock didTapDataItemBlock;

@end



@implementation CJEqualSizeRadioButtons

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.dataSource = self;
    self.delegate = self;
}

/* 完整的描述请参见文件头部 */
- (void)configureDataCellBlock:(CJConfigureScrollViewCellBlock)configureDataCellBlock {
    _configureDataCellBlock = configureDataCellBlock;
}

/* 完整的描述请参见文件头部 */
- (void)didTapDataItemBlock:(CJDidTapScrollViewItemBlock)didTapDataItemBlock {
    _didTapDataItemBlock = didTapDataItemBlock;
}



#pragma mark - CJRadioButtonsDataSource
- (NSInteger)cj_defaultShowIndexInRadioButtons:(CJRadioButtons *)radioButtons {
    return self.equalCellSizeSetting.defaultSelectedIndex;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(CJRadioButtons *)radioButtons {
    return self.dataModels.count;
}

- (CGFloat)cj_radioButtons:(CJRadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    CJEqualSizeSettingModel *equalCellSizeSetting = self.equalCellSizeSetting;
    
    CGFloat cellWidth = 0;
    if (equalCellSizeSetting.cellWidthFromFixedWidth) {
        cellWidth = equalCellSizeSetting.cellWidthFromFixedWidth;
        
    } else {
        CGFloat totalWidth = CGRectGetWidth(radioButtons.frame);
        NSInteger perRowMaxShowCount = equalCellSizeSetting.cellWidthFromPerRowMaxShowCount;
        cellWidth = totalWidth/perRowMaxShowCount;
        
        
        cellWidth = ceilf(cellWidth); //重点注意：当使用除法计算width时候，为了避免计算出来的值受除后，余数太多，除不尽(eg:102.66666666666667)，而造成的之后在通过左右箭头点击来寻找”要找的按钮“的时候，计算出现问题（”要找的按钮“需与“左右侧箭头的最左最右侧值”进行精确的比较），所以这里我们需要一个整数值，故我们这边选择向上取整。
        
        if (index == self.dataModels.count-1) {
            CGFloat hasUseWidth = (perRowMaxShowCount-1) * cellWidth;
            CGFloat totalWidth = CGRectGetWidth(radioButtons.frame);
            cellWidth = totalWidth - hasUseWidth; //确保加起来的width不变
        }
    }
    
    return cellWidth;
}

- (CJButton *)cj_radioButtons:(CJRadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    NSAssert(self.configureDataCellBlock != nil, @"未设置configureDataCellBlock");
    return self.configureDataCellBlock(radioButtons, indexPath);
}


#pragma mark - CJRadioButtonsDelegate
- (void)cj_radioButtons:(CJRadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index_cur inSection:0];
    if (self.didTapDataItemBlock) {
        self.didTapDataItemBlock(self, indexPath);
    }
}


@end
