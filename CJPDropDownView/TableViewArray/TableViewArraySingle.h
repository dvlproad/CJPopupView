//
//  TableViewArraySingle.h
//  CJPDropDownViewDemo
//
//  Created by lichq on 9/8/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewArraySingle;
@protocol TableViewArraySingleDelegate <NSObject>

- (void)tv_ArraySingle:(TableViewArraySingle *)tv_ArraySingle didSelectText:(NSString *)text;
@end




@interface TableViewArraySingle : UIView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tv;
@property(nonatomic, strong) NSArray *datas;
@property(nonatomic, strong) id<TableViewArraySingleDelegate> delegate;

@end
