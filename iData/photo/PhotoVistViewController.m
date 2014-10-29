//
//  PhotoVistViewController.m
//  iData
//
//  Created by karven on 9/7/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "PhotoVistViewController.h"

@interface PhotoVistViewController ()

@property(nonatomic,retain) MBProgressHUD *hud;
@property(nonatomic,retain) SwipeView *swipeView;
@property(nonatomic,retain) UITapGestureRecognizer *tapGesture;
@property(nonatomic,retain) UIScrollView *view1,*view2,*view3;
@property(nonatomic,retain) NSMutableArray *selectFileArray;

@end

@implementation PhotoVistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.assets = [NSMutableArray array];
//    self.assetLibrary = [[ALAssetsLibrary alloc] init];
    self.selectFileArray = [NSMutableArray array];
    
    self.delegate = self;
    [self.titleLabel setText:@"照片库"];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-44)];
    [_swipeView addGestureRecognizer:_tapGesture];
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.pagingEnabled = YES;
    [_swipeView scrollToItemAtIndex:0 duration:0];
    [self.view addSubview:_swipeView];
    
    _view1 = [[UIScrollView alloc] initWithFrame:_swipeView.bounds];
    _view2 = [[UIScrollView alloc] initWithFrame:_swipeView.bounds];
    _view3 = [[UIScrollView alloc] initWithFrame:_swipeView.bounds];
    
    int vertical = [self getVerticalCount];
    
    [_view1 setContentSize:CGSizeMake(ScreenWidth, vertical * 80)];
    [_view2 setContentSize:CGSizeMake(ScreenWidth, vertical * 80)];
    [_view3 setContentSize:CGSizeMake(ScreenWidth, vertical * 80)];
    
    [self loadAssets];
}

#pragma mark UITapGestureRecognizer Action
-(void)handleTap:(UITapGestureRecognizer *)tap{
    UIView *currentView = _swipeView.currentItemView;
    UIView *currentItemView = nil;
    NSArray *array = [currentView subviews];
    CGPoint point = [tap locationInView:currentView];
    if (point.y > (ScreenHeight-44 - 64)) {
        [super handleTap:tap];
    }
    int tag = -1;
    for (UIView *v in array) {
        if (CGRectContainsPoint(v.frame, point)) {
            currentItemView = v;
            tag = (int)v.tag;
            break;
        }
    }
    
    if (tag!=-1) {
        int index = tag / 1000;
        int indexH = (tag % 1000) / 100;
        int indexV = tag % 100;
        int indexInFileList = index * [self getVerticalCount] * 3 + indexH * 3 + indexV;
        ALAsset *asset = [self.assets objectAtIndex:indexInFileList];
        
        if ([self.isStatus isEqualToString:@"scan"]) {
          int index = (int)[self.assets indexOfObject:asset];
            CXImageBrowserView *browser = [CXImageBrowserView imageBrowserSource:self.assets select:nil startIndex:index];
            [self.view addSubview:browser];
            
            browser.center = CGPointMake(self.view.center.x+self.view.frame.size.width, self.view.center.y);
            [UIView animateWithDuration:ANIMATIONDURATION animations:^{
                browser.center = self.view.center;
            }completion:^(BOOL finished) {
                NSLog(@"finish");
            }];
        }else{
            NSArray *viewArray = [currentItemView subviews];
            for (UIView *v in viewArray) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    if (v.hidden) {
                        [v setHidden:NO];
                        [_selectFileArray addObject:asset];
                    }else{
                        [v setHidden:YES];
                        [_selectFileArray removeObject:asset];
                    }
                }
            }
        }
    }
}

#pragma mark SwipeView DataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    long totalNumber = self.assets.count;
    long count = totalNumber / (3 * [self getVerticalCount]);
    int remainder = totalNumber % (3 * [self getVerticalCount]);
    if (remainder > 0) {
        count = count + 1;
    }
    return count;
}
- (UIView *)swipeView:(SwipeView *)swipeView1 viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (index % 3 == 0) {
        while ([_view1.subviews lastObject] != nil){//删除cell上的子视图
            [[_view1.subviews lastObject] removeFromSuperview];
        }
        //计算当前页有多少file要显示
        long number= index*(3*[self getVerticalCount]);
        long count = (self.assets.count - number)>(3*[self getVerticalCount])?3*[self getVerticalCount]:(self.assets.count - number);
        //横行个数
        long hor = count / 3;
        if (count % 3 > 0) {
            hor = hor + 1;
        }
        for (int i = 0; i<hor; i++) {
            for (int j = 0; j<3; j++) {
                if (i*3 + j >= count) {
                    break;
                }
                UIView *v = [self getDisplayView:(int)index :i :j];
                [_view1 addSubview:v];
            }
        }
        return _view1;
    } else if (index % 3 == 1){
        while ([_view2.subviews lastObject] != nil){//删除cell上的子视图
            [[_view2.subviews lastObject] removeFromSuperview];
        }
        //计算当前页有多少file要显示
        long number = index*(3*[self getVerticalCount]);
        long count = (self.assets.count - number)>(3*[self getVerticalCount])?3*[self getVerticalCount]:(self.assets.count - number);
        long hor = count / 3;
        if (count % 3 > 0) {
            hor = hor + 1;
        }
        for (int i = 0; i<hor; i++) {
            for (int j = 0; j<3; j++) {
                if (i*3 + j >= count) {
                    break;
                }
                UIView *v = [self getDisplayView:(int)index :i :j];
                [_view2 addSubview:v];
            }
        }
        return _view2;
    } else if (index % 3 == 2){
        while ([_view3.subviews lastObject] != nil){//删除cell上的子视图
            [[_view3.subviews lastObject] removeFromSuperview];
        }
        //计算当前页有多少file要显示
        long number = index*(3*[self getVerticalCount]);//已经展示多少个
        long count = (self.assets.count - number)>(3*[self getVerticalCount])?3*[self getVerticalCount]:(self.assets.count - number);
        long hor = count / 3;
        if (count % 3 > 0) {
            hor = hor + 1;
        }
        for (int i = 0; i<hor; i++) {
            for (int j = 0; j<3; j++) {
                if (i*3 + j >= count) {
                    break;
                }
                UIView *v = [self getDisplayView:(int)index :i :j];
                [_view3 addSubview:v];
            }
        }
        return _view3;
    }
    return view;
}

-(void)loadAssets{
    self.assetLibrary = nil;
    self.assetLibrary = [[ALAssetsLibrary alloc] init];
    void (^assetBlock)(ALAsset *result, NSUInteger index, BOOL *stop) = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result != nil) {
            NSString *assetType = [result valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypePhoto]) {
                NSURL *url = result.defaultRepresentation.url;
                [_assetLibrary assetForURL:url
                               resultBlock:^(ALAsset *asset) {
                                   if (asset) {
                                       @synchronized(_assets) {
                                           [_assets addObject:asset];
                                       }
                                   }
                               }
                              failureBlock:^(NSError *error){
                                  NSLog(@"operation was not successfull!");
                              }];
            }
        }else {
            [_swipeView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [_hud hide:YES];
        }
    };
    
    void (^enumerationBlock)(ALAssetsGroup *group, BOOL *stop) = ^(ALAssetsGroup *group, BOOL *stop){
        if (group != nil) {
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetBlock];
        }
    };
    
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:enumerationBlock failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(int)getVerticalCount{
    int number = (ScreenHeight - 108) / 80;
    int remainder = ((int)ScreenHeight - 108) % 80;
    if (remainder >= 40) {
        number = number + 1;
    }
    return number;
}

//横竖位置，相当于二维数组中索引
-(UIView *)getDisplayView:(int)index :(int)indexH :(int)indexV{
    int indexOf = index*(3*[self getVerticalCount])+indexH*3+indexV;
    ALAsset *asset = [self.assets objectAtIndex:indexOf];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10*(indexV + 1) + (ScreenWidth - 40)/3.0*indexV, 80*indexH, (ScreenWidth - 40)/3.0, 75)];
    v.tag = index*1000 + indexH*100 + indexV;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, v.frame.size.width, 75)];
    [btn setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:NO];

    [v addSubview:btn];
    return v;
}

-(void)scanAction:(UIButton *)sender{
    [super scanAction:sender];
    [_swipeView reloadData];
    [_selectFileArray removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BaseViewDelegate
-(void)copyAction{
//    [kFTPManager.selectFileArray removeAllObjects];
//    [kFTPManager.selectFileArray addObjectsFromArray:_selectFileArray];
//    [kFTPManager.folderArray removeAllObjects];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.view makeToast:@"photoCopy" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
    [super scanAction:nil];
}
-(void)pasteAction{
    if (kFTPManager.selectFileArray.count > 0) {
        [_hud show:YES];
        BOOL isContains = [[kFTPManager.selectFileArray[0] allKeys] containsObject:@"NSFilePath"];
        if (!isContains) {//网络地址的复制
            dispatch_async(dispatch_get_main_queue(), ^{
//                for (NSDictionary *filePathInfo in kFTPManager.selectFileArray) {
//                    NSString *name = [filePathInfo objectForKey:@"fileName"];
//                    NSString *serverPath = [filePathInfo objectForKey:@"destPath"];
//                    NSURL *url = [NSURL URLWithString:dstPath];
//                    [kFMServer setDestination:serverPath];
//                    [kFTPManager downloadFile:name toDirectory:url fromServer:kFMServer];
//                }
//                [_hud hide:YES];
            });
        }else{
            for (NSDictionary *fileInfo in kFTPManager.selectFileArray) {
                NSString *nsFileType = [fileInfo objectForKey:@"NSFileType"];
                NSString *nsFilePath = [fileInfo objectForKey:@"NSFilePath"];
                //首先判断文件类型
                if ([nsFileType isEqualToString:@"NSFileTypeDirectory"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只能保存照片文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }else{
                    UIImage *image = [UIImage imageWithContentsOfFile:nsFilePath];
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }
            }
//            [_hud hide:YES];
        }
        [self.assets removeAllObjects];
        [self loadAssets];
    }else{
        [self.view makeToast:@"chooseFilePaste" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
    }
    [self scanAction:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != nil){
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:nil message:@"保存照片失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil buttonBlock:^(NSInteger index){
            [self loadAssets];
        }];
        [alert show];
    }
}
-(void)selectAllAction{
    [self.view makeToast:@"photoChooseAll" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
    [super scanAction:nil];
}
-(void)deleteAction{
    [self.view makeToast:@"photoDelete" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
    [super scanAction:nil];
}

@end
