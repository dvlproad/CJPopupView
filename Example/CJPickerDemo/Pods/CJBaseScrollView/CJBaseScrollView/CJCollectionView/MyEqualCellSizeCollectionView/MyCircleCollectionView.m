//
//  MyCircleCollectionView.m
//  AllScrollViewDemo
//
//  Created by ciyouzen on 2017/9/12.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "MyCircleCollectionView.h"

@implementation MyCircleCollectionView



- (void)commonInit {
    [super commonInit];
    
    /* 基本设置 */
    self.pagingEnabled = YES;
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
    
    /* 其他基本设置 */
    MyEqualCellSizeSetting *equalCellSizeSetting = [[MyEqualCellSizeSetting alloc] init];
//    equalCellSizeSetting.minimumInteritemSpacing = 0;
//    equalCellSizeSetting.minimumLineSpacing = 0;
//    equalCellSizeSetting.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //以下值必须二选一设置（默认cellWidthFromFixedWidth设置后，另外一个自动失效）
    equalCellSizeSetting.cellWidthFromPerRowMaxShowCount = 1;
    //equalCellSizeSetting.cellWidthFromFixedWidth = 50;
    
    //以下值，可选设置
    //equalCellSizeSetting.collectionViewCellHeight = 30;
    equalCellSizeSetting.collectionViewCellHeight = CGRectGetHeight(self.frame);
    //equalCellSizeSetting.maxDataModelShowCount = 5;
    //equalCellSizeSetting.extralItemSetting = CJExtralItemSettingLeading;
    
    self.equalCellSizeSetting = equalCellSizeSetting;
}

@end
