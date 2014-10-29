//
//  MusicViewController.h
//  iData
//
//  Created by karven on 9/7/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "SwipeView.h"
#import "FTPManager.h"
#import "Util.h"
#import "UIView+Toast.h"
#import "BlockAlertView.h"
#import "FileCopy.h"

@interface MusicViewController : BaseViewController<SwipeViewDataSource,SwipeViewDelegate,BaseViewDelegate>{
    NSMutableArray *photoFileList;
}

//@property(nonatomic, retain) AVAudioPlayer *player;
@property(nonatomic,retain) NSMutableArray *selectFileArray;        //在编辑的情况下所选中的文件或文件夹

@end
