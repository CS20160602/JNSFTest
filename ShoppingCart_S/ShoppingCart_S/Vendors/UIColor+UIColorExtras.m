//
//  UIColor+UIColorExtras.m
//  JianJieCao
//
//  Created by Snake on 13-11-5.
//  Copyright (c) 2013年 Shadow. All rights reserved.
//

#import "UIColor+UIColorExtras.h"

UIColor* UIColorFromRGBA(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha) {
    return [UIColor colorWithRed:(float)red/255.0
                           green:(float)green/255.0
                            blue:(float)blue/255.0
                           alpha:(float)alpha/255.0];
}

UIColor* UIColorFromRGB(unsigned char red, unsigned char green, unsigned char blue) {
    return [UIColor colorWithRed:(float)red/255.0
                           green:(float)green/255.0
                            blue:(float)blue/255.0
                           alpha:1.0];
}

UIColor* UIColorFromRGBValue(NSUInteger rgbValue) {
    return UIColorFromRGB((rgbValue & 0xFF0000) >> 16,
                          (rgbValue & 0x00FF00) >> 8,
                          (rgbValue & 0x0000FF));
}

UIColor* UIColorFromRGBAValue(NSUInteger rgbValue, int alpha) {
    return UIColorFromRGBA((rgbValue & 0xFF0000) >> 16,
                           (rgbValue & 0x00FF00) >> 8,
                           (rgbValue & 0x0000FF),
                           alpha);
}

@implementation UIColor (UIColorExtras)

+ (UIColor *)colorWithR:(int)r g:(int)g b:(int)b a:(CGFloat)a
{
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
