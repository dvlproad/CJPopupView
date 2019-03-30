//
//  CJEqualSizeSettingModel.h
//  CJRadioDemo
//
//  Created by ciyouzen on 2017/9/27.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CJEqualSizeSettingModel : NSObject {
    
}
@property (nonatomic, assign) NSInteger defaultSelectedIndex;   /**< 初始默认选中第几个按钮 */

//@property (nonatomic, assign) NSInteger maxButtonShowCount; /**< 显示区域显示的个数超过多少就开始滑动 */
//以下值必须二选一设置（默认cellWidthFromFixedWidth设置后，另外一个自动失效）
@property (nonatomic, assign) NSInteger cellWidthFromPerRowMaxShowCount; /**< 通过每行可显示的最多个数来设置每个cell的宽度*/
@property (nonatomic, assign) CGFloat cellWidthFromFixedWidth;   /**< 通过cell的固定宽度来设置每个cell的宽度 */

@end
