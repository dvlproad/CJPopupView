//
//  CJDataListViewGroup.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDataGroupModel.h"

@class CJDataListViewGroup;
@protocol CJDataListViewGroupDelegate <NSObject>

- (void)cj_dataListViewGroup:(CJDataListViewGroup *)dataListViewGroup didSelectText:(NSString *)text;

@end



    
@interface CJDataListViewGroup : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSInteger componentCount;
}
@property(nonatomic, strong) CJDataGroupModel *dataGroupModel;//含NSMutableArray *datas;和 NSArray *dicArray
@property(nonatomic, strong) id<CJDataListViewGroupDelegate> delegate;

/**
 *  更新第component个列表的颜色
 *
 *  @param color     要更新成的颜色
 *  @param component 第component个列表
 */
- (void)updateTableViewBackgroundColor:(UIColor *)color inComponent:(NSInteger)component;

@end
