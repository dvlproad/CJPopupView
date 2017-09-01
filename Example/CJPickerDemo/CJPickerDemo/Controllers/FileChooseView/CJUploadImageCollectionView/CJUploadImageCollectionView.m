//
//  CJUploadImageCollectionView.m
//  FileChooseViewDemo
//
//  Created by 李超前 on 2017/1/19.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJUploadImageCollectionView.h"
#import "CJUploadImageCollectionView+Tap.h"
#import "CJUploadCollectionViewCell.h"

static NSString *CJUploadCollectionViewCellID = @"CJUploadCollectionViewCell";
static NSString *CJUploadCollectionViewCellAddID = @"CJUploadCollectionViewCellAdd";

@interface CJUploadImageCollectionView () {
    
}

@end

@implementation CJUploadImageCollectionView

- (void)commonInit {
    [super commonInit];
    
    
    self.dataModels = [[NSMutableArray alloc] init];
    /*
    {
        CJImageUploadItem *item = [[CJImageUploadItem alloc] init];
        item.image = [UIImage imageNamed:@"CJAvatar.png"];
        [self.dataModels addObject:item];
    }
    */
    self.extralItemSetting = CJExtralItemSettingTailing;
    
    //以下值必须二选一设置（默认cellWidthFromFixedWidth设置后，另外一个自动失效）
    self.cellWidthFromPerRowMaxShowCount = 4;
    //self.cellWidthFromFixedWidth = 50;
    
    //以下值，可选设置
    //self.collectionViewCellHeight = 30;
    //self.maxDataModelShowCount = 5;
    self.maxDataModelShowCount = 5; //MAXFLOAT
    
    self.allowsMultipleSelection = YES; //是否打开多选
    
    
    
    CJUploadCollectionViewCell *registerCell = [[CJUploadCollectionViewCell alloc] init];
    
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:CJUploadCollectionViewCellID];
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:CJUploadCollectionViewCellAddID];
    
    /*
    CJFullBottomCollectionViewCell *registerCell = [[CJFullBottomCollectionViewCell alloc] init];
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:@"cell"];
    [self registerClass:[registerCell class] forCellWithReuseIdentifier:@"addCell"];
    */
    
    __weak typeof(self)weakSelf = self;
    
    [self configureDataCellBlock:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        
        /*
        CJFullBottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        */
        CJUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJUploadCollectionViewCellID forIndexPath:indexPath];
        [self operateCell:cell withDataModelIndexPath:indexPath isSettingOperate:YES];
        
        BOOL shouldUploadDirectly = YES; //TODO:是否直接上传
        [self uploadCell:cell withDataModelIndexPath:indexPath shouldUploadDirectly:shouldUploadDirectly]; //上传操作
        
        [self deleteCell:cell inCollectionView:collectionView withDataModelIndexPath:indexPath];
        
        
        return cell;
        
    } configureExtraCellBlock:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        /*
        CJFullBottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
        */
        CJUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJUploadCollectionViewCellAddID forIndexPath:indexPath];
        
        cell.cjImageView.image = [UIImage imageNamed:@"cjCollectionViewCellAdd"];
        [cell.cjDeleteButton setImage:nil forState:UIControlStateNormal];
        
        return cell;
    }];
    
    
    [self didTapDataItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        NSLog(@"当前点击的Item为数据源中的第%ld个", indexPath.item);
        /*
        if (collectionView.allowsMultipleSelection == NO) {
            NSArray *oldSelectedIndexPaths = weakSelf.equalCellSizeCollectionView.currentSelectedIndexPaths;
            if (oldSelectedIndexPaths.count > 0) {
                NSIndexPath *oldSelectedIndexPath = oldSelectedIndexPaths[0];
                
                CJFullBottomCollectionViewCell *oldCell = (CJFullBottomCollectionViewCell *)[collectionView cellForItemAtIndexPath:oldSelectedIndexPath];//是oldSelectedIndexPath不要写成indexPath了
                [self operateCell:oldCell withDataModelIndexPath:oldSelectedIndexPath isSettingOperate:NO];
            }
        }
        
        NSArray *currentSelectedIndexPaths = [self.equalCellSizeCollectionView indexPathsForSelectedItems];
        weakSelf.equalCellSizeCollectionView.currentSelectedIndexPaths = currentSelectedIndexPaths;
        NSLog(@"currentSelectedIndexPaths = %@", currentSelectedIndexPaths);
        
        CJFullBottomCollectionViewCell *cell = (CJFullBottomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self operateCell:cell withDataModelIndexPath:indexPath isSettingOperate:NO];
        */
        
        CJBaseUploadItem *baseUploadItem = [self.dataModels objectAtIndex:indexPath.row];
        
        CJUploadInfo *uploadInfo = baseUploadItem.uploadInfo;
        if (uploadInfo.uploadState == CJUploadStateFailure) {
            return;
        }
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [weakSelf didSelectMediaUploadItemAtIndexPath:indexPath];
        
    } didTapExtraItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        NSLog(@"点击额外的item");
        
        [weakSelf didTapToAddMediaUploadItemAction];
    }];
}

/**
 *  设置或者更新Cell
 *
 *  @param cell             要设置或者更新的Cell
 *  @param indexPath        用于获取数据的indexPath(此值一般情况下与cell的indexPath相等)
 *  @param isSettingOperate 是否是设置，如果否则为更新
 */
- (void)operateCell:(CJUploadCollectionViewCell *)cell withDataModelIndexPath:(NSIndexPath *)indexPath isSettingOperate:(BOOL)isSettingOperate {
    
    CJImageUploadItem *dataModel = [self getDataModelAtIndexPath:indexPath];
    if (isSettingOperate) {
        dataModel.indexPath = indexPath;
    }
    
    cell.cjImageView.image = [UIImage imageNamed:@"icon"];
    if (cell.selected) {
        cell.cjImageView.image = [UIImage imageNamed:@"cjCollectionViewCellAdd"];
        cell.backgroundColor = [UIColor blueColor];
    } else {
        cell.cjImageView.image = dataModel.image;
        cell.backgroundColor = [UIColor whiteColor];
    }
}


/**
 *  完善cell这个view的上传请求
 *
 *  @param cell                 cell
 *  @param indexPath            indexPath
 *  @param shouldUploadDirectly 是否直接上传
 */
- (void)uploadCell:(CJUploadCollectionViewCell *)cell withDataModelIndexPath:(NSIndexPath *)indexPath shouldUploadDirectly:(BOOL)shouldUploadDirectly {
//    //shouldUploadDirectly:是否直接上传(YES:cell显示的时候就开始直接上传；NO：不直接上传,则我们一般会有一个统一“上传”的按钮，来让这些上传)
//    if (shouldUploadDirectly == NO) {
//        return;
//    }
//    
//    __weak typeof(self)weakSelf = self;
//    void (^uploadInfoChangeBlock)(CJBaseUploadItem *itemThatSaveUploadInfo) = ^(CJBaseUploadItem *itemThatSaveUploadInfo) {
//        CJImageUploadItem *imageItem = (CJImageUploadItem *)itemThatSaveUploadInfo;
//        CJUploadCollectionViewCell *myCell = (CJUploadCollectionViewCell *)[weakSelf cellForItemAtIndexPath:imageItem.indexPath];
//        CJUploadInfo *uploadInfo = itemThatSaveUploadInfo.uploadInfo;
//        [myCell.uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];
//    };
//    
//    CJImageUploadItem *baseUploadItem = [self getDataModelAtIndexPath:indexPath];
//    NSArray<CJUploadItemModel *> *uploadModels = baseUploadItem.uploadItems;
//    NSInteger toWhere = self.useToUploadItemToWhere;
//    
//    /*
//    [cell uploadItems:uploadModels toWhere:toWhere uploadInfoSaveInItem:baseUploadItem uploadInfoChangeBlock:uploadInfoChangeBlock];
//    */
//    
//    CJBaseUploadItem *saveUploadInfoToItem = baseUploadItem;
//    
//    NSURLSessionDataTask *(^createDetailedUploadRequestBlock)(void) = [IjinbuNetworkClient createDetailedUploadRequestBlockByRequestUploadItems:uploadModels toWhere:toWhere andsaveUploadInfoToItem:saveUploadInfoToItem uploadInfoChangeBlock:uploadInfoChangeBlock];
//    NSURLSessionDataTask *operation = saveUploadInfoToItem.operation;
//    if (operation == nil) {
//        operation = createDetailedUploadRequestBlock();
//        
//        saveUploadInfoToItem.operation = operation;
//    }
//    
//    
//    //cjReUploadHandle
//    __weak typeof(saveUploadInfoToItem)weakItem = saveUploadInfoToItem;
//    [cell.uploadProgressView setCjReUploadHandle:^(UIView *uploadProgressView) {
//        __strong __typeof(weakItem)strongItem = weakItem;
//        
//        [strongItem.operation cancel];
//        
//        NSURLSessionDataTask *newOperation = nil;
//        newOperation = createDetailedUploadRequestBlock();
//        
//        strongItem.operation = newOperation;
//    }];
//    
//    
//    CJUploadInfo *uploadInfo = saveUploadInfoToItem.uploadInfo;
//    [cell.uploadProgressView updateProgressText:uploadInfo.uploadStatePromptText progressVaule:uploadInfo.progressValue];//调用此方法避免reload时候显示错误
}

///完善cell的deleteButton的操作
- (void)deleteCell:(CJUploadCollectionViewCell *)cell inCollectionView:(UICollectionView *)collectionView withDataModelIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    
    CJImageUploadItem *baseUploadItem = [self getDataModelAtIndexPath:indexPath];
    [cell setDeleteHandle:^(CJBaseCollectionViewCell *baseCell) {
        if (baseUploadItem.operation) { //如果有请求任务，则还应该取消掉该任务
            [baseUploadItem.operation cancel];
        }
        NSIndexPath *indexPath = [collectionView indexPathForCell:baseCell];
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataModels removeObjectAtIndex:indexPath.item];
        NSInteger currentCount = strongSelf.dataModels.count;
        NSInteger oldCount = [strongSelf numberOfItemsInSection:0];
        NSLog(@"currentCount = %ld, oldCount = %ld", currentCount, oldCount);
        if (currentCount == oldCount) {
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } else {
            [collectionView reloadData];
        }
    }];
}


///删除第几张图片
- (void)deletePhoto:(NSInteger)index
{
    if (self.dataModels.count > index) {
        [self.dataModels removeObjectAtIndex:index];
        [self reloadData];
    }
}


- (BOOL)isAllUploadFinish {
    for (CJBaseUploadItem *uploadItem in self.dataModels) {
        CJUploadInfo *uploadInfo = uploadItem.uploadInfo;
        if (uploadInfo.uploadState == CJUploadStateFailure) {
            NSLog(@"Failure:请等待所有附件上传完成");
            return NO;
        }
    }
    return YES;
}

@end
