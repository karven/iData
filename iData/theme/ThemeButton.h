//
//  ThemeButton.h
//  iData
//
//  Created by karven on 8/21/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton{
    NSString *key;
}

-(id)initWithTitle:(NSString *)titleKey;

@end
