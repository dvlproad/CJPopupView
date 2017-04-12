//
//  CJBaseCollectionView.h
//  CJPickerDemo
//
//  Created by 李超前 on 2017/4/8.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UICollectionViewCell* (^CJCollectionViewConfigureDataCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef UICollectionViewCell* (^CJCollectionViewConfigureExtraCellBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void (^CJCollectionViewDidSelectDataItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void (^CJCollectionViewDidSelectExtraItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

@interface CJBaseCollectionView : UICollectionView

{
    
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
