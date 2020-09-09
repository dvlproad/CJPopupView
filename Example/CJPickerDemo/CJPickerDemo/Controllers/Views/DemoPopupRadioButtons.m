//
//  DemoPopupRadioButtons.m
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import "DemoPopupRadioButtons.h"

@interface DemoPopupRadioButtons () <CJRadioButtonsDataSource, CJRadioButtonsDelegate>

@property (nonatomic, strong, readonly) UIImage *dropDownImage;    /**< 箭头图片 */
@property (nonatomic, strong, readonly) UIView *popupSuperview; /**< 弹出到哪个视图里 */
@property (nonatomic, assign, readonly) CJRadioButtonsPopupType popupType;

@end

@implementation DemoPopupRadioButtons

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self CJRadioButtonsPopupSample_commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self CJRadioButtonsPopupSample_commonInit];
    }
    return self;
}


- (void)CJRadioButtonsPopupSample_commonInit {
    self.hideSeparateLine = NO;
}

/** 完整的描述请参见文件头部 */
- (void)setupWithTitles:(NSArray *)titles
          dropDownImage:(UIImage *)dropDownImage
         popupSuperview:(UIView *)popupSuperview
              popupType:(CJRadioButtonsPopupType)popupType
{
    _titles = titles;
    _dropDownImage = dropDownImage;
    _popupSuperview = popupSuperview;
    _popupType = popupType;
    self.dataSource = self;
    self.delegate = self;
}


#pragma mark - CJRadioButtonsDataSource
- (NSInteger)cj_defaultShowIndexInRadioButtons:(CJRadioButtons *)radioButtons {
    return -1;
}

- (NSInteger)cj_numberOfComponentsInRadioButtons:(CJRadioButtons *)radioButtons {
    return self.titles.count;
}

- (CGFloat)cj_radioButtons:(CJRadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
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

- (CJRadioButton *)cj_radioButtons:(CJRadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    CJRadioButton *radioButton = [[CJRadioButton alloc] init];
    radioButton.imagePosition = CJButtonImagePositionRight;
    
    radioButton.imageView.image = self.dropDownImage;
    radioButton.stateChangeCompleteBlock = ^(CJRadioButton *radioButton) {
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


#pragma mark - CJRadioButtonsDelegate
- (void)cj_radioButtons:(CJRadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
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
        
        
        void(^showComplete)(NSInteger index_cur) = ^(NSInteger index_cur) {
            //NSLog(@"%ld.显示完成", index_cur);
            //[radioButtons setCjPopupViewShowing:YES];
        };
        
        void(^tapBlankComplete)(NSInteger index_cur) = ^(NSInteger index_cur) {
            //NSLog(@"%ld.点击背景完成", index_cur);
            [radioButtons changeCurrentRadioButtonState];
            [radioButtons setSelectedNone];
        };
        
        UIView *popupView = [self.radioButtonsPopupSampleDataSource cj_RadioButtonsPopupSample:self viewForButtonIndex:index_cur];
        popupView.clipsToBounds = YES;
        
        
        switch (self.popupType) {
            case CJRadioButtonsPopupTypeUnderAll: {
                UIView *popupSuperview = self.popupSuperview;
                UIView *accordingView = radioButtons;
                
                UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
                [radioButtons cj_showExtendView:popupView inView:popupSuperview locationAccordingView:accordingView relativePosition:CJPopupViewPositionBelow blankBGColor:blankBGColor showComplete:^{
                    showComplete(index_cur);
                    
                } tapBlankComplete:^{
                    tapBlankComplete(index_cur);
                }];
                
                break;
            }
            case CJRadioButtonsPopupTypeUnderCurrent: {
                UIView *popupSuperview = self.popupSuperview;
                UIView *accordingView = [radioButtons.radioButtons objectAtIndex:index_cur];
                
                UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
                [radioButtons cj_showExtendView:popupView inView:popupSuperview locationAccordingView:accordingView relativePosition:CJPopupViewPositionBelow blankBGColor:blankBGColor showComplete:^{
                    showComplete(index_cur);
                    
                } tapBlankComplete:^{
                    tapBlankComplete(index_cur);
                }];
                
                break;
            }
            case CJRadioButtonsPopupTypeWindowBottom: {
                CGFloat popupViewHeight = CGRectGetHeight(popupView.frame);
                
                UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
                [popupView cj_popupInBottomWindow:CJAnimationTypeNormal withHeight:popupViewHeight edgeInsets:UIEdgeInsetsZero blankBGColor:blankBGColor showComplete:^{
                    showComplete(index_cur);
                } tapBlankComplete:^{
                    tapBlankComplete(index_cur);
                    [popupView cj_hidePopupView];
                }];
                break;
            }
            default:
                break;
        }
        
    }
}

@end
