//
//  UIFactory.h
//  iData
//
//  Created by karven on 8/21/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeLabel.h"

@interface UIFactory : NSObject

+(ThemeButton *)createButton:(NSString *)titleName;

+(ThemeLabel *)createLabel:(NSString *)titleName;

@end
