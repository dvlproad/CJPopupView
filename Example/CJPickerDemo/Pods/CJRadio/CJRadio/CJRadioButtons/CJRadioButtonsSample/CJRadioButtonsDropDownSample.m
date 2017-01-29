//
//  CJRadioButtonsDropDownSample.m
//  CJRadioDemo
//
//  Created by lichq on 14-11-5.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "CJRadioButtonsDropDownSample.h"
#import <CJPopupAction/UIView+CJShowExtendView.h>

@interface CJRadioButtonsDropDownSample () <RadioButtonsDataSource, RadioButtonsDelegate>

@property (nonatomic, strong, readonly) UIImage *dropDownImage;    /**< 箭头图片 */
@property (nonatomic, strong, readonly) UIView *popupSuperview; /**< 弹出到哪个视图里 */
@property (nonatomic, assign, readonly) CJRadioButtonsDropDownType dropDownUnderType;

@end

@implementation CJRadioButtonsDropDownSample

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self CJRadioButtonsDropDownSample_commonInit];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self CJRadioButtonsDropDownSample_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self CJRadioButtonsDropDownSample_commonInit];
    }
    return self;
}


- (void)CJRadioButtonsDropDownSample_commonInit {
    self.hideSeparateLine = NO;
}

/** 完整的描述请参见文件头部 */
- (void)setupWithTitles:(NSArray *)titles
          dropDownImage:(UIImage *)dropDownImage
         popupSuperview:(UIView *)popupSuperview
      dropDownUnderType:(CJRadioButtonsDropDownType)dropDownUnderType
{
    _titles = titles;
    _dropDownImage = dropDownImage;
    _popupSuperview = popupSuperview;
    _dropDownUnderType = dropDownUnderType;
    self.dataSource = self;
    self.delegate = self;
}


#pragma mark - RadioButtonsDataSource
- (NSInteger)cj_defaultShowIndexInRadioButtons:(RadioButtons *)radioButtons {
    return -1;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(RadioButtons *)radioButtons {
    return self.titles.count;
}

- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    CGFloat totalWidth = CGRectGetWidth(radioButtons.frame);
    NSInteger showViewCount = self.titles.count;
    CGFloat sectionWidth = totalWidth/showViewCount;
    
    sectionWidth = ceilf(sectionWidth);
    
    if (index == self.titles.count-1) {
        CGFloat hasUseWidth = (showViewCount-1) * sectionWidth;
        sectionWidth = totalWidth - hasUseWidth; //确保加起来的width不变
    }
    
    
    return sectionWidth;
}

- (RadioButton *)cj_radioButtons:(RadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    RadioButton *radioButton = [[RadioButton alloc] init];
    
    radioButton.imageView.image = self.dropDownImage;
    radioButton.stateChangeCompleteBlock = ^(RadioButton *radioButton) {
        [UIView animateWithDuration:0.3 animations:^{
            radioButton.imageView.transform = CGAffineTransformRotate(radioButton.imageView.transform, DEGREES_TO_RADIANS(180));
        }];
    };
    
    radioButton.backgroundColor = [UIColor colorWithRed:105/255.0 green:193/255.0 blue:243/255.0 alpha:1]; //#69C1F3
    radioButton.textNormalColor = [UIColor blackColor];
    radioButton.textSelectedColor = [UIColor whiteColor];
    
    
    radioButton.title = [self.titles objectAtIndex:index];
    
    return radioButton;
}


#pragma mark - RadioButtonsDelegate
- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    //NSLog(@"index_old = %zd, index_cur = %zd", index_old, index_cur);
    
    if (self.radioButtonsPopupSampleDataSource && [self.radioButtonsPopupSampleDataSource respondsToSelector:@selector(cj_RadioButtonsPopupSample:viewForButtonIndex:)]) {
        
        if (index_old != -1) {
            if (index_cur == index_old) {
                [radioButtons cj_hideExtendViewAnimated:YES];
                [radioButtons changeCurrentRadioButtonState];
                [radioButtons setSelectedNone];
                return;
            }else{
                [radioButtons cj_hideExtendViewAnimated:NO];
            }
        }
        
        
        UIView *popupView = [self.radioButtonsPopupSampleDataSource cj_RadioButtonsPopupSample:self viewForButtonIndex:index_cur];
        UIView *popupSuperview = self.popupSuperview;
        
        UIView *accordingView = nil;
        if (self.dropDownUnderType == CJRadioButtonsDropDownTypeUnderCurrent) {
            accordingView = [radioButtons.radioButtons objectAtIndex:index_cur];
        } else {
            accordingView = radioButtons;
        }
        
        
        void(^showComplete)(NSInteger index_cur) = ^(NSInteger index_cur) {
            //NSLog(@"%ld.显示完成", index_cur);
            //[radioButtons setCjPopupViewShowing:YES];
        };
        
        void(^tapBlankComplete)(NSInteger index_cur) = ^(NSInteger index_cur) {
            //NSLog(@"%ld.点击背景完成", index_cur);
            [radioButtons changeCurrentRadioButtonState];
            [radioButtons setSelectedNone];
        };
        
        
        [radioButtons cj_showExtendView:popupView inView:popupSuperview locationAccordingView:accordingView relativePosition:CJPopupViewPositionUnder showComplete:^{
            showComplete(index_cur);
            
        } tapBlankComplete:^{
            tapBlankComplete(index_cur);
        }];
    }
}

@end
