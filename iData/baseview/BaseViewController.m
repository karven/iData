//
//  BaseViewController.m
//  iData
//
//  Created by karven on 8/20/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BaseViewController.h"
#import "FTPManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize isStatus,titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initNavigationBar{
    [self.navigationController setNavigationBarHidden:YES];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, VER_IS_IOS7?20:0, ScreenWidth, 44)];
    [bar setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [item setLeftBarButtonItem:leftButton];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 44)];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VER_IS_IOS7?0:-20, 9.5, 100, 25)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setLineBreakMode:NSLineBreakByTruncatingHead];
    
    UIButton *main = [[UIButton alloc] initWithFrame:CGRectMake(125, 8, 28, 28)];
    [main setBackgroundImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [main addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    scanButton = [UIFactory createButton:@"scan"];
    [scanButton setFrame:CGRectMake(main.frame.origin.x + main.frame.size.width + 8, 5, 50, 34)];
    [scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"browse_checked"] forState:UIControlStateNormal];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"browse_checked"] forState:UIControlStateHighlighted];
    editButton = [UIFactory createButton:@"edit"];
    [editButton setFrame:CGRectMake(scanButton.frame.origin.x + scanButton.frame.size.width, 5, 50, 34)];
    [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setBackgroundImage:[UIImage imageNamed:@"editor_uncheck"] forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageNamed:@"editor_checked"] forState:UIControlStateHighlighted];
    [rightView addSubview:titleLabel];
    [rightView addSubview:main];
    [rightView addSubview:scanButton];
    [rightView addSubview:editButton];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [item setRightBarButtonItem:rightButton];
    
    [bar pushNavigationItem:item animated:NO];
    [self.view addSubview:bar];
}

-(void)initBottomView{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - (VER_IS_IOS7?44:64), ScreenWidth, 44)];
    [bottomView setBackgroundColor:[Util colorFromColorString:@"#80aad8"]];
    
    copyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/4, 44)];
    UIButton *copy = [[UIButton alloc] initWithFrame:CGRectMake((copyView.frame.size.width-25)/2, 3, 25, 25)];
    [copy setUserInteractionEnabled:NO];
    [copy setBackgroundImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    copyLabel = [[ThemeLabel alloc] initWithTitle:@"copy"];
    [copyLabel setBackgroundColor:[UIColor clearColor]];
    [copyLabel setUserInteractionEnabled:NO];
    [copyLabel setFrame:CGRectMake(0, copy.frame.size.height + 3, copyView.frame.size.width, 15)];
    [copyLabel setTextAlignment:NSTextAlignmentCenter];
    [copyLabel setFont:[UIFont systemFontOfSize:12]];
    [copyView addSubview:copy];
    [copyView addSubview:copyLabel];
    
    pasteView = [[UIView alloc] initWithFrame:CGRectMake(copyView.frame.size.width, 0, ScreenWidth/4, 44)];
    UIButton *paste = [[UIButton alloc] initWithFrame:CGRectMake((pasteView.frame.size.width-25)/2, 3, 25, 25)];
    [paste setUserInteractionEnabled:NO];
    [paste setBackgroundImage:[UIImage imageNamed:@"paste"] forState:UIControlStateNormal];
    pasteLabel = [[ThemeLabel alloc] initWithTitle:@"paste"];
    [pasteLabel setBackgroundColor:[UIColor clearColor]];
    [pasteLabel setUserInteractionEnabled:NO];
    [pasteLabel setFrame:CGRectMake(0, paste.frame.size.height + 3, pasteView.frame.size.width, 15)];
    [pasteLabel setTextAlignment:NSTextAlignmentCenter];
    [pasteLabel setFont:[UIFont systemFontOfSize:12]];
    [pasteView addSubview:paste];
    [pasteView addSubview:pasteLabel];
    
    selectView = [[UIView alloc] initWithFrame:CGRectMake(pasteView.frame.origin.x + pasteView.frame.size.width, 0, ScreenWidth/4, 44)];
    UIButton *select = [[UIButton alloc] initWithFrame:CGRectMake((selectView.frame.size.width-25)/2, 3, 25, 25)];
    [select setUserInteractionEnabled:NO];
    [select setBackgroundImage:[UIImage imageNamed:@"all_choose"] forState:UIControlStateNormal];
    selectLabel = [[ThemeLabel alloc] initWithTitle:@"check"];
    [selectLabel setBackgroundColor:[UIColor clearColor]];
    [selectLabel setUserInteractionEnabled:NO];
    [selectLabel setFrame:CGRectMake(0, select.frame.size.height + 3, selectView.frame.size.width, 15)];
    [selectLabel setTextAlignment:NSTextAlignmentCenter];
    [selectLabel setFont:[UIFont systemFontOfSize:12]];
    [selectView addSubview:select];
    [selectView addSubview:selectLabel];
    
    deleteView = [[UIView alloc] initWithFrame:CGRectMake(selectView.frame.origin.x + selectView.frame.size.width, 0, ScreenWidth/4, 44)];
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake((deleteView.frame.size.width-25)/2, 3, 25, 25)];
    [delete setUserInteractionEnabled:NO];
    [delete setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    deleteLabel = [[ThemeLabel alloc] initWithTitle:@"delete"];
    [deleteLabel setBackgroundColor:[UIColor clearColor]];
    [deleteLabel setFrame:CGRectMake(0, delete.frame.size.height + 3, deleteView.frame.size.width, 15)];
    [deleteLabel setTextAlignment:NSTextAlignmentCenter];
    [deleteLabel setFont:[UIFont systemFontOfSize:12]];
    [deleteView addSubview:delete];
    [deleteView addSubview:deleteLabel];
    
    [bottomView addSubview:copyView];
    [bottomView addSubview:pasteView];
    [bottomView addSubview:selectView];
    [bottomView addSubview:deleteView];
    
    [self.view addSubview:bottomView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [bottomView addGestureRecognizer:tapGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [imageView setFrame:CGRectMake(0, VER_IS_IOS7?64:44, ScreenWidth, ScreenHeight-(VER_IS_IOS7?64:44)-44)];
    [self.view addSubview:imageView];
    isStatus = @"scan";
    
    [self initNavigationBar];
    
    [self initBottomView];
}

#pragma mark UITapGestureRecognizer
-(void)handleTap:(UITapGestureRecognizer *)tap{
    if ([isStatus isEqualToString:@"scan"]) {
        return;
    }
    CGPoint point = [tap locationInView:bottomView];
    if (CGRectContainsPoint(copyView.frame, point)) {
        NSLog(@"copyView");
        [copyView setBackgroundColor:[Util colorFromColorString:@"#e77a32"]];
        [deleteView setBackgroundColor:[UIColor clearColor]];
        [pasteView setBackgroundColor:[UIColor clearColor]];
        [selectView setBackgroundColor:[UIColor clearColor]];
        [copyLabel setTextColor:[UIColor whiteColor]];
        [pasteLabel setTextColor:[UIColor blackColor]];
        [selectLabel setTextColor:[UIColor blackColor]];
        [deleteLabel setTextColor:[UIColor blackColor]];
        
        if ([self.delegate respondsToSelector:@selector(copyAction)]) {
            [self.delegate copyAction];
        }
    } else if (CGRectContainsPoint(pasteView.frame, point)){
        NSLog(@"pasteView");
        [pasteView setBackgroundColor:[Util colorFromColorString:@"#e77a32"]];
        [copyView setBackgroundColor:[UIColor clearColor]];
        [deleteView setBackgroundColor:[UIColor clearColor]];
        [selectView setBackgroundColor:[UIColor clearColor]];
        [pasteLabel setTextColor:[UIColor whiteColor]];
        [copyLabel setTextColor:[UIColor blackColor]];
        [selectLabel setTextColor:[UIColor blackColor]];
        [deleteLabel setTextColor:[UIColor blackColor]];
        
        if ([self.delegate respondsToSelector:@selector(pasteAction)]) {
            [self.delegate pasteAction];
        }
    } else if (CGRectContainsPoint(selectView.frame, point)){
        NSLog(@"selectView");
        [selectView setBackgroundColor:[Util colorFromColorString:@"#e77a32"]];
        [copyView setBackgroundColor:[UIColor clearColor]];
        [pasteView setBackgroundColor:[UIColor clearColor]];
        [deleteView setBackgroundColor:[UIColor clearColor]];
        [selectLabel setTextColor:[UIColor whiteColor]];
        [copyLabel setTextColor:[UIColor blackColor]];
        [pasteLabel setTextColor:[UIColor blackColor]];
        [deleteLabel setTextColor:[UIColor blackColor]];
        
        if ([self.delegate respondsToSelector:@selector(selectAllAction)]) {
            [self.delegate selectAllAction];
        }
    } else if (CGRectContainsPoint(deleteView.frame, point)){
        NSLog(@"deleteView");
        [deleteView setBackgroundColor:[Util colorFromColorString:@"#e77a32"]];
        [copyView setBackgroundColor:[UIColor clearColor]];
        [pasteView setBackgroundColor:[UIColor clearColor]];
        [selectView setBackgroundColor:[UIColor clearColor]];
        [deleteLabel setTextColor:[UIColor whiteColor]];
        [copyLabel setTextColor:[UIColor blackColor]];
        [selectLabel setTextColor:[UIColor blackColor]];
        [pasteLabel setTextColor:[UIColor blackColor]];
        
        if ([self.delegate respondsToSelector:@selector(deleteAction)]) {
            [self.delegate deleteAction];
        }
    }
}

#pragma mark UIButton Action
-(void)scanAction:(UIButton *)sender{
    [scanButton setBackgroundImage:[UIImage imageNamed:@"browse_checked"] forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageNamed:@"editor_uncheck"] forState:UIControlStateNormal];
    isStatus = @"scan";
    [self buttonAction:isStatus];
}

-(void)editAction:(UIButton *)sender{
    [editButton setBackgroundImage:[UIImage imageNamed:@"editor_checked"] forState:UIControlStateNormal];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"browse_uncheck"] forState:UIControlStateNormal];
    isStatus = @"edit";
    [self buttonAction:isStatus];
}

-(void)buttonAction:(NSString *)operation{
    [deleteView setBackgroundColor:[UIColor clearColor]];
    [copyView setBackgroundColor:[UIColor clearColor]];
    [pasteView setBackgroundColor:[UIColor clearColor]];
    [selectView setBackgroundColor:[UIColor clearColor]];
    [deleteLabel setTextColor:[UIColor blackColor]];
    [copyLabel setTextColor:[UIColor blackColor]];
    [selectLabel setTextColor:[UIColor blackColor]];
    [pasteLabel setTextColor:[UIColor blackColor]];
}

-(void)back{
    [kFTPManager.folderArray removeLastObject];
//    [kFMServer.destinationArray removeLastObject];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction{
    [kFTPManager.folderArray removeAllObjects];
//    [kFMServer.destinationArray removeAllObjects];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
