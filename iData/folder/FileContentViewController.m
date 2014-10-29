//
//  FileContentViewController.m
//  iData
//
//  Created by karven on 9/4/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "FileContentViewController.h"

@interface FileContentViewController ()<UIWebViewDelegate>

@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) MBProgressHUD *hud;

@end

@implementation FileContentViewController

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
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:navigationView.bounds];
    [imageView setImage:[UIImage imageNamed:@"background"]];
    [navigationView addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(43, 9.5, 200, 25)];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setLineBreakMode:NSLineBreakByTruncatingHead];
    [title setText:self.fileName];
    [navigationView addSubview:title];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
    [backBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [navigationView addSubview:backBtn];
    
    [self.view addSubview:navigationView];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    NSString *url = [self.fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requestUrl = [NSURL URLWithString:url];
    [_webView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
    [self.view addSubview:_webView];
    
    [self.view addSubview:_hud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBtnPressed:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIWebView delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_hud hide:YES];
    [self.view makeToast:@"openFile"];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_hud show:YES];
    NSLog(@"start   %s",__FUNCTION__);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_hud hide:YES];
    NSLog(@"finish   %s",__FUNCTION__);
}

@end
