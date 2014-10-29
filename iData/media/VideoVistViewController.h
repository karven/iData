//
//  VideoVistViewController.h
//  iData
//
//  Created by karven on 10/2/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SwipeView.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "FTPManager.h"

@interface VideoVistViewController:UIViewController<SwipeViewDataSource,SwipeViewDelegate>

@property(nonatomic,strong) ALAssetsLibrary *assetLibrary;
@property(nonatomic,strong) NSMutableArray *assets;

@end
