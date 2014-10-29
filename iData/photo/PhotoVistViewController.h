//
//  PhotoVistViewController.h
//  iData
//
//  Created by karven on 9/7/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SwipeView.h"
#import "MBProgressHUD.h"
#import "CXImageBrowserView.h"
#import "UIView+Toast.h"
#import "FTPManager.h"
#import "BlockAlertView.h"

@interface PhotoVistViewController : BaseViewController<SwipeViewDataSource,SwipeViewDelegate,BaseViewDelegate>

@property(nonatomic,strong) NSMutableArray *photos;
@property(nonatomic,strong) NSMutableArray *thumbs;
@property(nonatomic,strong) ALAssetsLibrary *assetLibrary;
@property(nonatomic,strong) NSMutableArray *assets;

@end
