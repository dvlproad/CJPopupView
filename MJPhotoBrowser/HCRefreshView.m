//
//  HCRefreshView.m
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "HCRefreshView.h"
#import <Masonry/Masonry.h>

@interface HCRefreshView ()

@property (nonatomic) BOOL isFooter;

- (CGFloat)textLabelWidth:(NSString *)text;

@end

@implementation HCRefreshView

- (instancetype)initInSuperview:(UIView *)superview isFooter:(BOOL)isFooter
{
    if (self = [super init]) {
        _viewHeight = 50;
        _isFooter = isFooter;
        
        UIView * container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [container addSubview:self];

        if (isFooter) {
            if ([superview isKindOfClass:[UITableView class]]) {
                UITableView * tableView = (UITableView *)superview;
                [tableView setTableFooterView:container];
            } else {
                [superview addSubview:container];
            }
        } else {
            [superview addSubview:container];
        }
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_viewHeight);
            make.centerX.equalTo(superview.mas_centerX);
            if (isFooter) {
                make.top.mas_equalTo(0);
            } else {
                make.top.mas_equalTo(-_viewHeight);
            }
        }];
        
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
       // _imageView.image = [UIImage imageWithContentsOfFile:FilePathAtHCResBundle(@"HCRefreshArrow.png")];
        
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textColor = [UIColor grayColor];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped = YES;
        [self addSubview:_indicator];
        
        if (isFooter) {
            _imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            _textLabel.text = @"上拖加载";
        } else {
            _imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            _textLabel.text = @"下拉刷新";
        }
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_viewHeight - 10);
            make.height.mas_equalTo(_viewHeight - 10);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(5);
            make.right.equalTo(_textLabel.mas_left).with.offset(-5);
        }];

        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo([self textLabelWidth:_textLabel.text]);
            make.left.equalTo(_imageView.mas_right).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-5);
        }];
        
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_imageView);
        }];
    }
    
    return self;
}

- (CGFloat)textLabelWidth:(NSString *)text
{
    return [text sizeWithFont:_textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, _textLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping].width + 12;
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)setViewHeight:(CGFloat)viewHeight
{
    _viewHeight = viewHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_viewHeight);
        make.top.mas_equalTo(-_viewHeight);
    }];
    
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_viewHeight - 10);
        make.height.mas_equalTo(_viewHeight - 10);
    }];
}

- (void)setTextLabelText:(NSString *)text
{
    _textLabel.text = text;
    [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self textLabelWidth:text]);
    }];
}

- (void)setIsFooter:(BOOL)isFooter
{
    _isFooter = isFooter;
    if (isFooter) {
        _imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        [self setTextLabelText:@"上拖加载"];
    } else {
        _imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        [self setTextLabelText:@"下拉刷新"];
    }
}

- (void)setState:(HCRefreshViewState)state
{
    if (_state == state) {
        return;
    }
    _state = state;
    [UIView animateWithDuration:0.2 animations:^{
        switch (state) {
            case HCRefreshViewStateNormal:
            {
                _imageView.hidden = NO;
                [_indicator stopAnimating];
                if (_isFooter) {
                    _imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                    [self setTextLabelText:@"上拖加载"];
                } else {
                    _imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                    [self setTextLabelText:@"下拉刷新"];
                }
            }
                break;
                
            case HCRefreshViewStatePull:
            {
                if (_isFooter) {
                    _imageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                    [self setTextLabelText:@"释放加载数据"];
                } else {
                    _imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                    [self setTextLabelText:@"释放刷新数据"];
                }
            }
                break;
                
            case HCRefreshViewStateRefresh:
            {
                _imageView.hidden = YES;
                [_indicator startAnimating];
                [self setTextLabelText:@"呼哧哧，小美正屁颠屁颠赶来.."];
            }
                break;
                
            default:
                break;
        }
    }];
    
}
@end
