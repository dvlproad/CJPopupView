//
//  MyButton.h
//  CJRadioDemo
//
//  Created by ciyouzen on 14-11-5.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>


//参考：自定义UIButton http://blog.csdn.net/feisongfeiqin/article/details/50041003
typedef NS_ENUM(NSUInteger, MyButtonImagePosition) {
    MyButtonImagePositionNone,
    MyButtonImagePositionLeft,
    MyButtonImagePositionRight,
    MyButtonImagePositionTop,
    MyButtonImagePositionBottom
};


@interface MyButton : UIButton

@property (nonatomic, assign) MyButtonImagePosition imagePosition;

@end
