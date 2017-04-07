//
//  HCTableView.h
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCRefreshView.h"

@interface HCTableView : UITableView

@property (nonatomic, strong) HCRefreshView * refreshHeader;  // 下拉刷新视图
@property (nonatomic) BOOL refreshHeaderEnabled; // 下拉刷新视图启用标记，默认启用
@property (nonatomic, strong) HCRefreshView * refreshFooter; // 上拖加载视图
@property (nonatomic) BOOL refreshFooterEnabled; // 上拖加载视图启用标记，默认不启用
@property (nonatomic, weak) id<HCRefreshViewDelegate> hcRefreshViewDelegate;

// 请在scrollViewDidScroll方法调用此方法
- (void)hcTableViewDidScroll;

// 请在scrollViewWillBeginDragging方法调用此方法
- (void)hcTableViewWillBeginDragging;

// 请在scrollViewDidEndDragging方法调用此方法
- (void)hcTableViewDidEndDragging;

// 数据加载后刷新视图请调用此方法
- (void)hcTableViewDidDataUpdated;

@end

//
//  如果 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 方法出现数组溢出崩溃，请在方法中加上if(indePath.row < 数组.count){...}处理
//
//
//  请在目标类中实现HCRefreshViewDelegate，该协议中hcRefreshViewDidDataUpdated方法调用hcTableViewDidDataUpdated
//
//