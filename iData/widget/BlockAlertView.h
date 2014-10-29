//
//  BlockAlertView.h
//  iData
//
//  Created by karven on 9/16/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(NSInteger index);

@interface BlockAlertView : UIAlertView

@property(nonatomic,copy) ButtonBlock block;

-(id)initWithTitle:(NSString *)title
           message:(NSString *)message
          delegate:(id)delegate
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitles
       buttonBlock:(ButtonBlock)block;

@end
