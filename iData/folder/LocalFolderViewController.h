//
//  LocalFolderViewController.h
//  iData
//
//  Created by karven on 9/8/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BaseViewController.h"
#import "SwipeView.h"
#import "MBProgressHUD.h"
#import "FTPManager.h"
#import "FileContentViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BlockAlertView.h"
#import "FileCopy.h"

@interface LocalFolderViewController : BaseViewController<SwipeViewDataSource,SwipeViewDelegate,BaseViewDelegate,MBProgressHUDDelegate>{
    NSMutableArray *fileList;
    UIScrollView *view1,*view2,*view3;
    SwipeView *swipeView;
    UITapGestureRecognizer *tapGesture;
}

@property(nonatomic,retain) NSMutableArray *selectFileArray;        //在编辑的情况下所选中的文件或文件夹

@end
