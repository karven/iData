//
//  VideoVistViewController.m
//  iData
//
//  Created by karven on 10/2/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "VideoVistViewController.h"

@interface VideoVistViewController ()

@property(nonatomic,retain) MBProgressHUD *hud;
@property(nonatomic,retain) SwipeView *swipeView;
@property(nonatomic,retain) UITapGestureRecognizer *tapGesture;
@property(nonatomic,retain) UIScrollView *view1,*view2,*view3;

@end

@implementation VideoVistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:navigationView.bounds];
    [imageView setImage:[UIImage imageNamed:@"background"]];
    [navigationView addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(43, 9.5, ScreenWidth - 43, 25)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setLineBreakMode:NSLineBreakByTruncatingHead];
    [title setText:@"视频库"];
    [navigationView addSubview:title];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    [backBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:backBtn];
    [self.view addSubview:navigationView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    [backgroundImageView setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backgroundImageView];
    
    self.assets = [NSMutableArray array];
    self.assetLibrary = [[ALAssetsLibrary alloc] init];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
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

-(void)leftBtnPressed:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAssets{
    void (^assetBlock)(ALAsset *result, NSUInteger index, BOOL *stop) = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result != nil) {
            NSString *assetType = [result valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypeVideo]) {
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

#pragma mark UITapGestureRecognizer Action
-(void)handleTap:(UITapGestureRecognizer *)tap{
    UIView *currentView = _swipeView.currentItemView;
    UIView *currentItemView = nil;
    NSArray *array = [currentView subviews];
    CGPoint point = [tap locationInView:currentView];
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
        
        NSURL *url = asset.defaultRepresentation.url;
        MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
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

@end
