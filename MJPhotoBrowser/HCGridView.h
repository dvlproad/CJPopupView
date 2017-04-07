//
//  HCGridView.h
//   ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCGridView : UIView

@property (nonatomic, strong) NSArray * girdItems;
@property (nonatomic, assign) NSUInteger numOfColumns;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat margin;

- (void)reloadData;

- (CGFloat)viewHeight;

@end
