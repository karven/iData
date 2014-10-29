//
//  PhotoViewController.h
//  iData
//
//  Created by karven on 7/30/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "SwipeView.h"
#import "CXImageBrowserView.h"
#import "FTPManager.h"
#import "FileCopy.h"

#import "PhotoVistViewController.h"

@interface PhotoViewController : BaseViewController<SwipeViewDataSource,SwipeViewDelegate,BaseViewDelegate>{
    NSMutableArray *photoFileList;
}

@property(nonatomic,retain) NSMutableArray *selectFileArray;        //在编辑的情况下所选中的文件或文件夹

@end
