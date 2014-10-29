//
//  UIWindow+TkmHUD.m
//  TkmHUD
//
//  Created by ShineYang on 13-12-6.
//  Copyright (c) 2013年 YangZhiDa. All rights reserved.
//

#import "UIWindow+TkmHUD.h"
#import "TkmHUDBackgroundView.h"
#import "TkmHUDImageView.h"
#import "TkmHUDIndicator.h"
#import "TkmHUDLabel.h"

#define TkmHUDBounds CGRectMake(0, 0, 100, 100)
#define TkmHUDCenter CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
#define TkmHUDBackgroundAlpha 1
#define TkmHUDComeTime 0.15
#define TkmHUDStayTime 1
#define TkmHUDGoTime 0.15
#define TkmHUDFont 17

@implementation UIWindow (TkmHUD)

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled{
    [self showHUDWithText:text Type:type Enabled:(BOOL)enabled Bounds:TkmHUDBounds Center:TkmHUDCenter BackgroundAlpha:TkmHUDBackgroundAlpha ComeTime:TkmHUDComeTime StayTime:TkmHUDStayTime GoTime:TkmHUDGoTime];
}

-(void)showHUDWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    static BOOL isShow = YES;
    if (isShow) {
        isShow = NO;
        [self addSubview:[TkmHUDBackgroundView shareHUDView]];
        [self addSubview:[TkmHUDImageView shareHUDView]];
        [self addSubview:[TkmHUDLabel shareHUDView]];
        [self addSubview:[TkmHUDIndicator shareHUDView]];
        
        [TkmHUDBackgroundView shareHUDView].center = center;
        [TkmHUDLabel shareHUDView].center = CGPointMake(center.x, center.y + bounds.size.height/3.5);
        [TkmHUDImageView shareHUDView].center = CGPointMake(center.x, center.y - bounds.size.height/6);
        [TkmHUDIndicator shareHUDView].center = CGPointMake(center.x, center.y - bounds.size.height/6);
        [self goTimeBounds:bounds];
    }
    
    [TkmHUDLabel shareHUDView].bounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height/2 - 10);
    if ([self textLength:text] * TkmHUDFont + 10 >= bounds.size.width) {
        [TkmHUDLabel shareHUDView].font = [UIFont systemFontOfSize:TkmHUDFont - 2];
    }
    
    self.userInteractionEnabled = enabled;
    
    switch (type) {
        case ShowLoading:
            [self showLoadingWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowPhotoYes:
            [self showPhotoYesWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowPhotoNo:
            [self showPhotoNoWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
        case ShowDismiss:
            [self showDismissWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime];
            break;
            
        default:
            break;
    }
}

-(void)showLoadingWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([TkmHUDBackgroundView shareHUDView].alpha != 0) {
        return;
    }
  
    [TkmHUDLabel shareHUDView].text = text;
    [[TkmHUDIndicator shareHUDView] stopAnimating];
    [TkmHUDImageView shareHUDView].alpha = 0;

    [UIView animateWithDuration:comeTime animations:^{
        [self comeTimeBounds:bounds];
        [self comeTimeAlpha:backgroundAlpha withImage:NO];
        [[TkmHUDIndicator shareHUDView] startAnimating];
    } completion:^(BOOL finished) {

    }];
}

-(void)showPhotoYesWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([[TkmHUDIndicator shareHUDView] isAnimating]) {
        [[TkmHUDIndicator shareHUDView] stopAnimating];
        
        [TkmHUDImageView shareHUDView].bounds =
        CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
    }else{
        if ([TkmHUDBackgroundView shareHUDView].alpha != 0) {
            return;
        }
        [self goTimeBounds:bounds];
        [self goTimeInit];
    }
    
    [TkmHUDLabel shareHUDView].text = text;
    [TkmHUDImageView shareHUDView].image = [UIImage imageNamed:@"HUD_YES"];
    [UIView animateWithDuration:comeTime animations:^{
        [self comeTimeBounds:bounds];
        [self comeTimeAlpha:backgroundAlpha withImage:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:stayTime animations:^{
            [self stayTimeAlpha:backgroundAlpha];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:goTime animations:^{
                [self goTimeBounds:bounds];
                [self goTimeInit];;
            } completion:^(BOOL finished) {
                //Nothing
            }];
        }];
    }];
}

-(void)showPhotoNoWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([[TkmHUDIndicator shareHUDView] isAnimating]) {
        [[TkmHUDIndicator shareHUDView] stopAnimating];
        
        [TkmHUDImageView shareHUDView].bounds =
        CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
    }else{
        if ([TkmHUDBackgroundView shareHUDView].alpha != 0) {
            return;
        }
        [self goTimeBounds:bounds];
        [self goTimeInit];
    }
    
    [TkmHUDLabel shareHUDView].text = text;
    [TkmHUDImageView shareHUDView].image = [UIImage imageNamed:@"HUD_NO"];
    [UIView animateWithDuration:comeTime animations:^{
        [self comeTimeBounds:bounds];
        [self comeTimeAlpha:backgroundAlpha withImage:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:stayTime animations:^{
            [self stayTimeAlpha:backgroundAlpha];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:goTime animations:^{
                [self goTimeBounds:bounds];
                [self goTimeInit];;
            } completion:^(BOOL finished) {
                //Nothing
            }];
        }];
    }];
}

-(void)showDismissWithText:(NSString *)text Type:(showHUDType)type Enabled:(BOOL)enabled Bounds:(CGRect)bounds Center:(CGPoint)center BackgroundAlpha:(CGFloat)backgroundAlpha ComeTime:(CGFloat)comeTime StayTime:(CGFloat)stayTime GoTime:(CGFloat)goTime{
    if ([[TkmHUDIndicator shareHUDView] isAnimating]) {
        [[TkmHUDIndicator shareHUDView] stopAnimating];
    }
    
    [TkmHUDLabel shareHUDView].text = nil;
    [TkmHUDImageView shareHUDView].image = nil;
    [UIView animateWithDuration:goTime animations:^{
        [TkmHUDImageView shareHUDView].bounds =
        CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
        [self goTimeBounds:bounds];
        [self goTimeInit];
    } completion:^(BOOL finished) {
        //Nothing
    }];
}

#pragma mark 状态
-(void)goTimeBounds:(CGRect)bounds{
    [TkmHUDBackgroundView shareHUDView].bounds =
    CGRectMake(0, 0, bounds.size.width * 1.5, bounds.size.height * 1.5);
    [TkmHUDImageView shareHUDView].bounds =
    CGRectMake(0, 0, (bounds.size.width/2.5 - 5) * 2, (bounds.size.height/2.5 - 5) * 2);
}

-(void)goTimeInit{
    [TkmHUDBackgroundView shareHUDView].alpha = 0;
    [TkmHUDImageView shareHUDView].alpha = 0;
    [TkmHUDLabel shareHUDView].alpha = 0;
    [[TkmHUDIndicator shareHUDView] stopAnimating];
}

-(void)stayTimeAlpha:(CGFloat)alpha{
    [TkmHUDBackgroundView shareHUDView].alpha = alpha - 0.01;
}

-(void)comeTimeBounds:(CGRect)bounds{
    [TkmHUDBackgroundView shareHUDView].bounds =
    CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    [TkmHUDImageView shareHUDView].bounds =
    CGRectMake(0, 0, bounds.size.width/2.5 - 5, bounds.size.height/2.5 - 5);
}

-(void)comeTimeAlpha:(CGFloat)alpha withImage:(BOOL)isImage{
    [TkmHUDBackgroundView shareHUDView].alpha = alpha;
    [TkmHUDLabel shareHUDView].alpha = 1;
    if (isImage) {
        [TkmHUDImageView shareHUDView].alpha = 1;
    }
}

#pragma mark - 计算字符串长度
- (int)textLength:(NSString *)text{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}


@end
