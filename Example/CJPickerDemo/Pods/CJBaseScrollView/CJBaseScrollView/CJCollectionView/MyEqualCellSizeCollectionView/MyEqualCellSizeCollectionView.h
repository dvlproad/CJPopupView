//
//  MyEqualCellSizeCollectionView.h
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/4/10.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEqualCellSizeSetting.h"

typedef UICollectionViewCell* (^CJConfigureCollectionViewCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void (^CJDidTapCollectionViewItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath); /**< 包括 didSelectItemAtIndexPath 和didDeselectItemAtIndexPath */


/**
 *  一个只有一个分区且分区中的每个cell大小相等的集合视图(cell的大小可通过方法①设置cell的固定大小和方法②通过设置每行最大显示的cell个数获得)(采用常用的init...方法后，即可初始化完成)
 */
@interface MyEqualCellSizeCollectionView : UICollectionView {
    
}
//必须设置的值
@property (nonatomic, strong) NSMutableArray *dataModels;       /**< 数据源 */
@property (nonatomic, strong) MyEqualCellSizeSetting *equalCellSizeSetting; /**< 集合视图的设置 */
//@property (nonatomic, strong) NSArray<NSIndexPath *> *currentSelectedIndexPaths;    /**< 当前已选中的所有indexPaths（直接通过系统的indexPathsForSelectedItems获得） */

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
 *  获取indexPath位置的dataModel(从数据源中获取每个indexPath要用什么dataModel来赋值)
 *
 *  @param indexPath indexPath
 *
 *  @return indexPath位置的dataModel
 */
- (id)getDataModelAtIndexPath:(NSIndexPath *)indexPath;


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
 *  @param equalCellSizeSetting     集合视图的布局
 *  @param showExtraItem            要传入的collectionView的是否显示额外item的值
 *  @param maxDataModelShowCount    要传入的collectionView的最大显示个数
 */
+ (CGFloat)heightForDataModels:(NSArray *)dataModels
         byCollectionViewWidth:(CGFloat)collectionViewWidth
      withEqualCellSizeSetting:(MyEqualCellSizeSetting *)equalCellSizeSetting
                 showExtraItem:(BOOL)showExtraItem
         maxDataModelShowCount:(NSInteger)maxDataModelShowCount;


/**
 *  根据是否要保存之前已选择的cell来更新视图
 *
 *  @param store    是否要保存之前已选择的cell
 */
- (void)reloadDataByStoreBeforeState:(BOOL)store;


@end
