//
//  UIColor+UIColorExtras.h
//  JianJieCao
//
//  Created by Snake on 13-11-5.
//  Copyright (c) 2013年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor* UIColorFromRGBA(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha);

UIColor* UIColorFromRGB(unsigned char red, unsigned char green, unsigned char blue);

UIColor* UIColorFromRGBValue(NSUInteger rgbValue);
UIColor* UIColorFromRGBAValue(NSUInteger rgbValue, int alpha);

@interface UIColor (UIColorExtras)

+ (UIColor *)colorWithR:(int)r g:(int)g b:(int)b a:(CGFloat)a;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;

@end
