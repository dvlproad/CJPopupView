//
//  HCRefreshView.h
//  下拉刷新头视图
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

// 视图状态
typedef NS_ENUM(NSUInteger, HCRefreshViewState)
{
    HCRefreshViewStateNormal = 201,  // 正常
    HCRefreshViewStatePull,          // 拖动
    HCRefreshViewStateRefresh        // 加载
};

@protocol HCRefreshViewDelegate <NSObject>

@required
// 数据加载结束后，请调用此方法刷新，如果有需要执行额外事物，请在子类中实现此方法，并且加上[super hcRefreshViewDidDataUpdated]调用父类
- (void)hcRefreshViewDidDataUpdated;

// 视图进入下拉刷新状态时的执行事件 请在子类中实现此方法
- (void)hcRefreshViewDidPullDownToRefresh;

@optional
// 视图进入上拖状态时的执行事件 请在子类中实现此方法
- (void)hcRefreshViewDidPullUpToLoad;

@end

@interface HCRefreshView : UIView

@property (nonatomic) CGFloat viewHeight;  // 视图高度，默认50
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UIActivityIndicatorView * indicator;
@property (nonatomic) HCRefreshViewState state;

// 初始化函数，传入父视图，会自动调用[superview addSubView:]方法将视图添加
- (instancetype)initInSuperview:(UIView *)superview isFooter:(BOOL)isFooter;

// 不要直接使用textLabel.text来改变文本，否则约束不会刷新
- (void)setTextLabelText:(NSString *)text;

@end
