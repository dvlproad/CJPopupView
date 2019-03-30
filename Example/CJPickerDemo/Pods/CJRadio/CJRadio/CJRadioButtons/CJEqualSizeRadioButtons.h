//
//  CJEqualSizeRadioButtons.h
//  CJRadioDemo
//
//  Created by ciyouzen on 2017/9/27.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJRadioButtons.h"
#import "CJEqualSizeSettingModel.h"


typedef CJButton* (^CJConfigureScrollViewCellBlock)(CJRadioButtons *radioButtons, NSIndexPath *indexPath);
typedef void (^CJDidTapScrollViewItemBlock)(CJRadioButtons *radioButtons, NSIndexPath *indexPath); /**< 包括 didSelectItemAtIndexPath 和didDeselectItemAtIndexPath */

@interface CJEqualSizeRadioButtons : CJRadioButtons {
    
}
@property (nonatomic, strong) NSMutableArray *dataModels;       /**< 数据源 */
@property (nonatomic, strong) CJEqualSizeSettingModel *equalCellSizeSetting;


///必须
/**
 *  init之后，必须调用的configure方法
 *
 *  @param configureDataCellBlock   设置DataCell的方法
 */
- (void)configureDataCellBlock:(CJConfigureScrollViewCellBlock)configureDataCellBlock;

/**
 *  设置点击Item要执行的方法
 *
 *  @param didTapDataItemBlock   点击DataCell要执行的方法
 */
- (void)didTapDataItemBlock:(CJDidTapScrollViewItemBlock)didTapDataItemBlock;

@end
