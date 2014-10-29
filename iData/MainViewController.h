//
//  MainViewController.h
//  iData
//
//  Created by karven on 7/22/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ContactViewController.h"
#import "PhotoViewController.h"
#import "MusicViewController.h"
#import "FolderViewController.h"
#import "VideoViewController.h"
#import "ChooseLanguageViewCotroller.h"
#import "SwipeView.h"

typedef enum{
	MV_Star_Tag ,
    MV_Left_Label_Tag ,
	MV_Cloud_Tag ,
	MV_Right_Label_Tag
} EMainView_tag;

@interface MainViewController : UIViewController<SwipeViewDataSource,SwipeViewDelegate>{
    SwipeView *swipeView;
    UIView *leftMainView,*rightMainView;
    UIView *leftView,*rightView;
    UIView *leftRouter,*leftMusic,*leftContact,*leftVideo,*leftLanguage,*leftPhoto,*leftFolder,*leftDocument;
    UIView *rightConnection,*rightMusic,*rightRouter,*rightVideo,*rightContact,*rightPhoto,*rightLanguage,*rightDocument,*rightZone,*rightFolder;
    UITapGestureRecognizer *tapLeftGestue,*tapRightGestue;
    UIScrollView *leftMainScrollView,*rightMainScrollView;
    NSString *location;                                                 //选择是本地还是iData
    UIImageView *rightConnectionImage;
    ThemeLabel *rightConnectionLabel;
}

@end
