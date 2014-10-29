//
//  Util.h
//  iData
//
//  Created by karven on 7/30/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFPOAPinyin.h"
#import <AVFoundation/AVFoundation.h>

@interface Util : NSObject

//判断字符串是否为空
+(BOOL)stringIsNULL:(id)id_;

//字符串反转
+(NSString *)stringByReversed:(NSString *)str;

//正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//汉字转换拼音字符(Chinese characters to Pinyin First Letter)
+(NSString *)getCCToPFL:(NSString *)str;

//汉字转换拼音字符(Chinese characters to Pinyin)
+(NSString *)getCCToPY:(NSString *)str;

//颜色RGB转换
+(UIColor *)colorFromRGB:(NSString *)RGB;
+(UIColor *)colorFromColorString:(NSString *)colorString;

//一屏可以显示多少个图标
+(int)getVerticalCount;

//保持原来的长宽比，生成一个缩略图
+(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

//从原路径中复制文件，并且类型为制定类型，只能是本地路径
+(BOOL)isPasteFile:(NSString *)srcPath dstType:(NSString *)dstType;

extern NSString* encodeURL(NSString* unescapedString);
extern AVAudioPlayer *player;

@end
