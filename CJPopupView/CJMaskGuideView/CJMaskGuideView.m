//
//  CJMaskGuideView.m
//  CJPopup
//
//  Created by 李超前 on 2016/06/15.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJMaskGuideView.h"
#import "UIImage+Mask.h"

@interface CJMaskGuideView ()
/*
@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) UIView *bottomMaskView;
@property (nonatomic, strong) UIView *leftMaskView;
@property (nonatomic, strong) UIView *rightMaskView;
*/

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) UIView *maskBg;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, weak) UIButton *maskButton;


@property (nonatomic, assign) BOOL canDismissByTouchBackground;

@end

@implementation CJMaskGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /*
        [self addSubview:self.topMaskView];
        [self addSubview:self.bottomMaskView];
        [self addSubview:self.leftMaskView];
        [self addSubview:self.rightMaskView];
        */
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        
        [self addSubview:self.okButton];
        [self addSubview:self.maskImageView];
        [self addSubview:self.arrowImageView];
        [self addSubview:self.tipsLabel];
    }
    return self;
}

- (void)setDataSource:(id<CJMaskGuideViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    if (dataSource && [dataSource respondsToSelector:@selector(cj_maskGuideView:okButton:)]) {
        [dataSource cj_maskGuideView:self okButton:self.okButton];
    }
    
    if (dataSource && [_dataSource respondsToSelector:@selector(cj_maskGuideView:arrowImageView:)]) {
        [dataSource cj_maskGuideView:self arrowImageView:self.arrowImageView];
    }
    
    if (dataSource && [_dataSource respondsToSelector:@selector(cj_maskGuideView:tipsLabel:)]) {
        [dataSource cj_maskGuideView:self tipsLabel:self.tipsLabel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = _parentView.bounds;
    _maskBg.frame = self.bounds;
    
    CGRect maskImageViewFrame = [_maskButton.superview convertRect:_maskButton.frame toView:self];
    _maskImageView.frame = maskImageViewFrame;
    
    //_maskImageView.frame = CGRectMake(0, 0, 36, 36);
    //_maskImageView.center = [_maskBtn.superview convertPoint:_maskBtn.center toView:self];
    
    /*
    CGRect topMaskViewFrame = _topMaskView.frame;
    topMaskViewFrame.origin.x = 0;
    topMaskViewFrame.origin.y = 0;
    topMaskViewFrame.size.height = CGRectGetMinY(_maskImageView.frame);
    topMaskViewFrame.size.width = CGRectGetWidth(self.frame);
    _topMaskView.frame = topMaskViewFrame;
    
    CGRect bottomMaskViewFrame = _bottomMaskView.frame;
    bottomMaskViewFrame.origin.x = 0;
    bottomMaskViewFrame.origin.y = CGRectGetMaxY(_maskImageView.frame);
    bottomMaskViewFrame.size.width = CGRectGetWidth(self.frame);
    bottomMaskViewFrame.size.height = CGRectGetHeight(self.frame) - CGRectGetMaxY(_maskImageView.frame);
    _bottomMaskView.frame = bottomMaskViewFrame;
    
    CGRect leftMaskViewFrame = _leftMaskView.frame;
    leftMaskViewFrame.origin.x = 0;
    leftMaskViewFrame.origin.y = CGRectGetMinY(_maskImageView.frame);
    leftMaskViewFrame.size.width = CGRectGetMinX(_maskImageView.frame);
    leftMaskViewFrame.size.height = CGRectGetHeight(_maskImageView.frame);
    _leftMaskView.frame = leftMaskViewFrame;
    
    CGRect rightMaskViewFrame = _rightMaskView.frame;
    rightMaskViewFrame.origin.x = CGRectGetMaxX(_maskImageView.frame);
    rightMaskViewFrame.origin.y = CGRectGetMinY(_maskImageView.frame);
    rightMaskViewFrame.size.width = CGRectGetWidth(self.frame) - CGRectGetMaxX(_maskImageView.frame);
    rightMaskViewFrame.size.height = CGRectGetHeight(_maskImageView.frame);
    _rightMaskView.frame = rightMaskViewFrame;
    */
    
    if (self.cjMaskGuideViewFrameSettingBlock) {
        self.cjMaskGuideViewFrameSettingBlock(_maskImageView, _arrowImageView, _tipsLabel, _okButton);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.canDismissByTouchBackground) {
        [self tapBackground];
    }
}

- (void)showInView:(UIView *)view maskBtn:(UIButton *)btn canDismissByTouchBackground:(BOOL)canDismissByTouchBackground {
    self.parentView = view;
    self.maskButton = btn;
    self.canDismissByTouchBackground = canDismissByTouchBackground;
    
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:nil];
}

#pragma mark - tap事件
- (void)tapBackground {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cj_maskGuideView:clickMaskButton:)]) {
            [self.delegate cj_maskGuideViewTapBackground:self];
        }
    }];
}

#pragma mark - 按钮的点击
- (IBAction)clickOKButton:(UIButton *)okButton {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cj_maskGuideView:clickOKButton:)]) {
            [self.delegate cj_maskGuideView:self clickOKButton:okButton];
        }
    }];
}

- (IBAction)clickMaskButton:(UIButton *)maskButton {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cj_maskGuideView:clickMaskButton:)]) {
            [self.delegate cj_maskGuideView:self clickMaskButton:maskButton];
        }
    }];
}

#pragma mark - getter and setter

- (UIView *)maskBg {
    if (!_maskBg) {
        UIView *view = [[UIView alloc] init];
        _maskBg = view;
    }
    return _maskBg;
}

- (UIButton *)okButton {
    if (!_okButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[btn setImage:[UIImage imageNamed:@"CJMaskGuide_ButtonOK"] forState:UIControlStateNormal];
        [btn setTitle:@"朕知道了" forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"CJMaskGuide_ButtonOKBG"]  forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(clickOKButton:) forControlEvents:UIControlEventTouchUpInside];
        _okButton = btn;
    }
    return _okButton;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        UIImage *image = [UIImage imageNamed:@"CJMaskGuide_ButtonMask_white"];
        image = [image maskImage:[[UIColor blackColor] colorWithAlphaComponent:0.71]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMaskButton:)];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:tapGR];
        
        _maskImageView = imageView;
    }
    return _maskImageView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CJMaskGuide_ArrowUp2"]];//CJMaskGuide_ArrowDown
        _arrowImageView = imageView;
    }
    return _arrowImageView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.numberOfLines = 0;
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:20];
        [tipsLabel sizeToFit];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

/*
- (UIView *)topMaskView {
    if (!_topMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        view.backgroundColor = [UIColor magentaColor];
        _topMaskView = view;
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    if (!_bottomMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        view.backgroundColor = [UIColor purpleColor];
        _bottomMaskView = view;
    }
    return _bottomMaskView;
}

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        view.backgroundColor = [UIColor redColor];
        _leftMaskView = view;
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    if (!_rightMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        view.backgroundColor = [UIColor greenColor];
        _rightMaskView = view;
    }
    return _rightMaskView;
}
*/

@end
