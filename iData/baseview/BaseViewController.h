//
//  BaseViewController.h
//  iData
//
//  Created by karven on 8/20/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"
#import "UIFactory.h"
#import "ThemeLabel.h"
#import "ThemeButton.h"

@protocol BaseViewDelegate;

@interface BaseViewController : UIViewController{
    UIView *bottomView,*copyView,*pasteView,*selectView,*deleteView;
    ThemeLabel *copyLabel,*pasteLabel,*selectLabel,*deleteLabel;
    ThemeButton *scanButton,*editButton;
}

@property(nonatomic,assign) id<BaseViewDelegate> delegate;
@property(nonatomic,retain) NSString *isStatus;                     //按钮状态  默认是浏览
@property(nonatomic,retain) UILabel *titleLabel;

-(void)scanAction:(UIButton *)sender;
-(void)editAction:(UIButton *)sender;
-(void)handleTap:(UITapGestureRecognizer *)tap;

@end

@protocol BaseViewDelegate <NSObject>

@optional
-(void)copyAction;
-(void)pasteAction;
-(void)selectAllAction;
-(void)deleteAction;

@end
