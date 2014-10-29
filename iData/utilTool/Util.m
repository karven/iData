//
//  Util.m
//  iData
//
//  Created by karven on 7/30/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "Util.h"

@implementation Util

+(BOOL)stringIsNULL:(id)id_{
    if([id_ isKindOfClass:[NSNull class]]) return YES;
    if(![id_ isKindOfClass:[NSString class]]) return YES;
    
	if(id_ == nil) return YES;
    
    int len=(int)[(NSString *)id_ length];
    if (len <= 0) return YES;
    
	return NO;
}

+(NSString *)stringByReversed:(NSString *)str{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=str.length; i>0; i--) {
        [s appendString:[str substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}

+(BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|170)\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if ([mobileNum length]==11 && [phoneTest evaluateWithObject:mobileNum]) {
        return YES;
    }
    return NO;
}

+(NSString *)getCCToPFL:(NSString *)str{
    if([self stringIsNULL:str]) return nil;
    
    NSString * strPinyin = @"";
    for (int i = 0; i < [str length]; i++)
    {
        NSString * tempText=[NSString stringWithFormat:@"%c", [RFPOAPinyin pinyinFirstLetter:[str characterAtIndex:i]]];
        if(tempText == nil) continue;
        tempText=[tempText uppercaseString];
        strPinyin = [strPinyin stringByAppendingString:tempText];
    }
    
    return strPinyin;
}

+(NSString *)getCCToPY:(NSString *)str{
    if([self stringIsNULL:str]) return nil;
    
    NSString * strPinyin = [NSString stringWithFormat:@"%@", [RFPOAPinyin convert:str]];
    return strPinyin;
}

+(UIColor *)colorFromRGB:(NSString *)RGB{
    if ([RGB rangeOfString:@","].location != NSNotFound) {
        NSArray *array = [RGB componentsSeparatedByString:@","];
        return [UIColor colorWithRed:([array[0] intValue]/255.0) green:([array[1] intValue]/255.0) blue:([array[2] intValue]/255.0) alpha:1.0];
    }else{
        return [UIColor clearColor];
    }
}

+ (UIColor *) colorFromColorString:(NSString *)colorString
{
    NSString *stringToConvert = @"";
    stringToConvert = [colorString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString rangeOfString:@","].location != NSNotFound) {
        NSArray *array = [colorString componentsSeparatedByString:@","];
        return [UIColor colorWithRed:([array[0] intValue]/255.0) green:([array[1] intValue]/255.0) blue:([array[2] intValue]/255.0) alpha:1.0];
    }
    
    if ([cString length] < 6)
        return [UIColor clearColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//竖屏显示个数
+(int)getVerticalCount{
    int number = (ScreenHeight - 108) / 120;
    int remainder = ((int)ScreenHeight - 108) % 120;
    if (remainder > 50) {
        number = number + 1;
    }
    return number;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
//判断粘贴的文件是否是正确的类型
+(BOOL)isPasteFile:(NSString *)srcPath dstType:(NSString *)dstType{
    BOOL isFlag = YES;
    
    isFlag = [self directory:srcPath fileType:dstType];
    
    return isFlag;
}
+(BOOL)directory:(NSString *)srcPath fileType:(NSString *)type{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    for (NSString *src in array) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",srcPath,src];
        NSDictionary *dic = [fileManager attributesOfItemAtPath:path error:nil];
        NSString *fileType = [dic objectForKey:@"NSFileType"];
        //如果是文件夹则递归调用此方法，否则判断文件类型是否为传入的文件类型
        if ([fileType isEqualToString:@"NSFileTypeDirectory"]) {
            if ([type isEqualToString:@"photo"]) {
                return NO;
            }
            [self directory:path fileType:type];
        }else{
            NSString *str = [Util stringByReversed:src];
            NSString *suffix = [[Util stringByReversed:[str componentsSeparatedByString:@"."][0]] uppercaseString];
            if ([type isEqualToString:@"music"]) {
                if (!([suffix isEqualToString:@"MP3"] || [suffix isEqualToString:@"WMA"] || [suffix isEqualToString:@"WAV"] || [suffix isEqualToString:@"OGG"] || [suffix isEqualToString:@"AC3"] || [suffix isEqualToString:@"AIFF"] || [suffix isEqualToString:@"DAT"])) {
                    return NO;
                }
                continue;
            }else if ([type isEqualToString:@"video"]){
                if (!([suffix isEqualToString:@"RMVB"] || [suffix isEqualToString:@"RM"] || [suffix isEqualToString:@"WMV"] || [suffix isEqualToString:@"AVI"] || [suffix isEqualToString:@"MOV"] || [suffix isEqualToString:@"MPEG"] || [suffix isEqualToString:@"ASF"] || [suffix isEqualToString:@"MP4"])) {
                    return NO;
                }
                continue;
            }else if ([type isEqualToString:@"document"]){
                if (!([suffix isEqualToString:@"RTFD"] || [suffix isEqualToString:@"TXT"] || [suffix isEqualToString:@"DOC"] || [suffix isEqualToString:@"DOCX"] || [suffix isEqualToString:@"XLS"] || [suffix isEqualToString:@"XLSX"] || [suffix isEqualToString:@"PPT"] || [suffix isEqualToString:@"PPTX"] || [suffix isEqualToString:@"PDF"])) {
                    return NO;
                }
                continue;
            }else if ([type isEqualToString:@"photo"]){
                if (!([suffix isEqualToString:@"GIF"] || [suffix isEqualToString:@"PNG"] || [suffix isEqualToString:@"JPG"] || [suffix isEqualToString:@"BMP"] || [suffix isEqualToString:@"TIFF"] || [suffix isEqualToString:@"PSD"] || [suffix isEqualToString:@"SWF"] || [suffix isEqualToString:@"SVG"] || [suffix isEqualToString:@"JPEG"])) {
                    return NO;
                }
                continue;
            }
        }
    }
    return YES;
}

NSString* encodeURL(NSString* unescapedString) {
    if (0 == [unescapedString length]) {
        return @"";
    }
    
    NSString *escapedUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                     (CFStringRef)unescapedString,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                     kCFStringEncodingUTF8));
    
    if (0 == [escapedUrlString length]) {
        return @"";
    }
    
    return escapedUrlString;
}
AVAudioPlayer *player = nil;
@end
