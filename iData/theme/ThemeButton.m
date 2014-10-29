//
//  ThemeButton.m
//  iData
//
//  Created by karven on 8/21/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

-(id)initWithTitle:(NSString *)titleKey{
    key = titleKey;
    NSString *title = [[kThemeManager bundle] localizedStringForKey:titleKey value:nil table:@"international"];
    self = [self init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageNotification:) name:kLanguageDidChangeNofication object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)languageNotification:(NSNotification *)notification{
    NSString *title = [[kThemeManager bundle] localizedStringForKey:key value:nil table:@"international"];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

@end
