//
//  MainViewController.m
//  iData
//
//  Created by karven on 7/22/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "MainViewController.h"
#import "UIFactory.h"
#import "ThemeManager.h"
#import "FTPManager.h"
#import "LocalFolderViewController.h"
#import "FileViewController.h"
#import "MusicViewController.h"
#import "ContactBackupViewController.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initLeftView{
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 225)/2.0, 10, 225, 65)];
    [logoImageView setImage:[UIImage imageNamed:@"logo_image"]];
    [leftMainView addSubview:logoImageView];
    UIImageView *logoLabel = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 116 -10, logoImageView.frame.origin.y + logoImageView.frame.size.height + 5, 116, 13)];
    [logoLabel setImage:[UIImage imageNamed:@"logo_label"]];
    [leftMainView addSubview:logoLabel];
    UIImageView *logoDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0, logoLabel.frame.origin.y + logoLabel.frame.size.height + 2, ScreenWidth, 1)];
    [logoDivider setImage:[UIImage imageNamed:@"logo_divider"]];
    [leftMainView addSubview:logoDivider];
    
    leftMainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, logoDivider.frame.origin.y + 10, ScreenWidth, ScreenHeight - logoDivider.frame.origin.y - 10 - 64)];
    [leftMainScrollView setContentSize:CGSizeMake(ScreenWidth, 75*4+4*5)];
    [leftMainScrollView addGestureRecognizer:tapLeftGestue];
    [leftMainView addSubview:leftMainScrollView];
    
    leftRouter = [[UIView alloc] initWithFrame:CGRectMake(10, 0, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftRouter setBackgroundColor:[Util colorFromColorString:@"#78b7b9"]];
    UIImageView *leftRouterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"router_setting"]];
    [leftRouterImage setFrame:CGRectMake((leftRouter.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftRouter addSubview:leftRouterImage];
    ThemeLabel *leftRouterLabel = [UIFactory createLabel:@"router"];
    [leftRouterLabel setBackgroundColor:[UIColor clearColor]];
    [leftRouterLabel setFrame:CGRectMake(3, leftRouterImage.frame.origin.y + leftRouterImage.frame.size.height + 5, leftRouter.frame.size.width - 5, 15)];
    [leftRouterLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftRouterLabel setTextColor:[UIColor whiteColor]];
    [leftRouter addSubview:leftRouterLabel];
    [leftMainScrollView addSubview:leftRouter];
    
    leftMusic = [[UIView alloc] initWithFrame:CGRectMake(leftRouter.frame.origin.x + leftRouter.frame.size.width +15, 0, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftMusic setBackgroundColor:[Util colorFromColorString:@"#6f4ec0"]];
    UIImageView *leftMusicImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music"]];
    [leftMusicImage setFrame:CGRectMake((leftMusic.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftMusic addSubview:leftMusicImage];
    ThemeLabel *leftMusicLabel = [UIFactory createLabel:@"music"];
    [leftMusicLabel setBackgroundColor:[UIColor clearColor]];
    [leftMusicLabel setFrame:CGRectMake(3, leftMusicImage.frame.origin.y + leftMusicImage.frame.size.height + 5, leftMusic.frame.size.width - 5, 15)];
    [leftMusicLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftMusicLabel setTextColor:[UIColor whiteColor]];
    [leftMusic addSubview:leftMusicLabel];
    [leftMainScrollView addSubview:leftMusic];
    
    leftContact = [[UIView alloc] initWithFrame:CGRectMake(10, leftRouter.frame.origin.y + leftRouter.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftContact setBackgroundColor:[Util colorFromColorString:@"#bed14c"]];
    UIImageView *leftContactImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contacts_backup"]];
    [leftContactImage setFrame:CGRectMake((leftContact.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftContact addSubview:leftContactImage];
    ThemeLabel *leftContactLabel = [UIFactory createLabel:@"contact"];
    [leftContactLabel setBackgroundColor:[UIColor clearColor]];
    [leftContactLabel setFrame:CGRectMake(3, leftContactImage.frame.origin.y + leftContactImage.frame.size.height + 5, leftContact.frame.size.width - 5, 15)];
    [leftContactLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftContactLabel setTextColor:[UIColor whiteColor]];
    [leftContact addSubview:leftContactLabel];
    [leftMainScrollView addSubview:leftContact];
    
    leftVideo = [[UIView alloc] initWithFrame:CGRectMake(leftContact.frame.origin.x + leftContact.frame.size.width +15, leftRouter.frame.origin.y + leftRouter.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftVideo setBackgroundColor:[Util colorFromColorString:@"#008fa4"]];
    UIImageView *leftVideoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video"]];
    [leftVideoImage setFrame:CGRectMake((leftVideo.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftVideo addSubview:leftVideoImage];
    ThemeLabel *leftVideoLabel = [UIFactory createLabel:@"video"];
    [leftVideoLabel setBackgroundColor:[UIColor clearColor]];
    [leftVideoLabel setFrame:CGRectMake(3, leftVideoImage.frame.origin.y + leftVideoImage.frame.size.height + 5, leftVideo.frame.size.width - 5, 15)];
    [leftVideoLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftVideoLabel setTextColor:[UIColor whiteColor]];
    [leftVideo addSubview:leftVideoLabel];
    [leftMainScrollView addSubview:leftVideo];
    
    leftLanguage = [[UIView alloc] initWithFrame:CGRectMake(10, leftContact.frame.origin.y + leftContact.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftLanguage setBackgroundColor:[Util colorFromColorString:@"#db5730"]];
    UIImageView *leftLanguageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"language"]];
    [leftLanguageImage setFrame:CGRectMake((leftLanguage.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftLanguage addSubview:leftLanguageImage];
    ThemeLabel *leftLanguageLabel = [UIFactory createLabel:@"language"];
    [leftLanguageLabel setBackgroundColor:[UIColor clearColor]];
    [leftLanguageLabel setFrame:CGRectMake(3, leftLanguageImage.frame.origin.y + leftLanguageImage.frame.size.height + 5, leftLanguage.frame.size.width - 5, 15)];
    [leftLanguageLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftLanguageLabel setTextColor:[UIColor whiteColor]];
    [leftLanguage addSubview:leftLanguageLabel];
    [leftMainScrollView addSubview:leftLanguage];
    
    leftPhoto = [[UIView alloc] initWithFrame:CGRectMake(leftLanguage.frame.origin.x + leftLanguage.frame.size.width +15, leftVideo.frame.origin.y + leftVideo.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftPhoto setBackgroundColor:[Util colorFromColorString:@"#76b0c9"]];
    UIImageView *leftPhotoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo"]];
    [leftPhotoImage setFrame:CGRectMake((leftPhoto.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftPhoto addSubview:leftPhotoImage];
    ThemeLabel *leftPhotoLabel = [UIFactory createLabel:@"photo"];
    [leftPhotoLabel setBackgroundColor:[UIColor clearColor]];
    [leftPhotoLabel setFrame:CGRectMake(3, leftPhotoImage.frame.origin.y + leftPhotoImage.frame.size.height + 5, leftPhoto.frame.size.width - 5, 15)];
    [leftPhotoLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftPhotoLabel setTextColor:[UIColor whiteColor]];
    [leftPhoto addSubview:leftPhotoLabel];
    [leftMainScrollView addSubview:leftPhoto];
    
    leftFolder = [[UIView alloc] initWithFrame:CGRectMake(10, leftLanguage.frame.origin.y + leftLanguage.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftFolder setBackgroundColor:[Util colorFromColorString:@"#4a97d8"]];
    UIImageView *leftFolderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"folder"]];
    [leftFolderImage setFrame:CGRectMake((leftFolder.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftFolder addSubview:leftFolderImage];
    ThemeLabel *leftFolderLabel = [UIFactory createLabel:@"folder"];
    [leftFolderLabel setBackgroundColor:[UIColor clearColor]];
    [leftFolderLabel setFrame:CGRectMake(3, leftFolderImage.frame.origin.y + leftFolderImage.frame.size.height + 5, leftFolder.frame.size.width - 5, 15)];
    [leftFolderLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftFolderLabel setTextColor:[UIColor whiteColor]];
    [leftFolder addSubview:leftFolderLabel];
    [leftMainScrollView addSubview:leftFolder];
    
    leftDocument = [[UIView alloc] initWithFrame:CGRectMake(leftFolder.frame.origin.x + leftFolder.frame.size.width +15, leftPhoto.frame.origin.y + leftPhoto.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [leftDocument setBackgroundColor:[Util colorFromColorString:@"#a102a9"]];
    UIImageView *leftDocumentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"document"]];
    [leftDocumentImage setFrame:CGRectMake((leftDocument.frame.size.width-51)/2.0, 5, 51, 51)];
    [leftDocument addSubview:leftDocumentImage];
    ThemeLabel *leftDocumentLabel = [UIFactory createLabel:@"document"];
    [leftDocumentLabel setBackgroundColor:[UIColor clearColor]];
    [leftDocumentLabel setFrame:CGRectMake(3, leftDocumentImage.frame.origin.y + leftDocumentImage.frame.size.height + 5, leftDocument.frame.size.width - 5, 15)];
    [leftDocumentLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [leftDocumentLabel setTextColor:[UIColor whiteColor]];
    [leftDocument addSubview:leftDocumentLabel];
    [leftMainScrollView addSubview:leftDocument];
}

-(void)initRightView{
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 225)/2.0, 10, 225, 65)];
    [logoImageView setImage:[UIImage imageNamed:@"logo_image"]];
    [rightMainView addSubview:logoImageView];
    UIImageView *logoLabel = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 116 -10, logoImageView.frame.origin.y + logoImageView.frame.size.height + 5, 116, 13)];
    [logoLabel setImage:[UIImage imageNamed:@"logo_label"]];
    [rightMainView addSubview:logoLabel];
    UIImageView *logoDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0, logoLabel.frame.origin.y + logoLabel.frame.size.height + 2, ScreenWidth, 1)];
    [logoDivider setImage:[UIImage imageNamed:@"logo_divider"]];
    [rightMainView addSubview:logoDivider];
    
    rightMainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, logoDivider.frame.origin.y + 10, ScreenWidth, ScreenHeight - logoDivider.frame.origin.y - 10 - 64)];
    [rightMainScrollView setContentSize:CGSizeMake(ScreenWidth, 75*5+5*5)];
    [rightMainScrollView addGestureRecognizer:tapRightGestue];
    [rightMainView addSubview:rightMainScrollView];
    
    rightConnection = [[UIView alloc] initWithFrame:CGRectMake(10, 0, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightConnection setBackgroundColor:[Util colorFromColorString:@"#b8b875"]];
    rightConnectionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connected"]];
    [rightConnectionImage setFrame:CGRectMake((rightConnection.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightConnection addSubview:rightConnectionImage];
    rightConnectionLabel = [UIFactory createLabel:@"unconnect"];
    [rightConnectionLabel setBackgroundColor:[UIColor clearColor]];
    [rightConnectionLabel setFrame:CGRectMake(3, rightConnectionImage.frame.origin.y +rightConnectionImage.frame.size.height + 5, rightConnection.frame.size.width - 5, 15)];
    [rightConnectionLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightConnectionLabel setTextColor:[UIColor whiteColor]];
    [rightConnection addSubview:rightConnectionLabel];
    [rightMainScrollView addSubview:rightConnection];
    
    rightMusic = [[UIView alloc] initWithFrame:CGRectMake(rightConnection.frame.origin.x + rightConnection.frame.size.width +15, 0, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightMusic setBackgroundColor:[Util colorFromColorString:@"#6f4ec0"]];
    UIImageView *rightMusicImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music"]];
    [rightMusicImage setFrame:CGRectMake((rightMusic.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightMusic addSubview:rightMusicImage];
    ThemeLabel *rightMusicLabel = [UIFactory createLabel:@"music"];
    [rightMusicLabel setBackgroundColor:[UIColor clearColor]];
    [rightMusicLabel setFrame:CGRectMake(3, rightMusicImage.frame.origin.y + rightMusicImage.frame.size.height + 5, rightMusic.frame.size.width - 5, 15)];
    [rightMusicLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightMusicLabel setTextColor:[UIColor whiteColor]];
    [rightMusic addSubview:rightMusicLabel];
    [rightMainScrollView addSubview:rightMusic];
    
    rightRouter = [[UIView alloc] initWithFrame:CGRectMake(10, rightConnection.frame.origin.y + rightConnection.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightRouter setBackgroundColor:[Util colorFromColorString:@"#78b7b9"]];
    UIImageView *rightRouterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"router_setting"]];
    [rightRouterImage setFrame:CGRectMake((rightRouter.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightRouter addSubview:rightRouterImage];
    ThemeLabel *rightRouterLabel = [UIFactory createLabel:@"router"];
    [rightRouterLabel setBackgroundColor:[UIColor clearColor]];
    [rightRouterLabel setFrame:CGRectMake(3, rightRouterImage.frame.origin.y + rightRouterImage.frame.size.height + 5, rightRouter.frame.size.width - 5, 15)];
    [rightRouterLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightRouterLabel setTextColor:[UIColor whiteColor]];
    [rightRouter addSubview:rightRouterLabel];
    [rightMainScrollView addSubview:rightRouter];
    
    rightVideo = [[UIView alloc] initWithFrame:CGRectMake(rightRouter.frame.origin.x + rightRouter.frame.size.width +15, rightMusic.frame.origin.y + rightMusic.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightVideo setBackgroundColor:[Util colorFromColorString:@"#008fa4"]];
    UIImageView *rightVideoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video"]];
    [rightVideoImage setFrame:CGRectMake((rightVideo.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightVideo addSubview:rightVideoImage];
    ThemeLabel *rightVideoLabel = [UIFactory createLabel:@"video"];
    [rightVideoLabel setBackgroundColor:[UIColor clearColor]];
    [rightVideoLabel setFrame:CGRectMake(3, rightVideoImage.frame.origin.y + rightVideoImage.frame.size.height + 5, rightVideo.frame.size.width - 5, 15)];
    [rightVideoLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightVideoLabel setTextColor:[UIColor whiteColor]];
    [rightVideo addSubview:rightVideoLabel];
    [rightMainScrollView addSubview:rightVideo];
    
    rightContact = [[UIView alloc] initWithFrame:CGRectMake(10, rightRouter.frame.origin.y + rightRouter.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightContact setBackgroundColor:[Util colorFromColorString:@"#bed14c"]];
    UIImageView *rightContactImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contacts_backup"]];
    [rightContactImage setFrame:CGRectMake((rightContact.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightContact addSubview:rightContactImage];
    ThemeLabel *rightContactLabel = [UIFactory createLabel:@"contact"];
    [rightContactLabel setBackgroundColor:[UIColor clearColor]];
    [rightContactLabel setFrame:CGRectMake(3, rightContactImage.frame.origin.y + rightContactImage.frame.size.height + 5, rightContact.frame.size.width - 5, 15)];
    [rightContactLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightContactLabel setTextColor:[UIColor whiteColor]];
    [rightContact addSubview:rightContactLabel];
    [rightMainScrollView addSubview:rightContact];
    
    rightPhoto = [[UIView alloc] initWithFrame:CGRectMake(rightContact.frame.origin.x + rightContact.frame.size.width +15, rightVideo.frame.origin.y + rightVideo.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightPhoto setBackgroundColor:[Util colorFromColorString:@"#76b0c9"]];
    UIImageView *rightPhotoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo"]];
    [rightPhotoImage setFrame:CGRectMake((rightPhoto.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightPhoto addSubview:rightPhotoImage];
    ThemeLabel *rightPhotoLabel = [UIFactory createLabel:@"photo"];
    [rightPhotoLabel setBackgroundColor:[UIColor clearColor]];
    [rightPhotoLabel setFrame:CGRectMake(3, rightPhotoImage.frame.origin.y + rightPhotoImage.frame.size.height + 5, rightPhoto.frame.size.width - 5, 15)];
    [rightPhotoLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightPhotoLabel setTextColor:[UIColor whiteColor]];
    [rightPhoto addSubview:rightPhotoLabel];
    [rightMainScrollView addSubview:rightPhoto];
    
    rightLanguage = [[UIView alloc] initWithFrame:CGRectMake(10, rightContact.frame.origin.y + rightContact.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightLanguage setBackgroundColor:[Util colorFromColorString:@"#db5730"]];
    UIImageView *rightLanguageImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"language"]];
    [rightLanguageImage setFrame:CGRectMake((rightLanguage.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightLanguage addSubview:rightLanguageImage];
    ThemeLabel *rightLanguageLabel = [UIFactory createLabel:@"language"];
    [rightLanguageLabel setBackgroundColor:[UIColor clearColor]];
    [rightLanguageLabel setFrame:CGRectMake(3, rightLanguageImage.frame.origin.y + rightLanguageImage.frame.size.height + 5, rightLanguage.frame.size.width - 5, 15)];
    [rightLanguageLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightLanguageLabel setTextColor:[UIColor whiteColor]];
    [rightLanguage addSubview:rightLanguageLabel];
    [rightMainScrollView addSubview:rightLanguage];
    
    rightDocument = [[UIView alloc] initWithFrame:CGRectMake(rightLanguage.frame.origin.x + rightLanguage.frame.size.width +15, rightPhoto.frame.origin.y + rightPhoto.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightDocument setBackgroundColor:[Util colorFromColorString:@"#a102a9"]];
    UIImageView *rightDocumentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"document"]];
    [rightDocumentImage setFrame:CGRectMake((rightDocument.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightDocument addSubview:rightDocumentImage];
    ThemeLabel *rightDocumentLabel = [UIFactory createLabel:@"document"];
    [rightDocumentLabel setBackgroundColor:[UIColor clearColor]];
    [rightDocumentLabel setFrame:CGRectMake(3, rightDocumentImage.frame.origin.y + rightDocumentImage.frame.size.height + 5, rightDocument.frame.size.width - 5, 15)];
    [rightDocumentLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightDocumentLabel setTextColor:[UIColor whiteColor]];
    [rightDocument addSubview:rightDocumentLabel];
    [rightMainScrollView addSubview:rightDocument];
    
    rightZone = [[UIView alloc] initWithFrame:CGRectMake(10, rightLanguage.frame.origin.y + rightLanguage.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightZone setBackgroundColor:[Util colorFromColorString:@"#009f00"]];
    UIImageView *rightZoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"use_size"]];
    [rightZoneImage setFrame:CGRectMake((rightZone.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightZone addSubview:rightZoneImage];
    ThemeLabel *rightZoneLabel = [UIFactory createLabel:@"zone"];
    [rightZoneLabel setBackgroundColor:[UIColor clearColor]];
    [rightZoneLabel setFrame:CGRectMake(3, rightZoneImage.frame.origin.y + rightZoneImage.frame.size.height + 5, rightZone.frame.size.width - 5, 15)];
    [rightZoneLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightZoneLabel setTextColor:[UIColor whiteColor]];
    [rightZone addSubview:rightZoneLabel];
    [rightMainScrollView addSubview:rightZone];
    
    rightFolder = [[UIView alloc] initWithFrame:CGRectMake(rightZone.frame.origin.x + rightZone.frame.size.width +15, rightDocument.frame.origin.y + rightDocument.frame.size.height + 5, (ScreenWidth - 2*10 - 15)/2.0, 75)];
    [rightFolder setBackgroundColor:[Util colorFromColorString:@"#4a97d8"]];
    UIImageView *rightFolderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"folder"]];
    [rightFolderImage setFrame:CGRectMake((rightFolder.frame.size.width-51)/2.0, 5, 51, 51)];
    [rightFolder addSubview:rightFolderImage];
    ThemeLabel *rightFolderLabel = [UIFactory createLabel:@"folder"];
    [rightFolderLabel setBackgroundColor:[UIColor clearColor]];
    [rightFolderLabel setFrame:CGRectMake(3, rightFolderImage.frame.origin.y + rightFolderImage.frame.size.height + 5, rightFolder.frame.size.width - 5, 15)];
    [rightFolderLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [rightFolderLabel setTextColor:[UIColor whiteColor]];
    [rightFolder addSubview:rightFolderLabel];
    [rightMainScrollView addSubview:rightFolder];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:nil failureBlock:nil];
    
    location = @"left";
    leftMainView = [[UIView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight-(VER_IS_IOS7?64:44))];
    rightMainView = [[UIView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight-(VER_IS_IOS7?64:44))];
    self.navigationController.navigationBar.hidden = YES;
    
    //添加手势
    tapLeftGestue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapRightGestue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [imageView setFrame:CGRectMake(0, VER_IS_IOS7?20:0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:imageView];
    
    //主页左视图
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?20:0, ScreenWidth/2, 44)];
    [leftView setBackgroundColor:[Util colorFromColorString:@"#0c5c94"]];
    UILabel *leftLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 3)];
    [leftLineLabel setBackgroundColor:[Util colorFromColorString:@"#b7d1e0"]];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (44 - 3 - 18)/2.0, 19.5, 18)];
    [leftImageView setImage:[UIImage imageNamed:@"star_select"]];
    
    ThemeLabel *leftTitleLabel = [UIFactory createLabel:@"local"];
    [leftTitleLabel setBackgroundColor:[UIColor clearColor]];
    [leftTitleLabel setFrame:CGRectMake(leftImageView.frame.origin.x + leftImageView.frame.size.width + 5, leftImageView.frame.origin.y, 110, 20)];
    [leftTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [leftTitleLabel setTextColor:[UIColor whiteColor]];
    [leftView addSubview:leftLineLabel];
    [leftView addSubview:leftImageView];
    [leftView addSubview:leftTitleLabel];
    //主页右视图
    rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width, VER_IS_IOS7?20:0, ScreenWidth/2, 44)];
    [rightView setBackgroundColor:[Util colorFromColorString:@"#0e7dca"]];
    UILabel *rightLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 3)];
    [rightLineLabel setBackgroundColor:[Util colorFromColorString:@"#b7d1e0"]];
    rightLineLabel.hidden = YES;
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (44 - 3 - 18)/2.0, 19.5, 18)];
    [rightImageView setImage:[UIImage imageNamed:@"cloud_unselect"]];
    ThemeLabel *rightTitleLabel = [UIFactory createLabel:@"remote"];
    [rightTitleLabel setBackgroundColor:[UIColor clearColor]];
    [rightTitleLabel setFrame:CGRectMake(rightImageView.frame.origin.x + rightImageView.frame.size.width + 5, rightImageView.frame.origin.y, 110, 20)];
    [rightTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [rightTitleLabel setTextColor:[UIColor grayColor]];
    [rightView addSubview:rightLineLabel];
    [rightView addSubview:rightImageView];
    [rightView addSubview:rightTitleLabel];
    
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    
    [self initLeftView];
    [self initRightView];
    
    swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight-(VER_IS_IOS7?64:44))];
    [swipeView setUserInteractionEnabled:YES];
    swipeView.delegate = self;
    swipeView.dataSource = self;
    swipeView.pagingEnabled = YES;
    [swipeView scrollToItemAtIndex:0 duration:0];
    [self.view addSubview:swipeView];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(isConnectRemote) userInfo:nil repeats:YES];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
        BOOL isDir = YES;
        
        if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/folder",documentsDirectoryPath] isDirectory:&isDir]) {
        }else{
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/folder",documentsDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/document",documentsDirectoryPath] isDirectory:&isDir]) {
        }else{
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/document",documentsDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/music",documentsDirectoryPath] isDirectory:&isDir]) {
        }else{
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/music",documentsDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/video",documentsDirectoryPath] isDirectory:&isDir]) {
        }else{
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/video",documentsDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/photo",documentsDirectoryPath] isDirectory:&isDir]) {
        }else{
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/photo",documentsDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
}

-(void)isConnectRemote{
    NSLog(@"NSTimer timer......");
    
//    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSURL *requestURL = [NSURL URLWithString:@"http://192.168.169.1"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
        [urlRequest setTimeoutInterval:2.0f];
        [urlRequest setHTTPMethod:@"GET"];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:4];
        if (responseStr.length>100) {
            [rightConnectionImage setImage:[UIImage imageNamed:@"connected"]];
            [rightConnectionLabel setTextWithTitleKey:@"connect"];
        }else{
            [rightConnectionImage setImage:[UIImage imageNamed:@"connected"]];
            [rightConnectionLabel setTextWithTitleKey:@"unconnect"];
        }
//    });
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return 2;
}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (index==0) {
        return leftMainView;
    }
    return rightMainView;
}
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipe{
    int index = (int)swipe.currentItemIndex;
    if (index==0) {
        [self handle:@"right"];
        location = @"left";
    }else{
        [self handle:@"left"];
        location = @"right";
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if(CGRectContainsPoint(leftView.frame, point) && ![location isEqualToString:@"left"]){
        [self handle:@"right"];
        location = @"left";
        swipeView.currentPage = 0;
    }else if(CGRectContainsPoint(rightView.frame, point) && ![location isEqualToString:@"right"]){
        [self handle:@"left"];
        location = @"right";
        swipeView.currentPage = 1;
    }
    [swipeView reloadData];
}

-(void)handleTapFrom:(UITapGestureRecognizer *)tap{
    NSLog(@"MainViewController UITapGestureRecognizer");
    [kFTPManager.folderArray removeAllObjects];
    if ([location isEqualToString:@"left"]) {
        [kFTPManager.folderArray addObject:RootDirectory];
        CGPoint point = [tap locationInView:leftMainScrollView];
        if(CGRectContainsPoint(leftRouter.frame, point)){
            [self.view makeToast:@"feature" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
        }else if(CGRectContainsPoint(leftMusic.frame, point)){
            MusicViewController *music = [[MusicViewController alloc] init];
            [kFTPManager.folderArray addObject:@"music"];
            [self.navigationController pushViewController:music animated:YES];
        }else if (CGRectContainsPoint(leftContact.frame, point)){
            ContactBackupViewController *contactVC = [[ContactBackupViewController alloc] init];
            [self.navigationController pushViewController:contactVC animated:YES];
        }else if (CGRectContainsPoint(leftVideo.frame, point)){
            VideoViewController *video = [[VideoViewController alloc] init];
            [kFTPManager.folderArray addObject:@"video"];
            [self.navigationController pushViewController:video animated:YES];
        }else if (CGRectContainsPoint(leftLanguage.frame, point)){
            ChooseLanguageViewCotroller *language = [[ChooseLanguageViewCotroller alloc] init];
            [self.navigationController pushViewController:language animated:YES];
        }else if (CGRectContainsPoint(leftPhoto.frame, point)){
            PhotoViewController *photo = [[PhotoViewController alloc] init];
            [kFTPManager.folderArray addObject:@"photo"];
            [self.navigationController pushViewController:photo animated:YES];
        }else if (CGRectContainsPoint(leftFolder.frame, point)){
            LocalFolderViewController *localVC = [[LocalFolderViewController alloc] init];
            [kFTPManager.folderArray addObject:@"folder"];
            [self.navigationController pushViewController:localVC animated:YES];
        }else if (CGRectContainsPoint(leftDocument.frame, point)){
            FileViewController *fileVC = [[FileViewController alloc] init];
            [kFTPManager.folderArray addObject:@"document"];
            [self.navigationController pushViewController:fileVC animated:YES];
        }
    }else{
        [kFTPManager.folderArray addObject:RootURL];
        CGPoint point = [tap locationInView:rightMainScrollView];
        if(CGRectContainsPoint(rightRouter.frame, point)){
            [self.view makeToast:@"feature" duration:3 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2,ScreenHeight-74)]];
        }else if(CGRectContainsPoint(rightMusic.frame, point)){
            FolderViewController *folderVC = [[FolderViewController alloc] init];
            [kFMServer setDestination:RootURL];
            folderVC.fileType = @"music";
            [self.navigationController pushViewController:folderVC animated:YES];
        }else if (CGRectContainsPoint(rightContact.frame, point)){
            ContactBackupViewController *contactVC = [[ContactBackupViewController alloc] init];
            [self.navigationController pushViewController:contactVC animated:YES];
        }else if (CGRectContainsPoint(rightVideo.frame, point)){
            FolderViewController *folderVC = [[FolderViewController alloc] init];
            [kFMServer setDestination:RootURL];
            folderVC.fileType = @"video";
            [self.navigationController pushViewController:folderVC animated:YES];
        }else if (CGRectContainsPoint(rightLanguage.frame, point)){
            ChooseLanguageViewCotroller *language = [[ChooseLanguageViewCotroller alloc] init];
            [self.navigationController pushViewController:language animated:YES];
        }else if (CGRectContainsPoint(rightPhoto.frame, point)){
            FolderViewController *folderVC = [[FolderViewController alloc] init];
            [kFMServer setDestination:RootURL];
            folderVC.fileType = @"picture";
            [self.navigationController pushViewController:folderVC animated:YES];
        }else if (CGRectContainsPoint(rightFolder.frame, point)){
            FolderViewController *folderVC = [[FolderViewController alloc] init];
            [kFMServer setDestination:RootURL];
            [self.navigationController pushViewController:folderVC animated:YES];
        }else if (CGRectContainsPoint(rightDocument.frame, point)){
            FolderViewController *folderVC = [[FolderViewController alloc] init];
            [kFMServer setDestination:RootURL];
            folderVC.fileType = @"document";
            [self.navigationController pushViewController:folderVC animated:YES];
        }else if (CGRectContainsPoint(rightConnection.frame, point)){
            NSLog(@"connection");
        }else if (CGRectContainsPoint(rightZone.frame, point)){
            NSLog(@"zone");
        }
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"right");
        
        [self handle:@"left"];
        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"left");
        
        [self handle:@"right"];
        recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    }
}

-(void)handle:(NSString *)direction{
    if ([direction isEqualToString:@"left"]) {
        location = @"right";
        UILabel *leftDivider = (UILabel *)leftView.subviews[0];
        leftDivider.hidden = YES;
        UILabel *rightDivider = (UILabel *)rightView.subviews[0];
        rightDivider.hidden = NO;
        [leftView setBackgroundColor:[Util colorFromColorString:@"#0e7dca"]];
        [rightView setBackgroundColor:[Util colorFromColorString:@"#0c5c94"]];
        UIImageView *rightImageView = (UIImageView *)rightView.subviews[1];
        [rightImageView setImage:[UIImage imageNamed:@"cloud_selected"]];
        ThemeLabel *rightLabel = (ThemeLabel *)rightView.subviews[2];
        [rightLabel setTextColor:[UIColor whiteColor]];
        UIImageView *leftImageView = (UIImageView *)leftView.subviews[1];
        [leftImageView setImage:[UIImage imageNamed:@"star_unselect"]];
        ThemeLabel *leftLabel = (ThemeLabel *)leftView.subviews[2];
        [leftLabel setTextColor:[UIColor grayColor]];
    }else{
        location = @"left";
        UILabel *leftDivider = (UILabel *)leftView.subviews[0];
        leftDivider.hidden = NO;
        UILabel *rightDivider = (UILabel *)rightView.subviews[0];
        rightDivider.hidden = YES;
        [rightView setBackgroundColor:[Util colorFromColorString:@"#0e7dca"]];
        [leftView setBackgroundColor:[Util colorFromColorString:@"#0c5c94"]];
        UIImageView *rightImageView = (UIImageView *)rightView.subviews[1];
        [rightImageView setImage:[UIImage imageNamed:@"cloud_unselect"]];
        ThemeLabel *rightLabel = (ThemeLabel *)rightView.subviews[2];
        [rightLabel setTextColor:[UIColor grayColor]];
        UIImageView *leftImageView = (UIImageView *)leftView.subviews[1];
        [leftImageView setImage:[UIImage imageNamed:@"star_select"]];
        ThemeLabel *leftLabel = (ThemeLabel *)leftView.subviews[2];
        [leftLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
-(void)visitPhoto{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    if (self.assets.count > 0) {
        for (ALAsset *asset in self.assets) {
            [photos addObject:[MWPhoto photoWithURL:asset.defaultRepresentation.url]];
            [thumbs addObject:[MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]]];
        }
    }
    
    self.photos = photos;
    self.thumbs = thumbs;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    // Reset selections
//    if (displaySelectionButtons) {
//        _selections = [NSMutableArray new];
//        for (int i = 0; i < photos.count; i++) {
//            [_selections addObject:[NSNumber numberWithBool:NO]];
//        }
//    }
    
    // Push
    [self.navigationController pushViewController:browser animated:YES];
}
*/
-(void)visitContact{
    ContactViewController *contactVC = [[ContactViewController alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

-(void)visitMusic{
    MusicViewController *musicVC = [[MusicViewController alloc] init];
    [self.navigationController pushViewController:musicVC animated:YES];
}

@end
