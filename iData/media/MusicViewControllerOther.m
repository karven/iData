//
//  MusicViewController.m
//  iData
//
//  Created by karven on 8/9/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "MusicViewControllerOther.h"

@implementation MusicViewControllerOther
@synthesize musicDic,musicTable,keyArray,player,curIndexPath,isPlay,checkArray;

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
    self.title = @"音乐";
    
//    player = [MPMusicPlayerController iPodMusicPlayer];
    
    musicDic = [NSMutableDictionary dictionary];
    keyArray = [NSArray array];
    checkArray = [NSMutableArray array];
    
    musicTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    musicTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    musicTable.dataSource = self;
    musicTable.delegate = self;
    [self.view addSubview:musicTable];
    
    [self getMusicFromLibrary];
    /*
//    self.navigationController.navigationBar.hidden = YES;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"ReadMe" ofType:@"txt"];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    webView.scalesPageToFit = YES;
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//    [self.view addSubview:webView];
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery songsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:paths[0] error:nil];
    for (MPMediaPlaylist *playlist in playlists) {
        NSArray *mediaItemsList = playlist.items;
        for (MPMediaItem *item in mediaItemsList) {
            NSString *mediaTitle = [item valueForProperty:MPMediaItemPropertyTitle];
            NSString *artistName = [item valueForProperty:MPMediaItemPropertyArtist];
            NSString *albumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSURL *mediaURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
            
            NSLog(@"artist=%@,album=%@",artistName,albumTitle);
        }
        continue;
        
        NSString *playListName = [playlist valueForProperty: MPMediaPlaylistPropertyName];
        NSLog(@"playListName=%@",playListName);
        if ([playListName isEqualToString:@"test"]) {
            
            NSArray *songs = [playlist items];
            for (MPMediaItem *song_item in songs) {
                NSString *songTitle = [song_item valueForProperty: MPMediaItemPropertyTitle];
                NSURL *url = [song_item valueForProperty:MPMediaItemPropertyAssetURL];
                NSLog(@"url is %@",url);
                
                AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset presetName: AVAssetExportPresetAppleM4A];
                
                exporter.outputFileType = @"com.apple.m4a-audio";
                NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
                NSString *exportFile = [documentsDirectoryPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.m4a",songTitle]];
                if ([[NSFileManager defaultManager] fileExistsAtPath:exportFile])
                {
                    NSError *deleteErr = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:exportFile error:&deleteErr];
                    if (deleteErr)
                    {
                        NSLog (@"Can't delete %@: %@", exportFile, deleteErr);
                    }
                }
                
                NSURL *path_url = [NSURL fileURLWithPath:exportFile];
                exporter.outputURL = path_url;
                [exporter exportAsynchronouslyWithCompletionHandler:^{
                    long exportStatus = exporter.status;
                    switch (exportStatus)
                    {
                        case AVAssetExportSessionStatusFailed:
                        {
                            // log error to text view
                            NSError *exportError = exporter.error;
                            NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                            break;
                        }
                        case AVAssetExportSessionStatusCompleted:
                        {
                            NSLog (@"AVAssetExportSessionStatusCompleted");
                            // set up AVPlayer
                            NSData *data = [NSData dataWithContentsOfURL:path_url];
                            NSLog(@"data is %@",data);
                            break;
                        }
                        case AVAssetExportSessionStatusUnknown:
                        {
                            NSLog (@"AVAssetExportSessionStatusUnknown");
                            break;
                        }
                        case AVAssetExportSessionStatusExporting:
                        {
                            NSLog (@"AVAssetExportSessionStatusExporting");
                            break;
                        }
                        case AVAssetExportSessionStatusCancelled:
                        {
                            NSLog (@"AVAssetExportSessionStatusCancelled");
                            break;
                        }
                        case AVAssetExportSessionStatusWaiting:
                        {
                            NSLog (@"AVAssetExportSessionStatusWaiting");
                            break;
                        }
                        default:
                        {
                            NSLog (@"didn't get export status");
                            break;
                        }
                    }
                }];
            }
        }
    }
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)getMusicFromLibrary{
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery songsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    for (MPMediaPlaylist *playlist in playlists) {
        NSArray *mediaItemsList = playlist.items;
        for (MPMediaItem *item in mediaItemsList) {
            
            NSString *mediaTitle = [item valueForProperty:MPMediaItemPropertyTitle];
            NSString *artistName = [item valueForProperty:MPMediaItemPropertyArtist];
            NSString *albumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSString *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
            
            NSString *pinyin = [Util getCCToPY:mediaTitle];
            NSString *pinyinFirstLetter = [pinyin substringToIndex:1]==nil?@"#":[pinyin substringToIndex:1];
            NSMutableArray *tempArray = [musicDic objectForKey:pinyinFirstLetter];
            if (tempArray == nil) {
                tempArray = [NSMutableArray array];
            }
            if (artistName == nil || [artistName isEqualToString:@""]) {
                artistName = @"未知";
            }
            if (albumTitle == nil || [albumTitle isEqualToString:@""]) {
                albumTitle = @"未知";
            }
            [tempArray addObject:[NSString stringWithFormat:@"%@&%@&%@&%@&%@",mediaTitle,artistName,albumTitle,item,url]];
            [musicDic setObject:tempArray forKey:pinyinFirstLetter];
        }
    }
    [self dictionaryValueSort:musicDic];
    keyArray = [self arraySort:[musicDic allKeys]];
}

-(NSArray *)arraySort:(NSArray *)array{
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        return [obj1 compare:obj2];
    };
    return [array sortedArrayUsingComparator:sort];
}

-(void)dictionaryValueSort:(NSMutableDictionary *)dictionary{
    NSArray *array = [dictionary allKeys];
    for (NSString *str in array) {
        NSArray *tempArray = [dictionary objectForKey:str];
        tempArray = [self arraySort:tempArray];
        [dictionary setObject:tempArray forKey:str];
    }
}

#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return keyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [keyArray objectAtIndex:section];
    NSArray *array = [musicDic objectForKey:key];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MusicTabelView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    while ([cell.contentView.subviews lastObject] != nil){//删除cell上的子视图
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    NSString *key = [keyArray objectAtIndex:indexPath.section];
    NSArray *array = [musicDic objectForKey:key];
    
    NSString *musicInfo = [array objectAtIndex:indexPath.row];
    NSArray *tempArray = [musicInfo componentsSeparatedByString:@"&"];
    
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    checkBtn.tag = indexPath.section * 1000 + indexPath.row;
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"fee_nopay"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:checkBtn];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 24)];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [nameLabel setText:tempArray[0]];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 28, 230, 16)];
    [subLabel setFont:[UIFont systemFontOfSize:15]];
    [subLabel setText:[NSString stringWithFormat:@"%@ - %@",tempArray[1],tempArray[2]]];
    [cell.contentView addSubview:subLabel];
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 15, 20, 20)];
    playBtn.tag = indexPath.section * 1000 + indexPath.row + 10000;
    playBtn.hidden = YES;
    [playBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:playBtn];
    
    if (curIndexPath && curIndexPath.row==indexPath.row && curIndexPath.section==indexPath.section) {
        if (isPlay) {
            playBtn.hidden = NO;
            [playBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_play"] forState:UIControlStateNormal];
        }else{
            playBtn.hidden = NO;
            [playBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_pause"] forState:UIControlStateNormal];
        }
    }
    
    int tag = indexPath.section * 1000 + indexPath.row;
    NSNumber *number = [NSNumber numberWithInteger:tag];
    if ([checkArray containsObject:number]) {
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"fee_payed"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = [keyArray objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [headerView setBackgroundColor:[Util colorFromRGB:@"245,245,245"]];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [lineLabel setBackgroundColor:[Util colorFromRGB:@"225,225,225"]];
    [headerView addSubview:lineLabel];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, ScreenWidth - 15, 20)];
    [titleLabel setText:title];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int tag = indexPath.section * 1000 + indexPath.row + 10000;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:tag];
    NSString *key = [keyArray objectAtIndex:indexPath.section];
    NSArray *array = [musicDic objectForKey:key];
    
    NSString *musicInfo = [array objectAtIndex:indexPath.row];
    NSArray *tempArray = [musicInfo componentsSeparatedByString:@"&"];
    
//    MPMediaItem *item = tempArray[3];
//    NSLog(@"%@",tempArray);
//    MPMediaItemCollection *collections = [[MPMediaItemCollection alloc] initWithItems:[NSArray arrayWithObject:item]];
//    [self.player setQueueWithItemCollection:collections];
//    
//    [self.player endSeeking];
    //添加后台播放代码：
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //以及设置app支持接受远程控制事件代码。设置app支持接受远程控制事件，
    //其实就是在dock中可以显示应用程序图标，同时点击该图片时，打开app。
    //或者锁屏时，双击home键，屏幕上方出现应用程序播放控制按钮。
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *playerError;
//    NSString *mediaURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
    //播放
    self.player = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:tempArray[4]] error:&playerError];
    
//    MPMusicPlaybackState playbackState = [self.player playbackState];
    if (curIndexPath != nil) {
        if (curIndexPath.section == indexPath.section && curIndexPath.row == indexPath.row) {
//            if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
//                [self.player setNowPlayingItem:item];
//                [self.player play];
//                self.isPlay = YES;
//                btn.hidden = NO;
//                [btn setBackgroundImage:[UIImage imageNamed:@"cm_btn_play"] forState:UIControlStateNormal];
//            } else if (playbackState == MPMusicPlaybackStatePlaying) {
                [self.player pause];
                btn.hidden = NO;
                self.isPlay = NO;
                [btn setBackgroundImage:[UIImage imageNamed:@"cm_btn_pause"] forState:UIControlStateNormal];
//            }
        }else{
//            [self.player setNowPlayingItem:item];
            [self.player play];
            self.isPlay = YES;
            btn.hidden = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"cm_btn_play"] forState:UIControlStateNormal];
        }
    }else{
//        [self.player setNowPlayingItem:item];
        [self.player play];
        self.isPlay = YES;
        btn.hidden = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"cm_btn_play"] forState:UIControlStateNormal];
    }
    
    curIndexPath = indexPath;
    [tableView reloadData];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    [player play];
}

-(void)checkAction:(UIButton *)sender{
    int tag = sender.tag;
    NSNumber *number = [NSNumber numberWithInteger:tag];
    if ([checkArray containsObject:number]) {
        [checkArray removeObject:number];
        [sender setBackgroundImage:[UIImage imageNamed:@"fee_nopayed"] forState:UIControlStateNormal];
    }else{
        [checkArray addObject:number];
        [sender setBackgroundImage:[UIImage imageNamed:@"fee_payed"] forState:UIControlStateNormal];
    }
}

-(void)btnAction{
    
}

@end
