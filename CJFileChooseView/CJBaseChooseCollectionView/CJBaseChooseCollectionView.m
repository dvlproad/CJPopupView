//
//  CJBaseChooseCollectionView.m
//  AllScrollViewDemo
//
//  Created by lichq on 2016/06/07.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJBaseChooseCollectionView.h"

@interface CJBaseChooseCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate> {
    
}
@property (nonatomic, copy, readonly) CJCollectionViewConfigureDataCellBlock configureDataCellBlock;
@property (nonatomic, copy, readonly) CJCollectionViewConfigureExtraCellBlock configureExtraCellBlock;
@property (nonatomic, copy, readonly) CJCollectionViewDidSelectDataItemBlock didSelectDataItemBlock;
@property (nonatomic, copy, readonly) CJCollectionViewDidSelectExtraItemBlock didSelectExtraItemBlock;

@end


@implementation CJBaseChooseCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (layout == nil) {
        layout = [[UICollectionViewFlowLayout alloc] init];
    }
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.dataModels = [[NSMutableArray alloc] init];
     self.maxShowCountPerRow = 4;
    
    self.showExtraItem = NO;
    self.maxDataModelShowCount = MAXFLOAT;
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    /* //放在这里设置flowLayout,会由于CGRectGetWidth(self.frame);初始太大而导致计算错误
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout.headerReferenceSize = CGSizeMake(110, 135);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //flowLayout.itemSize = CGSizeMake(60, 60);
    CGFloat maxShowItemCount = 4;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat validWith = width-flowLayout.sectionInset.left-flowLayout.sectionInset.right-flowLayout.minimumInteritemSpacing*(maxShowItemCount-1);
    CGFloat collectionViewCellWidth = floorf(validWith/maxShowItemCount);
    flowLayout.itemSize = CGSizeMake(collectionViewCellWidth, collectionViewCellWidth);
    [self setCollectionViewLayout:flowLayout animated:NO completion:nil];
    */

    self.delegate = self;
    self.dataSource = self;
}

- (void)setupConfigureDataCellBlock:(CJCollectionViewConfigureDataCellBlock)configureDataCellBlock
            configureExtraCellBlock:(CJCollectionViewConfigureExtraCellBlock)configureExtraCellBlock
             didSelectDataItemBlock:(CJCollectionViewDidSelectDataItemBlock)didSelectDataItemBlock
            didSelectExtraItemBlock:(CJCollectionViewDidSelectExtraItemBlock)didSelectExtraItemBlock
{
    _configureDataCellBlock = configureDataCellBlock;
    _configureExtraCellBlock = configureExtraCellBlock;
    _didSelectDataItemBlock = didSelectDataItemBlock;
    _didSelectExtraItemBlock = didSelectExtraItemBlock;
}

//*
#pragma mark - UICollectionViewLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets sectionInset = [self collectionView:collectionView
                                              layout:collectionViewLayout
                              insetForSectionAtIndex:indexPath.section];
    CGFloat minimumInteritemSpacing = [self collectionView:collectionView
                                                    layout:collectionViewLayout
                  minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGFloat validWith = width - sectionInset.left - sectionInset.right - minimumInteritemSpacing*(self.maxShowCountPerRow-1);
    CGFloat collectionViewCellWidth = floorf(validWith/self.maxShowCountPerRow);
    return CGSizeMake(collectionViewCellWidth, collectionViewCellWidth);
}
//*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showExtraItem && self.dataModels.count < self.maxDataModelShowCount) {
        return self.dataModels.count + 1;
        
    } else {
        return self.dataModels.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataModels.count) {
        NSAssert(self.configureDataCellBlock != nil, @"未设置configureDataCellBlock");
        return self.configureDataCellBlock(collectionView, indexPath);

    } else {
        NSAssert(self.configureExtraCellBlock != nil, @"未设置configureExtraCellBlock");
        return self.configureExtraCellBlock(collectionView, indexPath);
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataModels.count) {
        if (self.didSelectDataItemBlock) {
            self.didSelectDataItemBlock(self, indexPath);
        }

    } else {
        if (self.didSelectExtraItemBlock) {
            self.didSelectExtraItemBlock(self, indexPath);
        }
    }
}

+ (CGFloat)heightForItem:(NSArray *)dataModels
   byCollectionViewWidth:(CGFloat)collectionViewWidth
      maxShowCountPerRow:(CGFloat)maxShowCountPerRow
           showExtraItem:(BOOL)showExtraItem
   maxDataModelShowCount:(NSInteger)maxDataModelShowCount
{
    NSAssert(maxShowCountPerRow != 0, @"maxShowCountPerRow不能为0");
    
    CGFloat minimumLineSpacing = 15;
    CGFloat minimumInteritemSpacing = 10;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    CGFloat validWith = collectionViewWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing*(maxShowCountPerRow-1);
    CGFloat collectionViewCellWidth = floorf(validWith/maxShowCountPerRow);
    CGFloat collectionViewCellHeight = collectionViewCellWidth;
    
    CGFloat height = 0;
    NSInteger currentRowCount = 0;
    NSInteger allDataModelCount = 0;
    if (showExtraItem && dataModels.count < maxDataModelShowCount) {
        allDataModelCount = dataModels.count + 1;
    } else {
        allDataModelCount = dataModels.count;
    }
    
    if (allDataModelCount == 0) {
        currentRowCount = 0;
        height += currentRowCount * collectionViewCellHeight;
    } else {
        currentRowCount = (allDataModelCount-1)/maxShowCountPerRow + 1;
        height += currentRowCount * collectionViewCellHeight + (currentRowCount - 1)*minimumLineSpacing;
    }
    height += sectionInset.top + sectionInset.bottom;
    
    return height;
}

@end
