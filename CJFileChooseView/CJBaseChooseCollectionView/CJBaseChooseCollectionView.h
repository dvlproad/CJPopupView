//
//  CJBaseChooseCollectionView.h
//  AllScrollViewDemo
//
//  Created by lichq on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJBaseChooseCollectionView;
typedef UICollectionViewCell* (^CJCollectionViewConfigureDataCellBlock)(CJBaseChooseCollectionView *collectionView, NSIndexPath *indexPath);
typedef UICollectionViewCell* (^CJCollectionViewConfigureExtraCellBlock)(CJBaseChooseCollectionView *collectionView, NSIndexPath *indexPath);
typedef void (^CJCollectionViewDidSelectDataItemBlock)(CJBaseChooseCollectionView *collectionView, NSIndexPath *indexPath);
typedef void (^CJCollectionViewDidSelectExtraItemBlock)(CJBaseChooseCollectionView *collectionView, NSIndexPath *indexPath);

@interface CJBaseChooseCollectionView : UICollectionView {
    
}
@property (nonatomic, strong) NSMutableArray *dataModels;
@property (nonatomic, assign) NSInteger maxShowCountPerRow;     /**< 每行最多个数,默认4 */

@property (nonatomic, assign) BOOL showExtraItem;               /**< 默认YES */
@property (nonatomic, assign) NSInteger maxDataModelShowCount;  /**< 默认MAXFLOAT即无限制 */

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;


- (void)commonInit;

- (void)setupConfigureDataCellBlock:(CJCollectionViewConfigureDataCellBlock)configureDataCellBlock
            configureExtraCellBlock:(CJCollectionViewConfigureExtraCellBlock)configureExtraCellBlock
         didSelectDataItemBlock:(CJCollectionViewDidSelectDataItemBlock)didSelectDataItemBlock
        didSelectExtraItemBlock:(CJCollectionViewDidSelectExtraItemBlock)didSelectExtraItemBlock;

+ (CGFloat)heightForItem:(NSArray *)dataModels
   byCollectionViewWidth:(CGFloat)collectionViewWidth
      maxShowCountPerRow:(CGFloat)maxShowCountPerRow
           showExtraItem:(BOOL)showExtraItem
   maxDataModelShowCount:(NSInteger)maxDataModelShowCount;

@end
