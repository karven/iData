//
//  FolderViewController.m
//  iData
//
//  Created by karven on 8/26/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "FolderViewController.h"

@interface FolderViewController ()

@property(nonatomic,retain) MBProgressHUD *hud;

@end

@implementation FolderViewController
@synthesize selectFileArray,fileType;

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
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    selectFileArray = [NSMutableArray array];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.delegate = self;
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    self.delegate = self;
    
    [self.titleLabel setText:kFMServer.destination];
    
    [self loadFile];
    
    swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight-(VER_IS_IOS7?64:44)-44)];
    [swipeView addGestureRecognizer:tapGesture];
    swipeView.delegate = self;
    swipeView.dataSource = self;
    swipeView.pagingEnabled = YES;
    [swipeView scrollToItemAtIndex:0 duration:0];
    [self.view addSubview:swipeView];
    
    view1 = [[UIScrollView alloc] initWithFrame:swipeView.bounds];
    view2 = [[UIScrollView alloc] initWithFrame:swipeView.bounds];
    view3 = [[UIScrollView alloc] initWithFrame:swipeView.bounds];
    
    int vertical = [Util getVerticalCount];
    
    [view1 setContentSize:CGSizeMake(ScreenWidth, vertical * 120)];
    [view2 setContentSize:CGSizeMake(ScreenWidth, vertical * 120)];
    [view3 setContentSize:CGSizeMake(ScreenWidth, vertical * 120)];
}

-(void)loadFile{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array = [kFTPManager contentsOfServer:kFMServer];
        fileList = [NSMutableArray array];
        if ([fileType isEqualToString:@"music"]) {
            for (NSDictionary *dic in array) {
                int type = [[dic objectForKey:@"kCFFTPResourceType"] intValue];
                NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
                if (type == 4) {
                    [fileList addObject:dic];
                }else{
                    NSString *str = [Util stringByReversed:fileName];
                    NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] lowercaseString];
                    if ([suffix isEqualToString:@"mp3"] || [suffix isEqualToString:@"wma"] || [suffix isEqualToString:@"wav"] || [suffix isEqualToString:@"ogg"] || [suffix isEqualToString:@"ac3"] || [suffix isEqualToString:@"aiff"] || [suffix isEqualToString:@"dat"]) {
                        [fileList addObject:dic];
                    }
                }
            }
        }else if ([fileType isEqualToString:@"video"]){
            for (NSDictionary *dic in array) {
                int type = [[dic objectForKey:@"kCFFTPResourceType"] intValue];
                NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
                if (type == 4) {
                    [fileList addObject:dic];
                }else{
                    NSString *str = [Util stringByReversed:fileName];
                    NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] lowercaseString];
                    if ([suffix isEqualToString:@"rmvb"] || [suffix isEqualToString:@"rm"] || [suffix isEqualToString:@"wmv"] || [suffix isEqualToString:@"avi"] || [suffix isEqualToString:@"mov"] || [suffix isEqualToString:@"mpeg"] || [suffix isEqualToString:@"asf"] || [suffix isEqualToString:@"mp4"]) {
                        [fileList addObject:dic];
                    }
                }
            }
        }else if ([fileType isEqualToString:@"picture"]){
            for (NSDictionary *dic in array) {
                int type = [[dic objectForKey:@"kCFFTPResourceType"] intValue];
                NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
                if (type == 4) {
                    [fileList addObject:dic];
                }else{
                    NSString *str = [Util stringByReversed:fileName];
                    NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] lowercaseString];
                    if ([suffix isEqualToString:@"gif"] || [suffix isEqualToString:@"png"] || [suffix isEqualToString:@"jpg"] || [suffix isEqualToString:@"bmp"] || [suffix isEqualToString:@"tiff"] || [suffix isEqualToString:@"psd"] || [suffix isEqualToString:@"swf"] || [suffix isEqualToString:@"svg"] || [suffix isEqualToString:@"jpeg"]) {
                        [fileList addObject:dic];
                    }
                }
            }
        }else if ([fileType isEqualToString:@"document"]){
            for (NSDictionary *dic in array) {
                int type = [[dic objectForKey:@"kCFFTPResourceType"] intValue];
                NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
                if (type == 4) {
                    [fileList addObject:dic];
                }else{
                    NSString *str = [Util stringByReversed:fileName];
                    NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] lowercaseString];
                    if (![suffix isEqualToString:@"gif"] && ![suffix isEqualToString:@"png"] && ![suffix isEqualToString:@"jpg"] && ![suffix isEqualToString:@"bmp"] && ![suffix isEqualToString:@"tiff"] && ![suffix isEqualToString:@"psd"] && ![suffix isEqualToString:@"swf"] && ![suffix isEqualToString:@"svg"] && ![suffix isEqualToString:@"jpeg"] && ![suffix isEqualToString:@"rmvb"] && ![suffix isEqualToString:@"rm"] && ![suffix isEqualToString:@"wmv"] && ![suffix isEqualToString:@"avi"] && ![suffix isEqualToString:@"mov"] && ![suffix isEqualToString:@"mpeg"] && ![suffix isEqualToString:@"asf"] && ![suffix isEqualToString:@"mp4"] && ![suffix isEqualToString:@"mp3"] && ![suffix isEqualToString:@"wma"] && ![suffix isEqualToString:@"wav"] && ![suffix isEqualToString:@"ogg"] && ![suffix isEqualToString:@"ac3"] && ![suffix isEqualToString:@"aiff"] && ![suffix isEqualToString:@"dat"]) {
                        [fileList addObject:dic];
                    }
                }
            }
        }else{
            fileList = [NSMutableArray arrayWithArray:array];
        }
        [swipeView reloadData];
        [_hud hide:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITapGestureRecognizer Action
-(void)handleTap:(UITapGestureRecognizer *)tap{
    UIView *currentView = swipeView.currentItemView;
    UIView *currentItemView = nil;
    NSArray *array = [currentView subviews];
    CGPoint point = [tap locationInView:currentView];
    if (point.y > (ScreenHeight-44 -(VER_IS_IOS7?64:44))) {
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
        NSDictionary *fileDicInfo = [fileList objectAtIndex:indexInFileList];
        int type = [[fileDicInfo objectForKey:@"kCFFTPResourceType"] intValue];
        NSString *fileName = [fileDicInfo objectForKey:@"kCFFTPResourceName"];
        
        if ([self.isStatus isEqualToString:@"scan"]) {
            NSMutableString *dstPath = [NSMutableString string];
            for (NSString *s in kFTPManager.folderArray) {
                [dstPath appendString:[NSString stringWithFormat:@"%@/",s]];
            }
            if (type == 4) {
                FolderViewController *folderVC = [[FolderViewController alloc] init];
                [kFTPManager.folderArray addObject:fileName];
                [dstPath appendString:[NSString stringWithFormat:@"%@/",fileName]];
                [kFMServer setDestination:dstPath];
                folderVC.fileType = fileType;
                [self.navigationController pushViewController:folderVC animated:YES];
            }else{
                FileContentViewController *fileContent = [[FileContentViewController alloc] init];
                [dstPath appendString:fileName];
                NSString *srcPath = [dstPath stringByReplacingCharactersInRange:NSMakeRange(0, 13) withString:@"http://192.168.169.1:8080"];
                fileContent.fileName = srcPath;
                [self.navigationController pushViewController:fileContent animated:YES];
            }
        }else{
            NSArray *viewArray = [currentItemView subviews];
            for (UIView *v in viewArray) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    if (v.hidden) {
                        [v setHidden:NO];
                        [selectFileArray addObject:fileDicInfo];
                    }else{
                        [v setHidden:YES];
                        [selectFileArray removeObject:fileDicInfo];
                    }
                }
            }
        }
    }
}

#pragma mark SwipeView DataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    long count = ((long)fileList.count) / (3 * [Util getVerticalCount]);
    int remainder = fileList.count % (3 * [Util getVerticalCount]);
    if (remainder > 0) {
        count = count + 1;
    }
    return count;
}
- (UIView *)swipeView:(SwipeView *)swipeView1 viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (index % 3 == 0) {
        while ([view1.subviews lastObject] != nil){//删除cell上的子视图
            [[view1.subviews lastObject] removeFromSuperview];
        }
        //计算当前页有多少file要显示
        long number= index*(3*[Util getVerticalCount]);
        long count = (fileList.count - number)>(3*[Util getVerticalCount])?3*[Util getVerticalCount]:(fileList.count - number);
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
                [view1 addSubview:v];
            }
        }
        return view1;
    } else if (index % 3 == 1){
        while ([view2.subviews lastObject] != nil){//删除cell上的子视图
            [[view2.subviews lastObject] removeFromSuperview];
        }
        //计算当前页有多少file要显示
        long number = index*(3*[Util getVerticalCount]);
        long count = (fileList.count - number)>(3*[Util getVerticalCount])?3*[Util getVerticalCount]:(fileList.count - number);
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
                [view2 addSubview:v];
            }
        }
        return view2;
    } else if (index % 3 == 2){
        while ([view3.subviews lastObject] != nil){//删除cell上的子视图
            [[view3.subviews lastObject] removeFromSuperview];
        }
        //计算当前页有多少file要显示
        long number = index*(3*[Util getVerticalCount]);//已经展示多少个
        long count = (fileList.count - number)>(3*[Util getVerticalCount])?3*[Util getVerticalCount]:(fileList.count - number);
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
                [view3 addSubview:v];
            }
        }
        return view3;
    }
    return view;
}

//横竖位置，相当于二维数组中索引
-(UIView *)getDisplayView:(int)index :(int)indexH :(int)indexV{
    int indexOf = index*(3*[Util getVerticalCount])+indexH*3+indexV;
    NSDictionary *dic = [fileList objectAtIndex:indexOf];
    int type = [[dic objectForKey:@"kCFFTPResourceType"] intValue];
    NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(10*(indexV + 1) + (ScreenWidth - 40)/3.0*indexV, 120*indexH, (ScreenWidth - 40)/3.0, 120)];
    v.tag = index*1000 + indexH*100 + indexV;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 80, 70)];
    if (type == 4) {
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
    
    //显示选择文件或文件夹状态
    if ([self.isStatus isEqualToString:@"edit"]) {
        for (NSDictionary *info in selectFileArray) {
            if ([fileList containsObject:info] && [fileName isEqualToString:[info objectForKey:@"kCFFTPResourceName"]]) {
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

#pragma mark 实现父类的按钮方法
-(void)scanAction:(UIButton *)sender{
    [super scanAction:sender];
    [swipeView reloadData];
    [selectFileArray removeAllObjects];
}

-(void)editAction:(UIButton *)sender{
    [super editAction:sender];
    [swipeView reloadData];
}

#pragma mark BaseViewDelegate
-(void)copyAction{
    NSLog(@"%s",__FUNCTION__);
    [kFTPManager.selectFileArray removeAllObjects];
    NSMutableArray *array = kFTPManager.folderArray;
    NSMutableString *path = [NSMutableString string];
    for (NSString *str in array) {
        [path appendString:[NSString stringWithFormat:@"%@/",str]];
    }
    for (NSDictionary *dic in selectFileArray) {
//        NSString *p = [dic objectForKey:@"kCFFTPResourceName"];
        [dic setValue:path forKey:@"kCFFTPResourcePath"];
        [kFTPManager.selectFileArray addObject:dic];
    }
    [kFTPManager.folderArray removeAllObjects];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)pasteAction{
    NSLog(@"%s",__FUNCTION__);
    if ([kFTPManager.selectFileArray count]>0) {
        [_hud show:YES];
        BOOL isContains = [[kFTPManager.selectFileArray[0] allKeys] containsObject:@"NSFilePath"];
        if (!isContains) {//网络地址的复制，文件先下载到本地，然后上传到idata
            
        }else{
            NSMutableString *dstPath = [NSMutableString string];
            for (NSString *s in kFTPManager.folderArray) {
                [dstPath appendString:[NSString stringWithFormat:@"%@/",s]];
            }
            [kFMServer setDestination:dstPath];
            for (NSDictionary *info in kFTPManager.selectFileArray) {
                NSString *nsFileType = [info objectForKey:@"NSFileType"];
                NSString *nsFileName = [info objectForKey:@"NSFileName"];
                NSString *nsFilePath = [info objectForKey:@"NSFilePath"];
                //首先判断文件类型
                if ([nsFileType isEqualToString:@"NSFileTypeDirectory"]) {
                    [self copyFile:nsFileName withSrcPath:nsFilePath withDstPath:dstPath];
                }else{
                    [kFTPManager uploadFile:[NSURL URLWithString:[nsFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] toServer:kFMServer];
                }
            }
            [self loadFile];
        }
        [_hud hide:YES];
    }else{
        [self.view makeToast:@"chooseFilePaste" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
    }
}

-(void)copyFile:(NSString *)dirName withSrcPath:(NSString *)srcPath withDstPath:(NSString *)dstPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    [kFTPManager createNewFolder:dirName atServer:kFMServer];
    for (NSString *fileName in fileArray) {
        //文件夹下某个文件的路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",srcPath,fileName];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
        NSString *type = [fileAttributes objectForKey:@"NSFileType"];
        NSString *destPath = [NSString stringWithFormat:@"%@%@/",dstPath,dirName];
        [kFMServer setDestination:destPath];
        if ([type isEqualToString:@"NSFileTypeDirectory"]) {
            [self copyFile:fileName withSrcPath:filePath withDstPath:destPath];
        }else{
            [kFTPManager uploadFile:[NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] toServer:kFMServer];
        }
    }
}

-(void)selectAllAction{
    [selectFileArray removeAllObjects];
    [selectFileArray addObjectsFromArray:fileList];
    [swipeView reloadData];
}
-(void)deleteAction{
    [_hud show:YES];
    for (NSDictionary *dic in selectFileArray) {
        if ([fileList containsObject:dic]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableString *path = [NSMutableString string];
                for (NSString *str in kFTPManager.folderArray) {
                    [path appendString:[NSString stringWithFormat:@"%@/",str]];
                }
                
                NSString *type = [dic objectForKey:@"kCFFTPResourceType"];
                NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
                if ([type intValue]==8) {
                    [kFTPManager deleteFileNamed:fileName fromServer:kFMServer];
                }else{
                    [self deleteFile:path withFileName:fileName];
                }
//            });
            [fileList removeObject:dic];
        }
    }
    [_hud hide:YES];
    [self performSelector:@selector(deleteDuration) withObject:nil afterDelay:1];
    [swipeView reloadData];
}

-(void)deleteFile:(NSString *)dirPath withFileName:(NSString *)name{
    NSString *dstPath = [dirPath stringByAppendingString:name];
    [kFMServer setDestination:dstPath];
    NSArray *fileArray = [kFTPManager contentsOfServer:kFMServer];
    for (NSDictionary *dic in fileArray) {
        NSString *type = [dic objectForKey:@"kCFFTPResourceType"];
        NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
        if ([type intValue] == 4) {
            [self deleteFile:[dirPath stringByAppendingString:@"/"] withFileName:fileName];
        }else{
            [kFTPManager deleteFileNamed:fileName fromServer:kFMServer];
        }
    }
    //删除当前文件夹
    [kFMServer setDestination:dirPath];
    BOOL isSuccess = [kFTPManager deleteFileNamed:name fromServer:kFMServer];
    if (isSuccess) {
        NSLog(@"success");
    }else{
        NSLog(@"fail");
    }
}

-(void)deleteDuration{
    [self scanAction:nil];
}

@end






