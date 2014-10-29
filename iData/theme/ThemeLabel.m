//
//  ThemeLabel.m
//  iData
//
//  Created by karven on 8/21/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

-(id)initWithTitle:(NSString *)titleKey{
    key = titleKey;
    NSString *title = [[kThemeManager bundle] localizedStringForKey:titleKey value:nil table:@"international"];
    self = [self init];
    if (self) {
        [self setText:title];
    }
    return self;
}

-(id)init{
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
    [self setText:title];
}

-(void)setTextWithTitleKey:(NSString *)text{
    NSString *title = [[kThemeManager bundle] localizedStringForKey:text value:nil table:@"international"];
    [self setText:title];
}

@end
