//
//  MyEqualCellSizeCollectionView.m
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/4/10.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "MyEqualCellSizeCollectionView.h"

@interface MyEqualCellSizeCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    
}
//readonly
@property (nonatomic, copy, readonly) CJConfigureCollectionViewCellBlock configureDataCellBlock;
@property (nonatomic, copy, readonly) CJConfigureCollectionViewCellBlock configureExtraCellBlock;
@property (nonatomic, copy, readonly) CJDidTapCollectionViewItemBlock didTapDataItemBlock;
@property (nonatomic, copy, readonly) CJDidTapCollectionViewItemBlock didTapExtraItemBlock;

@end



@implementation MyEqualCellSizeCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (layout == nil) {
        layout = [[UICollectionViewFlowLayout alloc] init];
    }
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.extralItemSetting = CJExtralItemSettingNone;
    self.maxDataModelShowCount = NSIntegerMax;
    //NSLog(@"maxDataModelShowCount = %ld", self.maxDataModelShowCount);
    
//    self.allowsMultipleSelection = YES;
    
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

/** 完整的描述请参见文件头部 */
- (void)configureDataCellBlock:(CJConfigureCollectionViewCellBlock)configureDataCellBlock
       configureExtraCellBlock:(CJConfigureCollectionViewCellBlock)configureExtraCellBlock
{
    _configureDataCellBlock = configureDataCellBlock;
    _configureExtraCellBlock = configureExtraCellBlock;
}

- (void)didTapDataItemBlock:(CJDidTapCollectionViewItemBlock)didTapDataItemBlock
       didTapExtraItemBlock:(CJDidTapCollectionViewItemBlock)didTapExtraItemBlock
{
    _didTapDataItemBlock = didTapDataItemBlock;
    _didTapExtraItemBlock = didTapExtraItemBlock;
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
    CGFloat collectionViewCellWidth = 0;
    if (self.cellWidthFromFixedWidth) {
        collectionViewCellWidth = self.cellWidthFromFixedWidth;
        
    } else {
        UIEdgeInsets sectionInset = [self collectionView:collectionView
                                                  layout:collectionViewLayout
                                  insetForSectionAtIndex:indexPath.section];
        CGFloat minimumInteritemSpacing = [self collectionView:collectionView
                                                        layout:collectionViewLayout
                      minimumInteritemSpacingForSectionAtIndex:indexPath.section];
        
        CGFloat width = CGRectGetWidth(collectionView.frame);
        CGFloat validWith = width - sectionInset.left - sectionInset.right - minimumInteritemSpacing*(self.cellWidthFromPerRowMaxShowCount-1);
        collectionViewCellWidth = floorf(validWith/self.cellWidthFromPerRowMaxShowCount);
    }
    
    if (self.collectionViewCellHeight <= 0) {
        self.collectionViewCellHeight = collectionViewCellWidth;
    }
    return CGSizeMake(collectionViewCellWidth, self.collectionViewCellHeight);
}
//*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.extralItemSetting) {
        case CJExtralItemSettingLeading:
        case CJExtralItemSettingTailing:
        {
            if (self.dataModels.count < self.maxDataModelShowCount) {
                return self.dataModels.count + 1;
            } else {
                return self.dataModels.count;
            }
            
            break;
        }
        case CJExtralItemSettingNone:
        default:
        {
            return self.dataModels.count;
            break;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.extralItemSetting) {
        case CJExtralItemSettingLeading:
        {
            if (indexPath.row >= 1) {
                return [self collectionView:collectionView cellForDataItemAtIndexPath:indexPath];
            } else {
                return [self collectionView:collectionView cellForExtraItemAtIndexPath:indexPath];
            }
            break;
        }
        case CJExtralItemSettingTailing:
        {
            if (indexPath.row < self.dataModels.count) {
                return [self collectionView:collectionView cellForDataItemAtIndexPath:indexPath];
            } else {
                return [self collectionView:collectionView cellForExtraItemAtIndexPath:indexPath];
            }
            break;
        }
        case CJExtralItemSettingNone:
        default:
        {
            return [self collectionView:collectionView cellForDataItemAtIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self collectionView:collectionView didTapItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self collectionView:collectionView didTapItemAtIndexPath:indexPath];
}



#pragma mark - 设置事件cellForItem & 点击事件didSelect
///设置数据Item的操作
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
              cellForDataItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.configureDataCellBlock != nil, @"未设置configureDataCellBlock");
    return self.configureDataCellBlock(collectionView, indexPath);
}

///设置ExtraItem的操作
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
             cellForExtraItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.configureExtraCellBlock != nil, @"未设置configureExtraCellBlock");
    return self.configureExtraCellBlock(collectionView, indexPath);
}


///“点到”item时候执行的时间(allowsMultipleSelection为默认的NO的时候，只有选中，而为YES的时候有选中和取消选中两种操作)
- (void)collectionView:(UICollectionView *)collectionView didTapItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.extralItemSetting) {
        case CJExtralItemSettingLeading:
        {
            if (indexPath.row >= 1) {
                [self collectionView:collectionView didTapDataItemAtIndexPath:indexPath];
            } else {
                [self collectionView:collectionView didTapExtraItemAtIndexPath:indexPath];
            }
            break;
        }
        case CJExtralItemSettingTailing:
        {
            if (indexPath.row < self.dataModels.count) {
                [self collectionView:collectionView didTapDataItemAtIndexPath:indexPath];
            } else {
                [self collectionView:collectionView didTapExtraItemAtIndexPath:indexPath];
            }
            
            break;
        }
        case CJExtralItemSettingNone:
        default:
        {
            [self collectionView:collectionView didTapDataItemAtIndexPath:indexPath];
            break;
        }
    }
}

/* 完整的描述请参见文件头部 */
- (id)getDataModelAtIndexPath:(NSIndexPath *)indexPath {
    id dataModle = nil;
    switch (self.extralItemSetting) {
        case CJExtralItemSettingLeading:
        {
            dataModle = [self.dataModels objectAtIndex:indexPath.item-1];
            break;
        }
        case CJExtralItemSettingTailing:
        case CJExtralItemSettingNone:
        default:
        {
            dataModle = [self.dataModels objectAtIndex:indexPath.item];
            break;
        }
    }
    
    return dataModle;
}

///点击数据Item会执行的操作
- (void)collectionView:(UICollectionView *)collectionView didTapDataItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didTapDataItemBlock) {
        self.didTapDataItemBlock(self, indexPath);
    }
}

///点击ExtraItem会执行的操作(一般为比如添加图片的Add按钮)
- (void)collectionView:(UICollectionView *)collectionView didTapExtraItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didTapExtraItemBlock) {
        self.didTapExtraItemBlock(self, indexPath);
    }
}


#pragma mark - Other
/** 完整的描述请参见文件头部 */
+ (CGFloat)heightForDataModels:(NSArray *)dataModels
         byCollectionViewWidth:(CGFloat)collectionViewWidth
                    cellHeight:(CGFloat)collectionViewCellHeight
       cellWidthFromFixedWidth:(NSInteger)cellFixedWidth
        cellWidthFromPerRowMaxShowCount:(CGFloat)perRowMaxShowCount
           showExtraItem:(BOOL)showExtraItem
   maxDataModelShowCount:(NSInteger)maxDataModelShowCount
{
    CGFloat minimumLineSpacing = 15;
    CGFloat minimumInteritemSpacing = 10;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    /* 获取每行显示的个数以及cell的高度 */
    if (collectionViewCellHeight <= 0) { //如果cell的高度未设置，我们默认使其等于cell的宽度
        //计算cell的宽度
        CGFloat collectionViewCellWidth = 0;
        if (cellFixedWidth) {
            collectionViewCellWidth = cellFixedWidth;
            
            //sectionInset.left + x*width + (x-1)*minimumInteritemSpacing + sectionInset.right <= collectionViewWidth;
            //x*cellWidth + (x-1)*minimumInteritemSpacing <= collectionViewWidth - sectionInset.left - sectionInset.right;
            //x*(cellWidth+minimumInteritemSpacing) <= collectionViewWidth - sectionInset.left - sectionInset.right + minimumInteritemSpacing;
            CGFloat validWith = collectionViewWidth - sectionInset.left - sectionInset.right + minimumInteritemSpacing;
            perRowMaxShowCount = validWith/(collectionViewCellWidth+minimumInteritemSpacing);
            
        } else {
            NSAssert(perRowMaxShowCount != 0, @"maxShowCountPerRow不能为0");
            
            CGFloat validWith = collectionViewWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing*(perRowMaxShowCount-1);
            collectionViewCellWidth = floorf(validWith/perRowMaxShowCount);
            
        }
        
        collectionViewCellHeight = collectionViewCellWidth;
    }
    
    
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
        currentRowCount = (allDataModelCount-1)/perRowMaxShowCount + 1;
        height += currentRowCount * collectionViewCellHeight + (currentRowCount - 1)*minimumLineSpacing;
    }
    height += sectionInset.top + sectionInset.bottom;
    
    return height;
}

@end
