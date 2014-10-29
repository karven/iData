//
//  TkmHUDImageView.m
//  TkmHUD
//
//  Created by ShineYang on 13-12-6.
//  Copyright (c) 2013年 YangZhiDa. All rights reserved.
//

#import "TkmHUDImageView.h"

static TkmHUDImageView *_shareHUDView = nil;
@implementation TkmHUDImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(TkmHUDImageView *)shareHUDView{
    if (!_shareHUDView) {
        _shareHUDView = [[TkmHUDImageView alloc] init];
        _shareHUDView.alpha = 0;
    }
    return _shareHUDView;
}


@end
