//
//  UIFactory.m
//  iData
//
//  Created by karven on 8/21/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+(ThemeButton *)createButton:(NSString *)titleName{
    ThemeButton *button = [[ThemeButton alloc] initWithTitle:titleName];
    return button;
}

+(ThemeLabel *)createLabel:(NSString *)titleName{
    ThemeLabel *label = [[ThemeLabel alloc] initWithTitle:titleName];
    return label;
}

@end
