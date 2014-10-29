//
//  FolderViewController.h
//  iData
//
//  Created by karven on 8/26/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileContentViewController.h"
#import "SwipeView.h"
#import "FTPManager.h"
#import "MBProgressHUD.h"

@interface FolderViewController : BaseViewController<SwipeViewDataSource,SwipeViewDelegate,BaseViewDelegate,MBProgressHUDDelegate>{
    NSMutableArray *fileList;
    UIScrollView *view1,*view2,*view3;
    SwipeView *swipeView;
    UITapGestureRecognizer *tapGesture;
}

@property(nonatomic,retain) NSMutableArray *selectFileArray;        //在编辑的情况下所选中的文件或文件夹
@property(nonatomic,retain) NSString *fileType;                     //过滤文件类型

@end
