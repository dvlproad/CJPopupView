//
//  MyEqualCellSizeSetting.h
//  AllScrollViewDemo
//
//  Created by ciyouzen on 2017/9/11.
//  Copyright © 2017年 dvlproad. All rights reserved.
//
//  本类参考自UICollectionViewFlowLayout

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CJExtralItemSetting) {
    CJExtralItemSettingNone,       /**< 不添加额外item */
    CJExtralItemSettingLeading,    /**< 在头部增加一个(比如在头部增加一个“全部”或者“拍照”按钮) */
    CJExtralItemSettingTailing,    /**< 在尾部增加一个(比如在尾部增加一个“添加”按钮) */
};


/**
 *  我的集合视图的设置，包含Layout和DataSource部分
 */
@interface MyEqualCellSizeSetting : NSObject {
    
}
#pragma mark - Layout部分
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) UIEdgeInsets sectionInset;

//以下值必须二选一设置（默认cellWidthFromFixedWidth设置后，另外一个自动失效）
@property (nonatomic, assign) NSInteger cellWidthFromPerRowMaxShowCount; /**< 通过每行可显示的最多个数来设置每个cell的宽度*/
@property (nonatomic, assign) CGFloat cellWidthFromFixedWidth;   /**< 通过cell的固定宽度来设置每个cell的宽度 */

//可选设置的值，若不设置的话，以下值将采用默认值
@property (nonatomic, assign) CGFloat collectionViewCellHeight; /**< cell高,没设置的话等于其宽 */



#pragma mark - DataSource部分
//其他附加的可选设置的值，若不设置的话，以下值将采用默认值
@property (nonatomic, assign) CJExtralItemSetting extralItemSetting;/**< 额外cell的样式，(默认不添加） */
@property (nonatomic, assign) NSUInteger maxDataModelShowCount; /**< 集合视图最大显示的dataModel数目(默认NSIntegerMax即无限制) */


@end
