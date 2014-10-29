//
//  ThemeManager.h
//  iData
//
//  Created by karven on 8/20/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLanguageDidChangeNofication @"kLanguageDidChangeNofication"
#define kThemeManager [ThemeManager shareInstance]

@interface ThemeManager : NSObject

+ (ThemeManager *)shareInstance;

-(NSBundle *)bundle;//获取当前资源文件

-(void)initUserLanguage;//初始化语言文件

-(NSString *)userLanguage;//获取应用当前语言

-(void)setUserlanguage:(NSString *)language;//设置当前语言

@end
