//
//  VideoViewController.h
//  iData
//
//  Created by karven on 9/13/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SwipeView.h"
#import "MBProgressHUD.h"
#import "SwipeView.h"
#import "FTPManager.h"
#import "FileCopy.h"
#import "BlockAlertView.h"

@interface VideoViewController : BaseViewController<SwipeViewDataSource,SwipeViewDelegate,BaseViewDelegate>{
    NSMutableArray *photoFileList;
}

//@property(nonatomic, retain) AVAudioPlayer *player;
@property(nonatomic,retain) NSMutableArray *selectFileArray;        //在编辑的情况下所选中的文件或文件夹

@end
