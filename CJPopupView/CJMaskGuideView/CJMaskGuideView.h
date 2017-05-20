//
//  CJMaskGuideView.h
//  CJPopup
//
//  Created by 李超前 on 2016/06/15.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CJMaskGuideView;
@protocol CJMaskGuideViewDataSource <NSObject>

- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView okButton:(UIButton *)okButton;
- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView arrowImageView:(UIImageView *)arrowImageView;
- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView tipsLabel:(UILabel *)tipsLabel;

@end

@protocol CJMaskGuideViewDelegate <NSObject>

@optional
- (void)cj_addOtherSubViewToMaskGuideView:(CJMaskGuideView *)maskGuidView;

- (void)cj_maskGuideViewTapBackground:(CJMaskGuideView *)maskGuidView;

- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView clickOKButton:(UIButton *)okButton;

- (void)cj_maskGuideView:(CJMaskGuideView *)maskGuidView clickMaskButton:(UIButton *)maskButton;


@end


typedef void(^CJMaskGuideViewFrameSettingBlock)(UIView *maskImageView, UIView *arrowImageView, UILabel *tipsLabel, UIButton *okButton);

@interface CJMaskGuideView : UIView {
    
}

@property (nonatomic, copy) CJMaskGuideViewFrameSettingBlock cjMaskGuideViewFrameSettingBlock;

@property (nonatomic, weak) id <CJMaskGuideViewDataSource> dataSource;
@property (nonatomic, weak) id <CJMaskGuideViewDelegate> delegate;

- (void)showInView:(UIView *)view maskBtn:(UIButton *)btn canDismissByTouchBackground:(BOOL)canDismissByTouchBackground;

@end
