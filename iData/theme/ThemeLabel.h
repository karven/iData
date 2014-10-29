//
//  ThemeLabel.h
//  iData
//
//  Created by karven on 8/21/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLabel : UILabel{
    NSString *key;
}

-(id)initWithTitle:(NSString *)titleKey;
-(void)setTextWithTitleKey:(NSString *)text;

@end
