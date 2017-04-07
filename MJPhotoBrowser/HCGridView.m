//
//  HCGridView.m
//   ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "HCGridView.h"
#import <Masonry/Masonry.h>

@implementation HCGridView

- (void)dealloc
{
    _girdItems = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        _itemHeight = 60;
        _margin = 10;
        _numOfColumns = 4;
    }
    return self;
}

- (void)setNumOfColumns:(NSUInteger)numOfColumns
{
    if (numOfColumns == 0) {
        _numOfColumns = 1;
    } else {
        _numOfColumns = numOfColumns;
    }
}

- (CGFloat)viewHeight
{
    int numOfRows = (int)_girdItems.count / _numOfColumns;
    if (_girdItems.count % _numOfColumns != 0) {
        numOfRows++;
    }
    
    return (_itemHeight + _margin) * numOfRows + _margin;
}

- (void)reloadData
{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.00 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        for (UIView * view in weakSelf.subviews) {
            [view removeFromSuperview];
        }
        
        int numOfRows = (int)_girdItems.count / _numOfColumns;
        if (_girdItems.count % _numOfColumns != 0) {
            numOfRows++;
        }
        
        NSMutableArray * drawViews = [[NSMutableArray alloc] initWithArray:_girdItems];
        
        for (int i = (int)_girdItems.count; i < numOfRows * _numOfColumns;  i++) {
            [drawViews addObject:[[UIView alloc] init]];
        }
        
        UIView * preview = nil;
        
        for (int i = 0 ; i < drawViews.count; i++) {
            UIView * subview = [[UIView alloc] init];
            subview.backgroundColor = [UIColor clearColor];
            [self addSubview:subview];
            [subview mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(_margin);
                } else if (i % _numOfColumns == 0){
                    make.top.mas_equalTo(preview.mas_bottom).with.offset(_margin);
                } else {
                    make.top.equalTo(preview);
                }
                
                if (i % _numOfColumns == 0) {
                    make.left.mas_equalTo(_margin);
                } else {
                    make.left.mas_equalTo(preview.mas_right).with.offset(_margin);
                }
                
                make.height.mas_equalTo(_itemHeight);
                
                if (i % _numOfColumns == _numOfColumns - 1) {
                    make.right.mas_equalTo(-_margin);
                }
                
                if (preview != nil) {
                    make.width.equalTo(preview);
                }
                
            }];
            
            preview = subview;
            
            UIView * item = drawViews[i];
            [subview addSubview:item];
            
            [item mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(subview);
            }];
        }
        
        preview = nil;
    });
    

    
    
}

@end
