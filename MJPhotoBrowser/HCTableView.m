//
//  HCTableView.m
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "HCTableView.h"

@interface HCTableView ()

@property (nonatomic, strong) NSNumber * initialOffsetY;

@end

@implementation HCTableView

- (instancetype)init
{
    if (self = [super init]) {
        _refreshHeaderEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _refreshHeaderEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        _refreshHeaderEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _refreshHeaderEnabled = YES;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if (_refreshHeader == nil) {
        _initialOffsetY = [NSNumber numberWithFloat:self.contentOffset.y];
        
        _refreshHeader = [[HCRefreshView alloc] initInSuperview:self isFooter:NO];
        
        if (_refreshHeaderEnabled) {
            _refreshHeader.hidden = NO;
        } else {
            _refreshHeader.hidden = YES;
        }
    }
    
    if (_refreshFooter == nil) {
        _refreshFooter = [[HCRefreshView alloc] initInSuperview:self isFooter:YES];
        if (_refreshFooterEnabled) {
            _refreshFooter.hidden = NO;
        } else {
            _refreshFooter.hidden = YES;
        }
    }

}

- (void)setRefreshHeaderEnabled:(BOOL)refreshHeaderEnabled
{
    _refreshHeaderEnabled = refreshHeaderEnabled;
    if (_refreshHeaderEnabled) {
        _refreshHeader.hidden = NO;
    } else {
        _refreshHeader.hidden = YES;
    }
    _refreshHeader.state = HCRefreshViewStateNormal;
}

- (void)setRefreshFooterEnabled:(BOOL)refreshFooterEnabled
{
    _refreshFooterEnabled = refreshFooterEnabled;
    if (_refreshFooterEnabled) {
        _refreshFooter.hidden = NO;
    } else {
        _refreshFooter.hidden = YES;
    }
    _refreshFooter.state = HCRefreshViewStateNormal;
}

- (void)hcTableViewWillBeginDragging
{
    if (nil == _initialOffsetY) {
        _initialOffsetY = [NSNumber numberWithFloat:self.contentOffset.y];
    }
}

- (void)hcTableViewDidScroll
{
    if (HCRefreshViewStateRefresh == _refreshHeader.state
        || HCRefreshViewStateRefresh == _refreshFooter.state) {
        return;
    }
    
    CGFloat offsetY = self.contentOffset.y - [_initialOffsetY floatValue];
    if (_refreshHeaderEnabled && (offsetY <= -_refreshHeader.viewHeight)) {
        _refreshHeader.state = HCRefreshViewStatePull;
        return;
    }
    
    if (_refreshHeaderEnabled){
        _refreshHeader.state = HCRefreshViewStateNormal;
    }
    
    CGFloat upY = (self.contentSize.height > self.frame.size.height) ? (self.contentSize.height - self.frame.size.height + _refreshFooter.viewHeight / 2 - [_initialOffsetY floatValue]) : _refreshFooter.viewHeight / 2;
    
    if (_refreshFooterEnabled && offsetY >= upY) {
        _refreshFooter.state = HCRefreshViewStatePull;
        return;
    }
    
    if (_refreshFooterEnabled) {
        _refreshFooter.state = HCRefreshViewStateNormal;
    }
}

- (void)hcTableViewDidEndDragging
{
    if (HCRefreshViewStateRefresh == _refreshHeader.state
        || HCRefreshViewStateRefresh == _refreshFooter.state) {
        return;
    }
    
    CGFloat offsetY = self.contentOffset.y - [_initialOffsetY floatValue];
    if (_refreshHeaderEnabled && (offsetY <= -_refreshHeader.viewHeight)) {
        if ([self.hcRefreshViewDelegate respondsToSelector:@selector(hcRefreshViewDidPullDownToRefresh)]) {
            _refreshHeader.state = HCRefreshViewStateRefresh;
            [UIView animateWithDuration:0.2 animations:^{
                self.contentInset = UIEdgeInsetsMake(fabs([_initialOffsetY floatValue] - _refreshHeader.viewHeight), 0, 0, 0);
            }];
            [self.hcRefreshViewDelegate hcRefreshViewDidPullDownToRefresh];
        }
        return;
    }
    
    CGFloat upY = (self.contentSize.height > self.frame.size.height) ? (self.contentSize.height - self.frame.size.height + _refreshFooter.viewHeight / 2 - [_initialOffsetY floatValue]) : _refreshFooter.viewHeight / 2;
    
    if (_refreshFooterEnabled && offsetY >= upY) {
        if ([self.hcRefreshViewDelegate respondsToSelector:@selector(hcRefreshViewDidPullUpToLoad)]) {
            _refreshFooter.state = HCRefreshViewStateRefresh;
            [self.hcRefreshViewDelegate hcRefreshViewDidPullUpToLoad];
        }
        return;
    }
    
}

- (void)hcTableViewDidDataUpdated
{
    [self reloadData];
    
    if (_refreshHeaderEnabled && HCRefreshViewStateNormal != _refreshHeader.state) {
        _refreshHeader.state = HCRefreshViewStateNormal;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentInset = UIEdgeInsetsMake(fabs([_initialOffsetY floatValue]), 0, 0, 0);
        }];
    }
    
    if (_refreshFooterEnabled && HCRefreshViewStateNormal != _refreshFooter.state) {
        _refreshFooter.state = HCRefreshViewStateNormal;
    }
    
    
}

@end
