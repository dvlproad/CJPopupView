//
//  MJphotoSections.m
//  ijinbu
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "MJphotoSections.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJImagePickerVC.h"

@interface MJphotoSections ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *groupArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewTop;

@property  (nonatomic, strong)  ALAssetsLibrary *assetsLibrary;
@end

@implementation MJphotoSections

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)groupArray
{
    if (!_groupArray) {
        _groupArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _groupArray;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    self.title = @"相册";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
       [self.groupArray removeAllObjects ];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            [weakSelf.groupArray addObject:group];
        }
        else
        {
            [weakSelf.myTableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        //[self showNotAllowed];
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:listGroupBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:listGroupBlock
                                    failureBlock:failureBlock];
    
}

-(void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.groupArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photocell"];
        
    ALAssetsGroup *group = [self.groupArray objectAtIndex:indexPath.row];
    UIImageView *headView = (UIImageView *)[cell.contentView viewWithTag:331];

    headView.image = [UIImage imageWithCGImage:[group posterImage]];
    
    
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:332];
    //姓名
    name.text = [group valueForProperty:ALAssetsGroupPropertyName];
    
    UILabel *num = (UILabel *)[cell.contentView viewWithTag:333];
    num.text = [NSString stringWithFormat:@"(%@)",[@(group.numberOfAssets) stringValue]];
  
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",self.groupArray[indexPath.row]);
    
    ALAssetsGroup *group = [self.groupArray objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"groupArray" object:group];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
