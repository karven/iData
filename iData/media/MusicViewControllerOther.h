//
//  MusicViewController.h
//  iData
//
//  Created by karven on 8/9/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Util.h"

@interface MusicViewControllerOther : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain) NSMutableDictionary *musicDic;
@property(nonatomic, retain) NSArray *keyArray;
@property(nonatomic, retain) UITableView *musicTable;
//@property(nonatomic, retain) MPMusicPlayerController *player;
@property(nonatomic, retain) AVAudioPlayer *player;
@property(nonatomic, retain) NSMutableArray *checkArray;            //多选选中的行
@property(nonatomic, retain) NSIndexPath *curIndexPath;             //当前选中的行
@property(nonatomic, assign) BOOL isPlay;                           //当前选中行的播放状态

@end
