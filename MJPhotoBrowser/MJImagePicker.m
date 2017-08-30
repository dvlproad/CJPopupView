//
//  MJImagePicker.m
//   ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "MJImagePicker.h"

#import <AVFoundation/AVFoundation.h>

#import "HCGridView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <JGActionSheet/JGActionSheet.h>
#import <SDWebImage/SDWebImageManager.h>
#import "MJImagePickerVC.h"
#import <CJBaseUIKit/UIColor+CJHex.h>
#import "UIGlobal.h"
#import "HPUIKits.h"
#import "UIImage+Helper.h"

//#import <BlocksKit/UIActionSheet+BlocksKit.h>
#define TAG_ADD -101
#define TAG_REMOVE -102

@implementation ImageItem

- (instancetype)init
{
    if (self = [super init]) {
        _fileId = @"";
        _imgUrl = @"";
        _filePath = @"";
    }
    return self;
}


- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    if ([_imgUrl isEqual:[NSNull null]]) {
        _imgUrl = @"";
    }
}

@end



@interface MJImagePicker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, strong) HCGridView * gridView;
@property (nonatomic, weak) UIViewController * controller;
@property (nonatomic, strong) MJPhotoBrowser *browser;

@end

@implementation MJImagePicker

- (void)dealloc
{
    _controller = nil;
    _gridView = nil;
}

- (instancetype)initWithData:(NSDictionary *)data inView:(UIView *)superview controller:(UIViewController *)controller
{
    if (self = [super init]) {
        [superview addSubview:self];
        _controller = controller;
        [self drawUI:data];
    }
    return self;
}


- (void)drawUI:(NSDictionary *)data
{
    _imageItems = [[NSMutableArray alloc] init];
    _limit = 1;
    _enabled = YES;
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:15.0f];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentLeft;
    title.numberOfLines = 1;
    [title setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:title];
    if (data[@"title"]) {
        title.text = data[@"title"];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    } else {
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    }
    if (data[@"titleColor"]) {
        title.textColor = data[@"titleColor"];
    }
    
    
    
    _gridView = [[HCGridView alloc] init];
    _gridView.margin = 10;
    _gridView.numOfColumns = 4;
    _gridView.itemHeight = 60;
    [self addSubview:_gridView];
    [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(title.mas_right);
        make.top.and.right.and.bottom.mas_equalTo(0);
    }];
    
    if (data[@"seperator"]) {
        UIView * sep = [[UIView alloc] init];
        sep.backgroundColor = CJRGB(220, 220, 220);
        [self addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    if (data[@"limit"]) {
        _limit = [data[@"limit"] integerValue];
    }
    if (data[@"enabled"]) {
        _enabled = [data[@"enabled"] boolValue];
    }
    
    __weak typeof(self)weakSelf = self;
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.superview);
        make.height.mas_equalTo(60);
    }];
    
    [self reloadImageGrid];
}

- (void)reloadImageGrid
{
    NSMutableArray * controls = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _imageItems.count; i++) {
        ImageItem * item = _imageItems[i];
        UIControl * control = [[UIControl alloc] init];
        control.tag = i;
        
        UIImageView * image = [[UIImageView alloc] init];
        image.image = item.image;
        image.layer.cornerRadius = 5;
        image.layer.masksToBounds = YES;
        image.contentMode = UIViewContentModeScaleAspectFill;
        [control addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(control.mas_centerX);
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(58);
            make.top.mas_equalTo(0);
        }];
        
        if (_enabled) {
            HCButton * button = [HCButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"deleteB"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"deleteB"] forState:UIControlStateHighlighted];
            button.tag = TAG_REMOVE;
            button.hcTarget = [NSNumber numberWithInt:i];
            [control addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-8);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
                make.centerX.mas_equalTo(control.mas_centerX).with.offset(28);
            }];
            [button addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
        }

        [control addTarget:self action:@selector(showPhotoViewer:) forControlEvents:UIControlEventTouchUpInside];
        
        [controls addObject:control];
    }
    
    if (_enabled && _imageItems.count < _limit) {
        // 添加成员
        UIControl * addControl = [[UIControl alloc] init];
        
        UIImageView * add = [[UIImageView alloc] init];
        add.image = [UIImage imageNamed:@"homework_add_image"];
        [addControl addSubview:add];
        [add mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(addControl.mas_centerX);
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(58);
            make.top.mas_equalTo(0);
        }];
        addControl.tag = TAG_ADD;
        [addControl addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [controls addObject:addControl];
    }
    
    
    _gridView.girdItems = controls;
    
    [_gridView reloadData];
    
    
    __weak typeof(self)weakSelf = self;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.gridView.viewHeight);
    }];
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i <_imageItems.count; i++) {
        ImageItem *item = _imageItems[i];
        [array addObject:item.image];
    }
       
    }

- (void)addImage:(UIControl *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
    if (_imageItems.count >= _limit) {
        [UIGlobal showMessage:@"图片数量已达上限"];
        return;
    }
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"拍照", @"从手机相册选择"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel];
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    __weak typeof(self)weakSelf =self;
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    [[[UIAlertView alloc] initWithTitle:@"无法拍照" message:@"请在“设置-隐私-相机”选项中允许'爱进步'访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    return;
                }
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:sourceType])
                {
                    UIImagePickerController * imagePick = [[UIImagePickerController alloc] init];
                    imagePick.sourceType = sourceType;
                    imagePick.delegate = weakSelf;
                    imagePick.allowsEditing = YES;
                    [_controller presentViewController:imagePick animated:YES completion:NULL];
                }
            }
            else
            {
                MJImagePickerVC * vc = [[MJImagePickerVC alloc] init];
                vc.canMaxChooseImageCount = _limit - self.imageItems.count;
                vc.pickCompleteBlock = ^(NSArray * array){
                    for (int i=0;i<array.count;i++) {
                        MJImageItem *tem = array[i];
                        ImageItem * item = [[ImageItem alloc] init];
                        item.image = tem.image;
                        item.imgUrl = tem.url;
                        [weakSelf.imageItems addObject:item];
                        
                        [weakSelf reloadImageGrid];
                        if (weakSelf.scallback) {
                            weakSelf.scallback(YES);
                        }

                    }
                };
                
                UIColor *blueTextColor = [UIColor cjColorWithHexString:@"#68c2f4"];
                
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                nav.navigationBar.barTintColor = [UIColor whiteColor];
                [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:blueTextColor}];
                nav.navigationBar.tintColor = blueTextColor;
                [weakSelf.controller presentViewController:nav animated:YES completion:NULL];
            }
        }
        [sheet dismissAnimated:YES];
    }];
    [sheet setOutsidePressBlock:^(JGActionSheet *sheet){
        [sheet dismissAnimated:YES];
    }];
    [sheet showInView:self.controller.view animated:YES];
}

- (void)removeImage:(HCButton *)sender
{
    NSInteger index = [sender.hcTarget integerValue];
    [_imageItems removeObjectAtIndex:index];
    [self reloadImageGrid];
}

//删除照片
-(void)deletePhoto:(int)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    if (_imageItems.count>index) {
         [_imageItems removeObjectAtIndex:index];
    }
   
    if (_imageItems.count>0) {
        for (ImageItem * item in _imageItems) {
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:item.imgUrl];
            photo.image = item.image;
            [photos addObject:photo];
        }
        
        
        // 2.显示相册
         _browser.photos = photos; // 设置所有的图片
        // 弹出相册时显示的第一张图片是？
       [_browser deleteP:photos.count andPhotos:photos];
         _browser.currentPhotoIndex = 0;
        _browser.isDelete = YES;
       
        [_browser show];

    }else{
        [_browser backACT];
        
    }
        [self reloadImageGrid];

}

- (void)showPhotoViewer:(UIControl *)sender
{
    __weak typeof(self)weakSelf = self;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (ImageItem * item in _imageItems) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:item.imgUrl];
        photo.image = item.image;
        [photos addObject:photo];
    }
    // 2.显示相册
    _browser = [[MJPhotoBrowser alloc] init];
    _browser.currentPhotoIndex = sender.tag; // 弹出相册时显示的第一张图片是？
    _browser.photos = photos; // 设置所有的图片
    _browser.isDelete = YES;
    _browser.currentNumCallback = ^(NSNumber *currentNum)
    {
        [weakSelf deletePhoto:[currentNum intValue]];
    };
    [_browser show];
    
    if(_rcallback)
    {
        _rcallback(YES);
    }

    
}

- (void)setDefaultImageItems:(NSArray *)imageItems
{
    [_imageItems removeAllObjects];
    [_imageItems addObjectsFromArray:imageItems];
    [self reloadImageGrid];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [self reloadImageGrid];
}

- (CGFloat)viewHeight
{
    return _gridView.viewHeight;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info valueForKey:picker.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    ImageItem *item = [ImageItem new];
    item.image = [UIImage adjustImageWithImage:image];
    [self.imageItems addObject:item];
    [self reloadImageGrid];
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
   }


@end
