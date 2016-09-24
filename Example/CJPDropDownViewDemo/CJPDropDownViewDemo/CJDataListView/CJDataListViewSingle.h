//
//  CJDataListViewSingle.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJDataListViewSingle;
@protocol CJDataListViewSingleDelegate <NSObject>

- (void)cj_dataListViewSingle:(CJDataListViewSingle *)dataListViewSingle didSelectText:(NSString *)text;

@end




@interface CJDataListViewSingle : UIView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tv;
@property(nonatomic, strong) NSArray *datas;
@property(nonatomic, strong) id<CJDataListViewSingleDelegate> delegate;

@end
