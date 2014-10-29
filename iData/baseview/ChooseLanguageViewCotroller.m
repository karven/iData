//
//  ChooseLanguageViewCotroller.m
//  iData
//
//  Created by karven on 9/22/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "ChooseLanguageViewCotroller.h"

@interface ChooseLanguageViewCotroller ()

@end

@implementation ChooseLanguageViewCotroller

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?20:0, ScreenWidth, 44)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:navigationView.bounds];
    [imageView setImage:[UIImage imageNamed:@"background"]];
    [navigationView addSubview:imageView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    [backBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationView addSubview:backBtn];
    
    ThemeLabel *titleLabel = [UIFactory createLabel:@"languageTitle"];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFrame:CGRectMake((ScreenWidth-150)/2.0, 10, 150, 25)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:titleLabel];
    
    [self.view addSubview:navigationView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight - (VER_IS_IOS7?64:44))];
    [backgroundImageView setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backgroundImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 225)/2.0, 84, 225, 65)];
    [logoImageView setImage:[UIImage imageNamed:@"logo_image"]];
    [self.view addSubview:logoImageView];
    
    UILabel *chineseLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-80)/2.0, logoImageView.frame.origin.y + logoImageView.frame.size.height + 65, 80, 40)];
    [chineseLabel setBackgroundColor:[UIColor clearColor]];
    [chineseLabel setText:@"简体中文"];
    [chineseLabel setTextAlignment:NSTextAlignmentCenter];
    UIButton *backupToBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImageView.frame)+60, ScreenWidth-40, 50)];
    backupToBtn.tag = ELANGUAGE_Chinese;
    [backupToBtn setBackgroundImage:[UIImage imageNamed:@"contacts_unpress"] forState:UIControlStateNormal];
    [backupToBtn setBackgroundImage:[UIImage imageNamed:@"contacts_press"] forState:UIControlStateHighlighted];
    [backupToBtn addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *englishLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-80)/2.0, backupToBtn.frame.origin.y + backupToBtn.frame.size.height + 25, 80, 40)];
    [englishLabel setBackgroundColor:[UIColor clearColor]];
    [englishLabel setText:@"English"];
    [englishLabel setTextAlignment:NSTextAlignmentCenter];
    UIButton *backupFromBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backupToBtn.frame)+20, ScreenWidth-40, 50)];
    backupFromBtn.tag = ELANGUAGE_English;
    [backupFromBtn setBackgroundImage:[UIImage imageNamed:@"contacts_unpress"] forState:UIControlStateNormal];
    [backupFromBtn setBackgroundImage:[UIImage imageNamed:@"contacts_press"] forState:UIControlStateHighlighted];
    [backupFromBtn addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chineseLabel];
    [self.view addSubview:backupToBtn];
    [self.view addSubview:englishLabel];
    [self.view addSubview:backupFromBtn];
}

-(void)leftBtnPressed:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)changeLanguage:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if (tag == ELANGUAGE_Chinese) {
        [kThemeManager setUserlanguage:@"zh-Hans"];
        //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kLanguageDidChangeNofication object:@"zh_Hans"];
    }else{
        [kThemeManager setUserlanguage:@"en"];
        //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kLanguageDidChangeNofication object:@"en"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
