//
//  MyEqualCellSizeCollectionView.h
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/4/10.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UICollectionViewCell* (^CJConfigureCollectionViewCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void (^CJDidTapCollectionViewItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath); /**< 包括 didSelectItemAtIndexPath 和didDeselectItemAtIndexPath */

typedef NS_ENUM(NSUInteger, CJExtralItemSetting) {
    CJExtralItemSettingNone,       /**< 不添加额外item */
    CJExtralItemSettingLeading,    /**< 在头部增加一个(比如在头部增加一个“全部”或者“拍照”按钮) */
    CJExtralItemSettingTailing,    /**< 在尾部增加一个(比如在尾部增加一个“添加”按钮) */
};


///一个只有一个分区且分区中的每个cell大小相等的集合视图(cell的大小可通过方法①设置cell的固定大小和方法②通过设置每行最大显示的cell个数来得到)(采用常用的init...方法后，即可初始化完成)
@interface MyEqualCellSizeCollectionView : UICollectionView {
    
}
//必须设置的值
@property (nonatomic, assign) NSUInteger currentDataModelCount; /**< 数据源的个数 */

//以下值必须二选一设置（默认cellWidthFromFixedWidth设置后，另外一个自动失效）
@property (nonatomic, assign) NSInteger cellWidthFromPerRowMaxShowCount; /**< 通过每行可显示的最多个数来设置每个cell的宽度*/
@property (nonatomic, assign) CGFloat cellWidthFromFixedWidth;   /**< 通过cell的固定宽度来设置每个cell的宽度 */


//可选设置的值，若不设置的话，以下值将采用默认值
@property (nonatomic, assign) CGFloat collectionViewCellHeight; /**< cell高,没设置的话等于其宽 */
@property (nonatomic, assign) CJExtralItemSetting extralItemSetting;/**< 额外cell的样式，(默认不添加） */
@property (nonatomic, assign) NSUInteger maxDataModelCount; /**< 默认NSIntegerMax即无限制 */ //maxDataModelShowCount


//单选和reloadData这两种情况下需要使用的变量
@property (nonatomic, strong) NSArray<NSIndexPath *> *currentSelectedIndexPaths;    /**< 当前已选中的所有indexPaths（虽然选中的item,被移动到屏幕外，系统的indexPathsForSelectedItems不会变；但是当执行reloadData的话，就会导致系统的所有的indexPathsForSelectedItems为空，所以为了保存之前选中的indexPathsForSelectedItems，这里声明这个currentSelectedIndexPaths属性） */

- (void)commonInit;

///必须
/**
 *  init之后，必须调用的configure方法
 *
 *  @param configureDataCellBlock   设置DataCell的方法
 *  @param configureExtraCellBlock  设置ExtraCell的方法
 */
- (void)configureDataCellBlock:(CJConfigureCollectionViewCellBlock)configureDataCellBlock
       configureExtraCellBlock:(CJConfigureCollectionViewCellBlock)configureExtraCellBlock;

/**
 *  设置点击Item要执行的方法
 *
 *  @param didTapDataItemBlock   点击DataCell要执行的方法
 *  @param didTapExtraItemBlock  点击ExtraCell要执行的方法
 */
- (void)didTapDataItemBlock:(CJDidTapCollectionViewItemBlock)didTapDataItemBlock
       didTapExtraItemBlock:(CJDidTapCollectionViewItemBlock)didTapExtraItemBlock;

/**
 *  获取当前collectionView的高度
 *
 *  @param dataModels               要传入的collectionView的数据源
 *  @param collectionViewWidth      要传入的collectionView的宽度
 *  @param cellHeight               cellHeight
 *  @param cellFixedWidth           用于设置cellWidth的值
 *  @param perRowMaxShowCount       用于设置cellWidth的值
 *  @param showExtraItem            要传入的collectionView的是否显示额外item的值
 *  @param maxDataModelShowCount    要传入的collectionView的最大显示个数
 */
+ (CGFloat)heightForDataModels:(NSArray *)dataModels
         byCollectionViewWidth:(CGFloat)collectionViewWidth
                    cellHeight:(CGFloat)collectionViewCellHeight
       cellWidthFromFixedWidth:(NSInteger)cellFixedWidth
cellWidthFromPerRowMaxShowCount:(CGFloat)perRowMaxShowCount
                 showExtraItem:(BOOL)showExtraItem
         maxDataModelShowCount:(NSInteger)maxDataModelShowCount;

@end
