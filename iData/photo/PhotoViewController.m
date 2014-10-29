//
//  PhotoViewController.m
//  iData
//
//  Created by karven on 7/30/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property(nonatomic,retain) MBProgressHUD *hud;
@property(nonatomic,retain) SwipeView *swipeView;
@property(nonatomic,retain) UITapGestureRecognizer *tapGesture;
@property(nonatomic,retain) NSMutableArray *assets;
@property(nonatomic,retain) ALAssetsLibrary *assetLibrary;
@property(nonatomic,retain) UIScrollView *view1,*view2,*view3;
@property(nonatomic,retain) NSMutableArray *fileList;

@end

@implementation PhotoViewController
@synthesize selectFileArray;

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
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    self.delegate = self;
    
    _fileList = [NSMutableArray array];
    photoFileList = [NSMutableArray array];
    
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight-(VER_IS_IOS7?64:44)-44)];
    [_swipeView addGestureRecognizer:_tapGesture];
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.pagingEnabled = YES;
    [_swipeView scrollToItemAtIndex:0 duration:0];
    [self.view addSubview:_swipeView];
    
    _view1 = [[UIScrollView alloc] initWithFrame:_swipeView.bounds];
    _view2 = [[UIScrollView alloc] initWithFrame:_swipeView.bounds];
    _view3 = [[UIScrollView alloc] initWithFrame:_swipeView.bounds];
    
    int vertical = [Util getVerticalCount];
    
    [_view1 setContentSize:CGSizeMake(ScreenWidth, vertical * 120)];
    [_view2 setContentSize:CGSizeMake(ScreenWidth, vertical * 120)];
    [_view3 setContentSize:CGSizeMake(ScreenWidth, vertical * 120)];
    
    [self loadFile];
}

-(void)loadFile{
    [_fileList removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableString *dirPath = [NSMutableString string];
        for (NSString *s in kFTPManager.folderArray) {
            [dirPath appendString:[NSString stringWithFormat:@"%@/",s]];
        }
        [self.titleLabel setText:dirPath];
        if (ALAssetsLibrary.authorizationStatus == ALAuthorizationStatusAuthorized && [[dirPath substringToIndex:dirPath.length-1] isEqualToString:PhotoRootDirectory]) {
            [_fileList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"照片库",@"NSFileName",@"NSFileTypeDirectory",@"NSFileType", nil]];
        }
        
        NSArray *array = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
        for (NSString *fileName in array) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
            NSDictionary *dic = [fileManager attributesOfItemAtPath:filePath error:nil];
            NSMutableDictionary *fileInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSString *type = [fileInfo objectForKey:@"NSFileType"];
            [fileInfo setObject:fileName forKey:@"NSFileName"];
            [fileInfo setObject:filePath forKey:@"NSFilePath"];
            
            NSString *str = [Util stringByReversed:fileName];
            NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] uppercaseString];
            if ([type isEqualToString:@"NSFileTypeDirectory"]) {
                [_fileList addObject:fileInfo];
                continue;
            }
            if([suffix isEqualToString:@"GIF"] || [suffix isEqualToString:@"PNG"] || [suffix isEqualToString:@"JPG"] || [suffix isEqualToString:@"BMP"] || [suffix isEqualToString:@"TIFF"] || [suffix isEqualToString:@"PSD"] || [suffix isEqualToString:@"SWF"] || [suffix isEqualToString:@"SVG"] || [suffix isEqualToString:@"JPEG"]){
                
                [_fileList addObject:fileInfo];
                [photoFileList addObject:fileInfo];
            }
        }
        [_hud hide:YES];
        [_swipeView reloadData];
    });
}

#pragma mark UITapGestureRecognizer Action
-(void)handleTap:(UITapGestureRecognizer *)tap{
    UIView *currentView = _swipeView.currentItemView;
    UIView *currentItemView = nil;
    NSArray *array = [currentView subviews];
    CGPoint point = [tap locationInView:currentView];
    if (point.y > (ScreenHeight-44 - (VER_IS_IOS7?64:44))) {
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
        int indexInFileList = index * [Util getVerticalCount] * 3 + indexH * 3 + indexV;
        NSDictionary *fileDicInfo = [_fileList objectAtIndex:indexInFileList];
        NSString *type = [fileDicInfo objectForKey:@"NSFileType"];
        NSString *fileName = [fileDicInfo objectForKey:@"NSFileName"];
        
        if ([self.isStatus isEqualToString:@"scan"]) {
            if ([type isEqualToString:@"NSFileTypeDirectory"]) {
                if (indexInFileList == 0 && ALAssetsLibrary.authorizationStatus == ALAuthorizationStatusAuthorized && [fileName isEqualToString:@"照片库"]) {
                    //读取照片库中的图片
                    PhotoVistViewController *vistVC = [[PhotoVistViewController alloc] init];
                    [self.navigationController pushViewController:vistVC animated:YES];
                }else{
                    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
                    [kFTPManager.folderArray addObject:fileName];
                    [self.navigationController pushViewController:photoVC animated:YES];
                }
            }else{
                NSString *str = [Util stringByReversed:fileName];
                NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] uppercaseString];
                if([suffix isEqualToString:@"GIF"] || [suffix isEqualToString:@"PNG"] || [suffix isEqualToString:@"JPG"] || [suffix isEqualToString:@"BMP"] || [suffix isEqualToString:@"TIFF"] || [suffix isEqualToString:@"PSD"] || [suffix isEqualToString:@"SWF"] || [suffix isEqualToString:@"SVG"] || [suffix isEqualToString:@"JPEG"]){
                    
                    int index = (int)[photoFileList indexOfObject:fileDicInfo];
                    CXImageBrowserView *browser = [CXImageBrowserView imageBrowserSource:photoFileList select:nil startIndex:index];
                    [self.view addSubview:browser];
                    
//                    ROOTVIEW.view.userInteractionEnabled = NO;
                    browser.center = CGPointMake(self.view.center.x+self.view.frame.size.width, self.view.center.y);
                    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
                        browser.center = self.view.center;
                    }completion:^(BOOL finished) {
//                        ROOTVIEW.view.userInteractionEnabled = YES;
                    }];
                }
            }
        }else{
            if (indexInFileList == 0 && ALAssetsLibrary.authorizationStatus == ALAuthorizationStatusAuthorized && [fileName isEqualToString:@"照片库"]) {
                [self.view makeToast:@"photLibrary" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
                [self scanAction:nil];
                return;
            }
            NSArray *viewArray = [currentItemView subviews];
            for (UIView *v in viewArray) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    if (v.hidden) {
                        [v setHidden:NO];
                        [selectFileArray addObject:[NSString stringWithFormat:@"%d",tag]];
                    }else{
                        [v setHidden:YES];
                        [selectFileArray removeObject:[NSString stringWithFormat:@"%d",tag]];
                    }
                }
            }
        }
    }
}

#pragma mark SwipeView DataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    long totalNumber = _fileList.count;
    long count = totalNumber / (3 * [Util getVerticalCount]);
    int remainder = totalNumber % (3 * [Util getVerticalCount]);
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
        long number= index*(3*[Util getVerticalCount]);
        long count = (_fileList.count - number)>(3*[Util getVerticalCount])?3*[Util getVerticalCount]:(_fileList.count - number);
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
        long number = index*(3*[Util getVerticalCount]);
        long count = (_fileList.count - number)>(3*[Util getVerticalCount])?3*[Util getVerticalCount]:(_fileList.count - number);
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
        long number = index*(3*[Util getVerticalCount]);//已经展示多少个
        long count = (_fileList.count - number)>(3*[Util getVerticalCount])?3*[Util getVerticalCount]:(_fileList.count - number);
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

//横竖位置，相当于二维数组中索引
-(UIView *)getDisplayView:(int)index :(int)indexH :(int)indexV{
    int indexOf = index*(3*[Util getVerticalCount])+indexH*3+indexV;
    NSDictionary *dic = [_fileList objectAtIndex:indexOf];
    NSString *type = [dic objectForKey:@"NSFileType"];
    NSString *fileName = [dic objectForKey:@"NSFileName"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10*(indexV + 1) + (ScreenWidth - 40)/3.0*indexV, 120*indexH, (ScreenWidth - 40)/3.0, 120)];
    v.tag = index*1000 + indexH*100 + indexV;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 80, 70)];
    if ([type isEqualToString:@"NSFileTypeDirectory"]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"folder_icon"] forState:UIControlStateNormal];
    }else{
        NSString *str = [Util stringByReversed:fileName];
        NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] uppercaseString];
        if ([suffix isEqualToString:@"RTFD"] || [suffix isEqualToString:@"TXT"]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"txt_icon"] forState:UIControlStateNormal];
        }else if([suffix isEqualToString:@"DOC"] || [suffix isEqualToString:@"DOCX"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"doc_icon"] forState:UIControlStateNormal];
        }else if([suffix isEqualToString:@"XLS"] || [suffix isEqualToString:@"XLSX"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"xls_icon"] forState:UIControlStateNormal];
        }else if([suffix isEqualToString:@"PPT"] || [suffix isEqualToString:@"PPTX"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"ppt_icon"] forState:UIControlStateNormal];
        }else if([suffix isEqualToString:@"PDF"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"pdf_icon"] forState:UIControlStateNormal];
        }else if([suffix isEqualToString:@"GIF"] || [suffix isEqualToString:@"PNG"] || [suffix isEqualToString:@"JPG"] || [suffix isEqualToString:@"BMP"] || [suffix isEqualToString:@"TIFF"] || [suffix isEqualToString:@"PSD"] || [suffix isEqualToString:@"SWF"] || [suffix isEqualToString:@"SVG"] || [suffix isEqualToString:@"JPEG"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"pic_icon"] forState:UIControlStateNormal];
        }else if([suffix isEqualToString:@"RMVB"] || [suffix isEqualToString:@"RM"] || [suffix isEqualToString:@"WMV"] || [suffix isEqualToString:@"AVI"] || [suffix isEqualToString:@"MOV"] || [suffix isEqualToString:@"MPEG"] || [suffix isEqualToString:@"ASF"] || [suffix isEqualToString:@"MP4"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"video_icon"] forState:UIControlStateNormal];
        }else if([suffix isEqualToString:@"MP3"] || [suffix isEqualToString:@"WMA"] || [suffix isEqualToString:@"WAV"] || [suffix isEqualToString:@"OGG"] || [suffix isEqualToString:@"AC3"] || [suffix isEqualToString:@"AIFF"] || [suffix isEqualToString:@"DAT"]){
            [btn setBackgroundImage:[UIImage imageNamed:@"music_icon"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"default_icon"] forState:UIControlStateNormal];
        }
    }
    [btn setUserInteractionEnabled:NO];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"selected"]];
    [imageView setHidden:YES];
    if ([self.isStatus isEqualToString:@"edit"]) {
//        if ([selectFileArray containsObject:[NSString stringWithFormat:@"%d",index*1000 + indexH*100 + indexV]]) {
//            [imageView setHidden:NO];
//        }
        for (NSDictionary *info in selectFileArray) {
            if ([_fileList containsObject:info] && [fileName isEqualToString:[info objectForKey:@"NSFileName"]]) {
                [imageView setHidden:NO];
                break;
            }
        }
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, (ScreenWidth - 40)/3.0, 40)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:fileName];
    
    CGSize size;
    if (VER_IS_IOS7) {
        size = [title.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(title.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:title.font} context:nil].size;
    }else{
        size = [fileName sizeWithFont:title.font
                    constrainedToSize:CGSizeMake(CGRectGetWidth(title.frame), CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    if (size.height >= 40.562) {
        size = CGSizeMake(size.width, 40.562);
        title.numberOfLines = ceilf(size.height/title.font.lineHeight);
        [title setFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, size.height)];
    }
	
    title.textAlignment = NSTextAlignmentCenter;
    
    [v addSubview:btn];
    [v addSubview:imageView];
    [v addSubview:title];
    return v;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BaseViewDelegate
-(void)copyAction{
    if (selectFileArray.count < 1) {
        [self.view makeToast:@"chooseFileCopy" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
        [self scanAction:nil];
        return;
    }
    [kFTPManager.selectFileArray removeAllObjects];
    [kFTPManager.selectFileArray addObjectsFromArray:selectFileArray];
    [kFTPManager.folderArray removeAllObjects];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)pasteAction{
    //定义目标地址
    NSMutableString *dstPath = [NSMutableString string];
    for (NSString *s in kFTPManager.folderArray) {
        [dstPath appendString:[NSString stringWithFormat:@"%@/",s]];
    }
    if (kFTPManager.selectFileArray.count > 0) {
        [_hud show:YES];
        BOOL isContains = [[kFTPManager.selectFileArray[0] allKeys] containsObject:@"NSFilePath"];
        if (!isContains) {//网络地址的复制
//            dispatch_async(dispatch_get_main_queue(), ^{
                for (NSDictionary *filePathInfo in kFTPManager.selectFileArray) {
                    NSString *name = [filePathInfo objectForKey:@"kCFFTPResourceName"];
                    NSString *serverPath = [filePathInfo objectForKey:@"kCFFTPResourcePath"];
                    NSString *fileType = [filePathInfo objectForKey:@"kCFFTPResourceType"];
                    if ([fileType intValue]==4) {//文件夹
                        [FileCopy copyRemoteFile:serverPath withRemoteDir:name withDstPath:dstPath];
                    }else{//文件
                        NSURL *url = [NSURL URLWithString:[dstPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        [kFMServer setDestination:serverPath];
                        [kFTPManager downloadFile:name toDirectory:url fromServer:kFMServer];
                    }
                }
                [self loadFile];
//            });
        }else{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"提示" message:@"存在同名文件覆盖？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" buttonBlock:^(NSInteger index) {
                if (index==1) {
                    for (NSDictionary *fileInfo in kFTPManager.selectFileArray) {
                        NSString *nsFileType = [fileInfo objectForKey:@"NSFileType"];
                        NSString *nsFileName = [fileInfo objectForKey:@"NSFileName"];
                        NSString *nsFilePath = [fileInfo objectForKey:@"NSFilePath"];
                        NSString *destFilePath = [NSString stringWithFormat:@"%@%@",dstPath,nsFileName];
                        //首先判断文件类型
                        if ([nsFileType isEqualToString:@"NSFileTypeDirectory"]) {
                            BOOL isflag = YES;
                            //如果存在同名的文件夹
                            if ([fileManager fileExistsAtPath:destFilePath isDirectory:&isflag]) {
                                //如果需要复制的文件夹中含有除音乐类型之外的文件，则禁止复制操作
                                BOOL flag = [Util isPasteFile:nsFilePath dstType:@"photo"];
                                if (flag) {
//                                    [FileCopy copyFile:nsFilePath toPath:destFilePath];
                                }else{
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只能复制视频类文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alertView show];
                                }
                            }else{
                                BOOL flag = [Util isPasteFile:nsFilePath dstType:@"photo"];
                                if (flag) {
                                    [fileManager copyItemAtPath:nsFilePath toPath:destFilePath error:nil];
                                }else{
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"只能复制视频类文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alertView show];
                                }
                            }
                        }else{
                            //存在该文件先删除，然后再复制
                            if ([fileManager fileExistsAtPath:destFilePath]) {
                                [self.view makeToast:@"isExist" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
                            }else{
                                [fileManager copyItemAtPath:nsFilePath toPath:destFilePath error:nil];
                            }
                        }
                    }
                    [self loadFile];
                }
            }];
            [alert show];
        }
    }else{
        [self.view makeToast:@"chooseFileCopy" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
    }
    [self scanAction:nil];
}

-(void)selectAllAction{
    [selectFileArray removeAllObjects];
    [selectFileArray addObjectsFromArray:_fileList];
    [_swipeView reloadData];
}
-(void)deleteAction{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSDictionary *dic in selectFileArray) {
        NSString *s = [dic objectForKey:@"NSFilePath"];
        BOOL flag = [fileManager removeItemAtPath:s error:nil];
        if (flag) {
            [_fileList removeObject:dic];
        }
    }
    [self performSelector:@selector(deleteDuration) withObject:nil afterDelay:1];
    [_swipeView reloadData];
}

-(void)deleteDuration{
    [self scanAction:nil];
}

@end
