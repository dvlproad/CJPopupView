//
//  MJImagePickerVC.m
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "MJImagePickerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhotoBrowser.h"
#import "HCTableView.h"
#import "UIImage+fixOrientation.h"
#import "MBProgressHUD+Add.h"
#import <CJBaseUIKit/UIColor+CJHex.h>
#import "UIGlobal/UIGlobal.h"
#import "NSObject+Extension.h"

@interface ImageButton : UIButton

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) MJImageItem * item;

- (void)loadImage;

@end

@implementation ImageButton

- (void)loadImage
{
 
        if (_item.image != nil) {
            [self setImage:_item.image forState:UIControlStateNormal];
        } else {
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:[NSURL URLWithString:_item.url] resultBlock:^(ALAsset *asset)  {
                self.item.image =[UIImage imageWithCGImage:asset.thumbnail];
                [self setImage:self.item.image forState:UIControlStateNormal];
            }failureBlock:^(NSError *error) {
                [self setImage:[UIImage imageNamed:@"CJAvatar"] forState:UIControlStateNormal];
            }];
        }
}

@end

@interface Section : NSObject

@property (nonatomic, strong) id sid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSMutableArray * array;

@end

@implementation Section

- (instancetype)init
{
    if (self = [super init]) {
        _array = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation MJImageItem



@end

@interface MJImagePickerVC () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, HCRefreshViewDelegate>

@property (nonatomic, assign) int type;

@property (nonatomic, strong) HCTableView * tableView;
@property (nonatomic, strong) NSMutableArray * picSections;
@property (nonatomic, strong) NSMutableArray * selectedArray;
@property (nonatomic, assign) BOOL hasMoreFav;
@property (nonatomic, assign) BOOL hasMoreAlbum;
@property (nonatomic, strong) UILabel * number;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *assets;


@end

@implementation MJImagePickerVC

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)init
{
    if (self = [super init]) {
        _maxCount = 9;
    }
    return self;
}

- (void)dealloc
{
    _callback = nil;
    [[NSNotificationCenter defaultCenter] removeAssociatedObjectForKey:@"groupArray"];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIGlobal hideHudForView:self.view animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self)weakSelf = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(obtainGroupArray:) name:@"groupArray" object:nil];   
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(showPhotoes)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = rightItem;
        

    _picSections = [[NSMutableArray alloc] init];
    _selectedArray = [[NSMutableArray alloc] init];
    _tableView = [[HCTableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hcRefreshViewDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
    }];
    
    
    UIView * bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderWidth = 1;
    bottomView.layer.borderColor = CJRGBA(209, 209, 209, 1).CGColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIColor *blueTextColor = [UIColor cjColorWithHexString:@"#68c2f4"];
    
    UIButton * btnPreiview = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPreiview setTitle:@"预览" forState:UIControlStateNormal];
    [btnPreiview setTitleColor:blueTextColor forState:UIControlStateNormal];
    btnPreiview.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [bottomView addSubview:btnPreiview];
    [btnPreiview addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [btnPreiview mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.left.mas_equalTo(10);
    }];
    
        
    _number = [[UILabel alloc] init];
    _number.font = [UIFont systemFontOfSize:16.0f];
    _number.text = @"(0)";
    _number.textColor = blueTextColor;
    _number.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_number];
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.right.mas_equalTo(-10);
        make.width.and.height.mas_equalTo(25);
    }];
    
    UIButton * btnSent = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnSent setTitle:@"完成" forState:UIControlStateNormal];
    [btnSent setTitleColor:blueTextColor forState:UIControlStateNormal];
    btnSent.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [bottomView addSubview:btnSent];
    [btnSent addTarget:self action:@selector(sent) forControlEvents:UIControlEventTouchUpInside];
    [btnSent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
         make.right.mas_equalTo(_number.mas_left).mas_equalTo(25);
         make.centerY.mas_equalTo(bottomView.mas_centerY);
    }];

    
    Section * section = [[Section alloc] init];
    [_picSections addObject:section];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.tableView.refreshHeaderEnabled = NO;
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if(authStatus == AVAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在设备的\"设置-隐私-照片\"中允许访问照片。"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        [NSThread detachNewThreadSelector:@selector(reloadPhotoLibrary) toTarget:weakSelf withObject:nil];
       //[NSThread detachNewThreadSelector:@selector(obtainData) toTarget:ws withObject:nil]; 
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_selectedArray  removeAllObjects];
    _number.text = @"(0)";
}

-(void)obtainGroupArray:(NSNotification *)notic
{

    self.assetsGroup = notic.object;
    [self obtainData];
    
}


- (void)showPhotoes
{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FamilyPerformanceStoryboard" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MJphotoSections"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil]; 

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)preview
{
    if (_selectedArray.count == 0) {
        return;
    }
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_selectedArray.count];
    for (int i = 0; i<_selectedArray.count; i++) {
        MJImageItem * item = _selectedArray[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:item.url];
        if (item.type == 1) {
            photo.fav = YES;
        }
        photo.imageItem = item;
        [photos addObject:photo];
    }
    
    __weak typeof(self)weakSelf = self;
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.maxCount = (int)_maxCount;
    browser.selectedNum = (int)_selectedArray.count;
     __weak MJPhotoBrowser * view = browser;
    browser.psentCallBack = ^(BOOL success)
    {
        
        for (MJPhoto * photo in view.photos) {
            if (!photo.imageItem.selected) {
                [weakSelf.selectedArray removeObject:photo.imageItem];
            }
        }
        weakSelf.number.text = [NSString stringWithFormat:@"(%d)", (int)weakSelf.selectedArray.count];
        [weakSelf hcRefreshViewDidDataUpdated];
         if (success) {
         [self sent];
        }
       
    };
    
    
   
    
    browser.callback = ^(BOOL needRefresh){
         
        for (MJPhoto * photo in view.photos) {
            if (!photo.imageItem.selected) {
                [weakSelf.selectedArray removeObject:photo.imageItem];
            }
        }
        weakSelf.number.text = [NSString stringWithFormat:@"(%d)", (int)weakSelf.selectedArray.count];
        [weakSelf hcRefreshViewDidDataUpdated];

       if (needRefresh) {
             [self sent];
        }
       
           };
    [browser show];
    
}

- (void)sent
{
    
    if (_selectedArray.count == 0) {
        return;
    }
    [UIGlobal showHudForView:self.view animated:YES];
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (MJImageItem * item in _selectedArray) {
        if ([item.url hasPrefix:@"assets"]) {

            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:[NSURL URLWithString:item.url] resultBlock:^(ALAsset *asset)  {
                UIImage * image =[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage].fixOrientation;
                NSData *data = UIImageJPEGRepresentation(image, 0.8);
                NSString * path = [NSString stringWithFormat:@"%.0f.jpg", [[NSDate date] timeIntervalSince1970] * 1000];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                NSString *document = [paths objectAtIndex:0];
                path = [[document stringByAppendingPathComponent:@"image"] stringByAppendingPathComponent:path];
                
                [data writeToFile:path atomically:YES];
                item.image = image;
                [array addObject:item];
            }failureBlock:^(NSError *error) {
                
            }];
           }else
           {
               [array addObject:item.url];
           }
           }
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (array.count != weakSelf.selectedArray.count) {
            // DONOTHING
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.callback) {
                weakSelf.callback(array);
            }
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    });
    
}

- (void)reloadPhotoLibrary
{
    @autoreleasepool {
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              //  [[UIAlertView bk_showAlertViewWithTitle:@"无法访问照片图库" message:nil cancelButtonTitle:@"好" otherButtonTitles:nil handler:nil] show];
                [self hcRefreshViewDidDataUpdated];
            });
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    
                    NSString *url=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    MJImageItem * item = [[MJImageItem alloc] init];
                    item.url = url;
                    item.type = 1;
                    [((Section *)self.picSections[0]).array insertObject:item atIndex:0];
                }
            }
            
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            
            if (group!=nil) {
                self.title = [group valueForProperty:ALAssetsGroupPropertyName];
                if (self.title.length == 0) {
                    self.title = @"选择照片";
                }

                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            if (stop) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hcRefreshViewDidDataUpdated];
                });
            }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                   usingBlock:libraryGroupsEnumeration
                                 failureBlock:failureblock];
        });
    }
}


-(void)obtainData
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    [self.picSections removeAllObjects];
    Section * section = [[Section alloc] init];
    [_picSections addObject:section];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            [self.assets addObject:asset];
            if ([[asset valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                
                NSString *url=[NSString stringWithFormat:@"%@",asset.defaultRepresentation.url];//图片的url
                MJImageItem * item = [[MJImageItem alloc] init];
                item.url = url;
                item.type = 1;
                [((Section *)self.picSections[0]).array insertObject:item atIndex:0];
            }
        
        }
        else if (self.assets.count > 0)
        {
             [self hcRefreshViewDidDataUpdated];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}




- (Section *)sectionFilter:(NSInteger)index
{
    Section *item = _picSections[index];
    return item;
}

- (void)showPhotoViewer:(ImageButton *)sender
{
    Section * section = [self sectionFilter:sender.section];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < section.array.count; i++) {
        MJImageItem * item = section.array[i];
     
        MJPhoto *photo = [[MJPhoto alloc] init];
        if (item.type == 1) {
            photo.fav = YES;
        }
        photo.url = [NSURL URLWithString:item.url];
        photo.imageItem = item;
        [array addObject:photo];
    }
    
    __weak typeof(self)weakSelf = self;
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = sender.index; // 弹出相册时显示的第一张图片是？
    browser.photos = array; // 设置所有的图片
    browser.maxCount = (int)_maxCount;
    browser.selectedNum = (int)_selectedArray.count;
    
    __weak MJPhotoBrowser * view = browser;
    
    
    browser.psentCallBack = ^(BOOL success)
    {
         
        
        for (MJPhoto * photo in view.photos) 
        {
            
            [weakSelf.selectedArray removeObject:photo.imageItem];
            
            if (photo.imageItem.selected && weakSelf.selectedArray.count < weakSelf.maxCount) {
                [weakSelf.selectedArray addObject:photo.imageItem];
            } else {
                photo.imageItem.selected = NO;
            }
            
        }
        
        weakSelf.number.text = [NSString stringWithFormat:@"(%d)", (int)weakSelf.selectedArray.count];
        [weakSelf hcRefreshViewDidDataUpdated];

        if (success) 
        {
       
            [self sent];
        }
        };
    browser.callback = ^(BOOL needRefresh){
       
        for (MJPhoto * photo in view.photos) 
        {
            
            [weakSelf.selectedArray removeObject:photo.imageItem];
            
            if (photo.imageItem.selected && weakSelf.selectedArray.count < weakSelf.maxCount) {
                [weakSelf.selectedArray addObject:photo.imageItem];
            } else {
                photo.imageItem.selected = NO;
            }
            
        }
            weakSelf.number.text = [NSString stringWithFormat:@"(%d)", (int)weakSelf.selectedArray.count];
            [weakSelf hcRefreshViewDidDataUpdated];
         if (needRefresh ) {
            [self sent];
        }
        
    };
    [browser show];

}

- (void)onImageSelectedChanged:(ImageButton *)sender
{
    
    Section * section = [self sectionFilter:sender.section];
    MJImageItem * item = section.array[sender.index];
    item.selected = !item.selected;
    if (item.selected) {
        if (_selectedArray.count >= _maxCount) {
            item.selected = NO;
            [UIGlobal showMessage:[NSString stringWithFormat:@"最多只能选%d张图片", (int)_maxCount] inView:self.view];
            return;
        }
        [_selectedArray addObject:item];
        [sender setImage:[UIImage imageNamed:@"cjAlbumCheckedSelect"] forState:UIControlStateNormal];
    } else {
        [_selectedArray removeObject:item];
        [sender setImage:[UIImage imageNamed:@"cjAlbumCheckedNormal"] forState:UIControlStateNormal];
    }
    _number.text = [NSString stringWithFormat:@"(%d)", (int)_selectedArray.count];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView hcTableViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_tableView hcTableViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView hcTableViewDidEndDragging];
}

#pragma mark - HCRefreshView Delegate
- (void)hcRefreshViewDidPullDownToRefresh
{
}

- (void)hcRefreshViewDidPullUpToLoad
{
}

- (void)hcRefreshViewDidDataUpdated
{
    [_tableView hcTableViewDidDataUpdated];
}

#pragma mark - UITableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return _picSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Section * item = [self sectionFilter:section];
    
    if (0 == fmod(item.array.count, 4)) {
        return item.array.count / 4;
    } else {
        return item.array.count / 4 + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (tableView.frame.size.width - 25) / 4;
    return width + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * IDENTIFIER = @"IMAGE_CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat width = (tableView.frame.size.width - 25) / 4;
        
        for (int i = 0; i < 4; i++) {
    
            UIView * view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            view.tag = i;
            view.clipsToBounds = YES;
            
            ImageButton * btn = [ImageButton buttonWithType:UIButtonTypeCustom];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.tag = 100;
            [btn addTarget:self action:@selector(showPhotoViewer:) forControlEvents:UIControlEventTouchUpInside];
            
            ImageButton * check = [ImageButton buttonWithType:UIButtonTypeCustom];
            check.imageView.contentMode = UIViewContentModeScaleAspectFill;
            check.tag = 101;
            [check addTarget:self action:@selector(onImageSelectedChanged:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.left.and.bottom.and.right.mas_equalTo(0);
            }];
            
            [view addSubview:check];
            [check mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-5);
                make.right.mas_equalTo(5);
                make.width.and.height.mas_equalTo(44);
            }];
            
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(5);
                make.left.mas_equalTo(5 * (i+1) + width * i);
                make.width.and.height.mas_equalTo(width);
            }];
        }
    }
    
    Section * sec = [self sectionFilter:indexPath.section];
    
    for (int i = 0; i < 4; i++) {
        NSInteger index = 4 * indexPath.row + i;
        
        MJImageItem * item;
        
        if (index < sec.array.count) {
            item = sec.array[4 * indexPath.row + i];
        }
        
        UIView * view = [cell viewWithTag:i];
        ImageButton * btn = (ImageButton *)[view viewWithTag:100];
        btn.section = indexPath.section;
        btn.index = i + 4 * indexPath.row;
        btn.item = item;
        
        ImageButton * check = (ImageButton *)[view viewWithTag:101];
        check.section = indexPath.section;
        check.index = i + 4 * indexPath.row;
        if (item.selected) {
            [check setImage:[UIImage imageNamed:@"cjAlbumCheckedSelect"] forState:UIControlStateNormal];
        } else {
            [check setImage:[UIImage imageNamed:@"cjAlbumCheckedNormal"] forState:UIControlStateNormal];
        }
        
        if (item == nil) {
            view.hidden = YES;
        } else {
            [btn loadImage];
            view.hidden = NO;
        }
    }
    return cell;
}
@end
