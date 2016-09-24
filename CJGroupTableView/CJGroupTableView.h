//
//  CJGroupTableView.h
//  CJGroupTableViewDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDataGroupModel.h"

@class CJGroupTableView;
@protocol CJGroupTableViewDelegate <NSObject>

- (void)cj_groupTableView:(CJGroupTableView *)groupTableView didSelectText:(NSString *)text;

@end


    
@interface CJGroupTableView : UIView<UITableViewDataSource, UITableViewDelegate>{
    NSInteger componentCount;
}
@property(nonatomic, strong) CJDataGroupModel *dataGroupModel;//含NSMutableArray *datas;和 NSArray *dicArray
@property(nonatomic, strong) id<CJGroupTableViewDelegate> delegate;

/**
 *  更新第component个列表的颜色
 *
 *  @param color     要更新成的颜色
 *  @param component 第component个列表
 */
- (void)updateTableViewBackgroundColor:(UIColor *)color inComponent:(NSInteger)component;

@end
