//
//  MyEqualCellSizeCollectionView.m
//  AllScrollViewDemo
//
//  Created by dvlproad on 2016/4/10.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "MyEqualCellSizeCollectionView.h"

@interface MyEqualCellSizeCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
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
//    self.allowsMultipleSelection = YES;
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    self.delegate = self;
    self.dataSource = self;
    
    //为了解决MyEqualCellSizeCollectionView在某个自定义类里面使用，而不是在viewController中使用，而导致的无法实时准确的获取到CGRectGetWidth(self.frame)，从而来计算出准确的宽，所以我们应该采用实现协议的方法，而不是下面的这一行代码
    //放在这里设置flowLayout,会由于CGRectGetWidth(self.frame);初始太大而导致计算错误，所以请在调用此类的外面再设置
    //UICollectionViewFlowLayout *defaultFlowLayout = equalCellSizeSetting..xx..
    //[self setCollectionViewLayout:defaultFlowLayout animated:NO completion:nil];
}


- (MyEqualCellSizeSetting *)equalCellSizeSetting {
    if (_equalCellSizeSetting == nil) { //如果没设置会采用默认布局
        MyEqualCellSizeSetting *equalCellSizeSetting = [[MyEqualCellSizeSetting alloc] init];
        //flowLayout.headerReferenceSize = CGSizeMake(110, 135);
        equalCellSizeSetting.minimumInteritemSpacing = 10;
        equalCellSizeSetting.minimumLineSpacing = 15;
        equalCellSizeSetting.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        //以下值必须二选一设置（默认cellWidthFromFixedWidth设置后，另外一个自动失效）
        equalCellSizeSetting.cellWidthFromPerRowMaxShowCount = 4;
        //equalCellSizeSetting.cellWidthFromFixedWidth = 50;
        
        //以下值，可选设置
        //equalCellSizeSetting.collectionViewCellHeight = 30;
        //equalCellSizeSetting.maxDataModelShowCount = 5;
        //equalCellSizeSetting.extralItemSetting = CJExtralItemSettingLeading;
        
        _equalCellSizeSetting = equalCellSizeSetting;
    }
    return _equalCellSizeSetting;
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
#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
    UIEdgeInsets sectionInset = self.equalCellSizeSetting.sectionInset;
    return sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
//    return 15;
    CGFloat minimumLineSpacing = self.equalCellSizeSetting.minimumLineSpacing;
    return minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
//    return 10;
    CGFloat minimumInteritemSpacing = self.equalCellSizeSetting.minimumInteritemSpacing;
    return minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyEqualCellSizeSetting *equalCellSizeSetting = self.equalCellSizeSetting;
    
    CGFloat collectionViewCellWidth = 0;
    if (equalCellSizeSetting.cellWidthFromFixedWidth) {
        collectionViewCellWidth = equalCellSizeSetting.cellWidthFromFixedWidth;
        
    } else {
        NSInteger cellWidthFromPerRowMaxShowCount = equalCellSizeSetting.cellWidthFromPerRowMaxShowCount;
        
        UIEdgeInsets sectionInset = [self collectionView:collectionView
                                                  layout:collectionViewLayout
                                  insetForSectionAtIndex:indexPath.section];
        CGFloat minimumInteritemSpacing = [self collectionView:collectionView
                                                        layout:collectionViewLayout
                      minimumInteritemSpacingForSectionAtIndex:indexPath.section];
        
        CGFloat width = CGRectGetWidth(collectionView.frame);
        CGFloat validWith = width - sectionInset.left - sectionInset.right - minimumInteritemSpacing*(cellWidthFromPerRowMaxShowCount-1);
        collectionViewCellWidth = floorf(validWith/cellWidthFromPerRowMaxShowCount);
    }
    
    if (equalCellSizeSetting.collectionViewCellHeight <= 0) {
        equalCellSizeSetting.collectionViewCellHeight = collectionViewCellWidth;
    }
    return CGSizeMake(collectionViewCellWidth, equalCellSizeSetting.collectionViewCellHeight);
}
//*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CJExtralItemSetting extralItemSetting = self.equalCellSizeSetting.extralItemSetting;
    switch (extralItemSetting) {
        case CJExtralItemSettingLeading:
        case CJExtralItemSettingTailing:
        {
            if (self.dataModels.count < self.equalCellSizeSetting.maxDataModelShowCount) {
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
    CJExtralItemSetting extralItemSetting = self.equalCellSizeSetting.extralItemSetting;
    switch (extralItemSetting) {
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
    CJExtralItemSetting extralItemSetting = self.equalCellSizeSetting.extralItemSetting;
    switch (extralItemSetting) {
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
    
    CJExtralItemSetting extralItemSetting = self.equalCellSizeSetting.extralItemSetting;
    switch (extralItemSetting) {
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
       withEqualCellSizeSetting:(MyEqualCellSizeSetting *)equalCellSizeSetting
                 showExtraItem:(BOOL)showExtraItem
         maxDataModelShowCount:(NSInteger)maxDataModelShowCount
{
    CGFloat minimumLineSpacing = equalCellSizeSetting.minimumLineSpacing;
    CGFloat minimumInteritemSpacing = equalCellSizeSetting.minimumInteritemSpacing;
    UIEdgeInsets sectionInset = equalCellSizeSetting.sectionInset;
    
    
    //计算cell的宽度
    CGFloat collectionViewCellWidth = 0;
    NSInteger perRowMaxShowCount = 0;
    if (equalCellSizeSetting.cellWidthFromFixedWidth) {
        collectionViewCellWidth = equalCellSizeSetting.cellWidthFromFixedWidth;
        
        //sectionInset.left + x*width + (x-1)*minimumInteritemSpacing + sectionInset.right <= collectionViewWidth;
        //x*cellWidth + (x-1)*minimumInteritemSpacing <= collectionViewWidth - sectionInset.left - sectionInset.right;
        //x*(cellWidth+minimumInteritemSpacing) <= collectionViewWidth - sectionInset.left - sectionInset.right + minimumInteritemSpacing;
        CGFloat validWidth = collectionViewWidth - sectionInset.left - sectionInset.right;
        perRowMaxShowCount = (validWidth+minimumInteritemSpacing)/(collectionViewCellWidth+minimumInteritemSpacing);
        
    } else {
        perRowMaxShowCount = equalCellSizeSetting.cellWidthFromPerRowMaxShowCount;
        NSAssert(perRowMaxShowCount != 0, @"perRowMaxShowCount不能为0");
        
        CGFloat validWidth = collectionViewWidth - sectionInset.left - sectionInset.right;
        CGFloat cellsWidth = validWidth - minimumInteritemSpacing*(perRowMaxShowCount-1);
        collectionViewCellWidth = floorf(cellsWidth/perRowMaxShowCount);
        
    }
    
    
    /* 获取cell的高度 */
    CGFloat collectionViewCellHeight = equalCellSizeSetting.collectionViewCellHeight;
    if (collectionViewCellHeight <= 0) { //如果cell的高度未设置，我们默认使其等于cell的宽度
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

/**
 *  计算通过每行可显示的最多个数得出的每个cell的宽度(只有通过每行可显示的最多个数来设置每个cell的宽度，而通过cell的固定宽度来设置每个cell的宽度的不需要用到此方法)
 *
 *  @param cellWidthFromPerRowMaxShowCount  每行可显示的最多个数
 *  @param collectionView                   在哪个集合视图中(用于得到宽度)
 *  @param equalCellSizeSetting             已经设置好的一些设置（用于得到真正用于cell的宽度）
 *
 *  @return 每个cell的宽度
 */
+ (CGFloat)cellWidthFromPerRowMaxShowCount:(NSInteger)cellWidthFromPerRowMaxShowCount
                          inCollectionView:(UICollectionView *)collectionView
                   withEqualCellSizeSetting:(MyEqualCellSizeSetting *)equalCellSizeSetting
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    
    CGFloat validWith = width-equalCellSizeSetting.sectionInset.left-equalCellSizeSetting.sectionInset.right;
    CGFloat cellsValidWith = validWith -equalCellSizeSetting.minimumInteritemSpacing*(cellWidthFromPerRowMaxShowCount-1);
    CGFloat collectionViewCellWidth = floorf(cellsValidWith/cellWidthFromPerRowMaxShowCount);
    
    return collectionViewCellWidth;
}



#pragma mark - Public
/* 完整的描述请参见文件头部 */
- (void)reloadDataByStoreBeforeState:(BOOL)store {
    if (store == NO) {
        [super reloadData];
        
    } else {
        //是否要保持原来的选中状态，如果是的话，请在刷新前，记录下之前的有哪些IndexPath被选中
        NSArray *oldIndexPathsForSelectedItems = [self indexPathsForSelectedItems];
        //NSLog(@"oldIndexPathsForSelectedItems = %@", oldIndexPathsForSelectedItems);
        
        [super reloadData];
        //NSArray *indexPathsForSelectedItems1 = [self indexPathsForSelectedItems];
        //NSLog(@"reload后获取的indexPathsForSelectedItems1为空，即 = %@", indexPathsForSelectedItems1);
        
        for (NSIndexPath *indexPath in oldIndexPathsForSelectedItems) {
            [self selectItemAtIndexPath:indexPath
                               animated:NO
                         scrollPosition:UICollectionViewScrollPositionNone];
        }
        //NSArray *indexPathsForSelectedItems2 = [self indexPathsForSelectedItems];
        //NSLog(@"reload后设置好之前的选中项后获取indexPathsForSelectedItems2 = %@", indexPathsForSelectedItems2);
    }
}

@end
