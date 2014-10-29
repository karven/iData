//
//  BlockAlertView.m
//  iData
//
//  Created by karven on 9/16/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "BlockAlertView.h"

@implementation BlockAlertView

-(id)initWithTitle:(NSString *)title
           message:(NSString *)message
          delegate:(id)delegate
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitles
       buttonBlock:(ButtonBlock)block{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if(self != nil) {
        self.block = block;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _block(buttonIndex);
}

@end
