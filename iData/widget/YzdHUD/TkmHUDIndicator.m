//
//  TkmHUDIndicator.m
//  TkmHUD
//
//  Created by ShineYang on 13-12-6.
//  Copyright (c) 2013年 YangZhiDa. All rights reserved.
//

#import "TkmHUDIndicator.h"

static TkmHUDIndicator *_shareHUDView = nil;
@implementation TkmHUDIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(TkmHUDIndicator *)shareHUDView{
    if (!_shareHUDView) {
        _shareHUDView = [[TkmHUDIndicator alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _shareHUDView;
}

@end
