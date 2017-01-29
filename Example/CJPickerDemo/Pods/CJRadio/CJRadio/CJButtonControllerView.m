//
//  CJButtonControllerView.m
//  CJRadioDemo
//
//  Created by lichq on 14-11-5.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "CJButtonControllerView.h"

@interface CJButtonControllerView () <RadioButtonsDataSource, RadioButtonsDelegate, RadioComposeViewDataSource, RadioComposeViewDelegate> {
    BOOL isDelegateDoneInRadioButton; //避免点击单选按钮的时候，delegate执行两次
    
}
@property (nonatomic, strong) RadioButtons *sliderRadioButtons;
@property (nonatomic, strong) RadioComposeView *radioComposeView;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsHeightLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsLeftLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsRightLayoutConstraint;

@property (nonatomic, strong) NSLayoutConstraint *radioButtonsLeftViewWidthLayoutConstraint;
@property (nonatomic, strong) NSLayoutConstraint *radioButtonsRightViewWidthLayoutConstraint;

@end

@implementation CJButtonControllerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)commonInit {
    self.radioButtonsHeight = 0;
    
    /* Self的一些其他设置 */
    self.defaultSelectedIndex = 0;
    self.maxRadioButtonsShowViewCount = 3;
    
    /* 添加 RadioButtons */
    self.sliderRadioButtons = [[RadioButtons alloc] initWithFrame:CGRectZero];
//    self.sliderRadioButtons.dataSource = self; //放在reloadData中了
    self.sliderRadioButtons.delegate = self;
    [self addSubview:self.sliderRadioButtons];
    
    /* 添加 RadioControllers */
    self.radioComposeView = [[RadioComposeView alloc] initWithFrame:CGRectZero];
//    self.radioComposeView.dataSource = self;  //放在reloadData中了
    self.radioComposeView.delegate = self;
    [self addSubview:self.radioComposeView];
    
    //设置约束
    [self setupConstraints];
}

#pragma mark - 设置RadioButtons的附加设置
- (void)setShowBottomLineView:(BOOL)showBottomLineView {
    _showBottomLineView = showBottomLineView;
    
    self.sliderRadioButtons.showBottomLineView = showBottomLineView;
}

- (void)setBottomLineImage:(UIImage *)bottomLineImage {
    _bottomLineImage = bottomLineImage;
    
    self.sliderRadioButtons.bottomLineImage = bottomLineImage;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    
    self.sliderRadioButtons.bottomLineColor = bottomLineColor;
}

- (void)setBottomLineViewHeight:(CGFloat)bottomLineViewHeight {
    _bottomLineViewHeight = bottomLineViewHeight;
    
    self.sliderRadioButtons.bottomLineViewHeight = bottomLineViewHeight;
}

#pragma mark - reloadData
- (void)reloadData {
    self.radioButtonsHeightLayoutConstraint.constant = self.radioButtonsHeight;
    self.sliderRadioButtons.dataSource = self;
    self.radioComposeView.dataSource = self;
}


/** 完整的描述请参见文件头部 */
- (void)scollToCurrentSelectedViewWithAnimated:(BOOL)animated {
    [self.sliderRadioButtons scollToCurrentSelectedViewWithAnimated:animated];
    [self.radioComposeView scrollToCenterViewWithAnimate:animated];
}


/** 完整的描述请参见文件头部 */
- (void)addLeftArrowImage:(UIImage *)leftArrowImage rightArrowImage:(UIImage *)rightArrowImage withArrowImageWidth:(CGFloat)arrowImageWidth {
    [self.sliderRadioButtons addLeftArrowImage:leftArrowImage
                               rightArrowImage:rightArrowImage
                           withArrowImageWidth:arrowImageWidth];
}

/** 完整的描述请参见文件头部 */
- (void)addRadioButtonsLeftView:(UIView *)radioButtonsLeftView withWidth:(CGFloat)radioButtonsLeftViewWidth {
    self.radioButtonsLeftLayoutConstraint.constant = radioButtonsLeftViewWidth;
    
    [self addSubview:radioButtonsLeftView];
    radioButtonsLeftView.translatesAutoresizingMaskIntoConstraints = NO;
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    //bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    //left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    //width
    self.radioButtonsLeftViewWidthLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:radioButtonsLeftView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:radioButtonsLeftViewWidth];
    [self addConstraint:self.radioButtonsLeftViewWidthLayoutConstraint];
}

/** 完整的描述请参见文件头部 */
- (void)addRadioButtonsRightView:(UIView *)radioButtonsRightView withWidth:(CGFloat)radioButtonsRightViewWidth {
    self.radioButtonsRightLayoutConstraint.constant = -radioButtonsRightViewWidth;
    
    [self addSubview:radioButtonsRightView];
    radioButtonsRightView.translatesAutoresizingMaskIntoConstraints = NO;
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    //bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    //right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    //width
    self.radioButtonsRightViewWidthLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:radioButtonsRightView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:radioButtonsRightViewWidth];
    [self addConstraint:self.radioButtonsRightViewWidthLayoutConstraint];
}

#pragma mark - RadioButtonsDataSource
- (NSInteger)cj_defaultShowIndexInRadioButtons:(RadioButtons *)radioButtons {
    return self.defaultSelectedIndex;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(RadioButtons *)radioButtons {
    return self.titles.count;
}

- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    CGFloat totalWidth = CGRectGetWidth(radioButtons.frame);
    NSInteger showViewCount = MIN(self.titles.count, self.maxRadioButtonsShowViewCount);
    CGFloat sectionWidth = totalWidth/showViewCount;
    
    sectionWidth = ceilf(sectionWidth); //重点注意：当使用除法计算width时候，为了避免计算出来的值受除后，余数太多，除不尽(eg:102.66666666666667)，而造成的之后在通过左右箭头点击来寻找”要找的按钮“的时候，计算出现问题（”要找的按钮“需与“左右侧箭头的最左最右侧值”进行精确的比较），所以这里我们需要一个整数值，故我们这边选择向上取整。
    
    if (index == self.titles.count-1) {
        CGFloat hasUseWidth = (showViewCount-1) * sectionWidth;
        sectionWidth = totalWidth - hasUseWidth; //确保加起来的width不变
    }
    
    return sectionWidth;
}

- (RadioButton *)cj_radioButtons:(RadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    RadioButton *radioButton = [self.dataSource cj_buttonControllerView:self cellForComponentAtIndex:index];
    
    NSString *title = [self.titles objectAtIndex:index];
    [radioButton setTitle:title];
    
    return radioButton;
}


#pragma mark - RadioComposeViewDataSource
- (NSInteger)cj_defaultShowIndexInRadioComposeView:(RadioComposeView *)radioComposeView {
    return self.defaultSelectedIndex;
}

- (NSArray<UIView *> *)cj_radioViewsInRadioComposeView:(RadioComposeView *)radioComposeView {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIViewController *vc in self.componentViewControllers) {
        [views addObject:vc.view];
        [self.componentViewParentViewController addChildViewController:vc];//记得添加进去
    }
    
    return views;
}


#pragma mark - RadioButtonsDelegate & RadioComposeViewDelegate
- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    isDelegateDoneInRadioButton = YES;
    //NSLog(@"index_old = %ld, index_cur = %ld", index_old, index_cur);
    [self.radioComposeView cj_selectComponentAtIndex:index_cur animated:YES];
    self.currentSelectedIndex = index_cur;
    
    [self didChangeToIndex:index_cur];
}

- (void)cj_radioComposeView:(RadioComposeView *)radioComposeView didChangeToIndex:(NSInteger)index {
    if (isDelegateDoneInRadioButton == NO) {
        [self.sliderRadioButtons cj_selectComponentAtIndex:index animated:YES];
        self.currentSelectedIndex  = index;
        
        [self didChangeToIndex:index];
    }
    isDelegateDoneInRadioButton = NO;
}


- (void)didChangeToIndex:(NSInteger)index { //变化之后，常用来做一些比如“强制刷新”的操作
    if (self.delegate && [self.delegate respondsToSelector:@selector(cj_buttonControllerView:didChangeToIndex:)]) {
        [self.delegate cj_buttonControllerView:self didChangeToIndex:index];
    }
}


#pragma mark - setupConstraints
- (void)setupConstraints {
    [self setupConstraintsForRadioButtons];
    [self setupConstraintsForRadioComposeView];
}

- (void)setupConstraintsForRadioButtons {
    self.sliderRadioButtons.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    self.radioButtonsLeftLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    [self addConstraint:self.radioButtonsLeftLayoutConstraint];
    //right
    self.radioButtonsRightLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    [self addConstraint:self.radioButtonsRightLayoutConstraint];
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    //height
    self.radioButtonsHeightLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:self.sliderRadioButtons
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:self.radioButtonsHeight];
    [self addConstraint:self.radioButtonsHeightLayoutConstraint];
}

- (void)setupConstraintsForRadioComposeView {
    self.radioComposeView.translatesAutoresizingMaskIntoConstraints = NO;
    //left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    //right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    //top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.sliderRadioButtons
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    //bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.radioComposeView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
}


@end
