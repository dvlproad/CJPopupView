//
//  CJButton.h
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CJButtonImagePosition) {
    CJButtonImagePositionNone,
    CJButtonImagePositionLeft,
    CJButtonImagePositionRight,
};

@class CJButton;


typedef void(^CJButtonStateChangeCompleteBlock)(CJButton *CJButton);

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

//采用UIImage＋UILabel + 手势的组合实现起来
@interface CJButton : UIView {
    
}
@property (nonatomic, assign) CJButtonImagePosition imagePosition; /**< 图片的位置（必须设置,如果设为CJButtonImagePositionNone则不会添加图片） */

@property (nonatomic, copy) void (^tapAction)(CJButton *cjButton);

@property (nonatomic, assign) NSInteger index;  /**< 单选按钮的索引，在CJButtons里有用 */
@property (nonatomic, strong) IBOutlet UILabel *label; //当title字数多或者需多行时有用
@property (nonatomic, strong) IBOutlet UIImageView *imageView;//TODO:image改成button以便设置选中没选中时候的图片
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, strong) UIColor *textNormalColor;   /**< 单选按钮正常时的文字颜色 */
@property (nonatomic, strong) UIColor *textSelectedColor; /**< 单选按钮选中时的文字颜色 */

//TODO:
@property (nonatomic, strong) UIColor *backgroundNormalColor;  /**< 单选按钮正常时的背景颜色 */
@property (nonatomic, strong) UIColor *backgroundSelectedColor;/**< 单选按钮选中时的背景颜色 */

@property (nonatomic, copy) CJButtonStateChangeCompleteBlock stateChangeCompleteBlock; /**< 单选按钮(选中)状态改变后的block(可用来做一些图片的transform旋转等) */

@property (nonatomic, copy) NSString *title;    /**< 按钮上的文字 */

/**
 *  初始化方法
 */
- (void)cjButton_commonInit;

@end
