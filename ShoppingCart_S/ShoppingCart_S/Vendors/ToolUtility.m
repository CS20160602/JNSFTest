//
//  ToolUtility.m
//  Travel
//
//  Created by ydf on 14-7-15.
//  Copyright (c) 2014年 Elroy. All rights reserved.
//


#import "ToolUtility.h"

#import "UIColor+UIColorExtras.h"

#import "UIView+Utils.h"


#import <CoreTelephony/CTCarrier.h>

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

#include <sys/types.h>
#include <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@interface ToolUtility ()


@end

@implementation ToolUtility
#pragma mark - 通用

static NSDateFormatter *tpDateFormatter;

+ (NSString *)getUUID {
    NSString *uuidKey = @"GAGS_UUID";
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *uuid = [userDefault objectForKey:uuidKey];
    
    if (uuid.length == 0){
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuid =  CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        [userDefault setObject:uuid forKey:uuidKey];
        [userDefault synchronize];
        
        CFRelease(uuidRef);
    }
    
    return uuid;
}
+ (NSDictionary *)getUUIDDic{
    NSString *uuid = [self getUUID];
    if(uuid){
        return @{@"uuid":uuid};
    }
    return nil;
}

+ (NSString *)getAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
    ;
}

+ (void)savePlayerScaleSize:(CGFloat)width height:(CGFloat)height{
    [UserDefaults setObject:@(width) forKey:@"gags_player_width"];
    [UserDefaults setObject:@(height) forKey:@"gags_player_height"];
    [UserDefaults synchronize];
}

+ (CGFloat)getPlayerHeightWithScaleWidth:(CGFloat)width{
    CGFloat scaleWidth = [[UserDefaults objectForKey:@"gags_player_width"] floatValue];
    CGFloat scaleHeight = [[UserDefaults objectForKey:@"gags_player_height"] floatValue];
    CGFloat videoHeight = scaleHeight * width/scaleWidth;

    return videoHeight;
}


//写死比例: 320/180
+ (CGFloat)calculateVideoHeight{
    return [ToolUtility tpCalculateVideoHeight];
}

//写死比例: 750/424
+ (CGFloat)tpCalculateVideoHeight{
    //    return 10.0;
    CGFloat videoHeight = 424 * ScreenWidth/750.0;
    if(videoHeight <= 100){
        return 300;
    }
    return  videoHeight;
}

+ (CGFloat)calculateVideoHeightWithWidth:(CGFloat)width height:(CGFloat)height {
//    return 10.0;
    CGFloat videoHeight = height * ScreenWidth/width;
    if(videoHeight <= 100){
        return 300;
    }
    return  videoHeight;
}
//计算字符串长度
+ (int)getStringLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < text.length; index++) {
        
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            
            number++;
        }else
        {
            number += 0.5;
        }
    }
    
    return ceil(number);
}
+ (NSString *)deviceId{
    static NSString * deviceId;
    if(deviceId == nil)
    {
        NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
        NSString * key = @"__DEVICE_ID";
        if(!(deviceId = [d objectForKey:key]))
        {
            deviceId = [NSString stringWithFormat:@"%@|%@", [self _pureWifiMacAddress], [self udid]];
            [d setObject:deviceId forKey:key];
            [d synchronize];
        }
        
    }
    
    return deviceId;
}

+ (NSString *) _pureWifiMacAddress
{
    return [[[self mac] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

// 获取MAC地址
+ (NSString *) mac
{
    static NSString* mac;
    
    if(mac == nil)
    {
        int                 mib[6];
        size_t              len;
        char                *buf;
        unsigned char       *ptr;
        struct if_msghdr    *ifm;
        struct sockaddr_dl  *sdl;
        
        mib[0] = CTL_NET;
        mib[1] = AF_ROUTE;
        mib[2] = 0;
        mib[3] = AF_LINK;
        mib[4] = NET_RT_IFLIST;
        
        if ((mib[5] = if_nametoindex([@"en0" UTF8String])) == 0) {
            return @"";
        }
        
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
            return @"";
        }
        
        if ((buf = malloc(len)) == NULL) {
            return @"";
        }
        
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
            free(buf);
            return @"";
        }
        
        ifm = (struct if_msghdr *)buf;
        sdl = (struct sockaddr_dl *)(ifm + 1);
        ptr = (unsigned char *)LLADDR(sdl);
        mac = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
               *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)] ;
        free(buf);
    }
    
    return mac;
}

+ (NSString *) udid
{
    static NSString * udid;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@", @"uniq", @"ueIden", @"tifier"]);
        UIDevice * device = [UIDevice currentDevice];
        if([device respondsToSelector:sel])
        {
            udid = [device performSelector:sel];
        }
        
        if(!udid || !udid.length)
        {
            udid = [self _generateRandomStringWithLength:40 newCharacterSet:nil];
        }
        
        udid = [udid copy];
    });
    
    return udid;
}

// 生成一个指定长度的随机字符串
+ (NSString *) _generateRandomStringWithLength:(NSInteger) length newCharacterSet:(NSString *) newCharacterSet
{
    NSMutableString *string = [[NSMutableString alloc] init];
    NSString *charSet = nil;
    
    if (newCharacterSet != nil)
    {
        charSet = newCharacterSet;
    }
    else
    {
        charSet = @"0123456789abcdef";
    }
    
    for (int i = 0; i < length; i++)
    {
        [string appendFormat:@"%c", [charSet characterAtIndex:arc4random() % [charSet length]]];
    }
    
    return string;
}

+ (NSString *)getNewStringWithOldString:(NSString *)oldStr andSubStringOfOld:(NSString *)subStr
{
    if ([oldStr isEqualToString:subStr]) {
        
        return nil;
    }
    
    if ([oldStr rangeOfString:subStr].location != NSNotFound) {
        NSRange range;
        range = [oldStr rangeOfString:subStr];
        NSString *firstSubStr = [oldStr substringToIndex:range.location];
        NSString *secSubStr   = [oldStr substringFromIndex:range.location + range.length];
        NSString *newOtherRqtsMe = [firstSubStr stringByAppendingString:secSubStr];
        
        return newOtherRqtsMe;
    }
    
    
    return oldStr;
}

//注册两个键盘将出现和将隐藏的通知事件
+ (void)KeyboardWillShowSelector:(SEL)keyboardWillShow KeyboardWillHideNotificationSelector:(SEL)keyboardWillHide andWhichVC:(id)paramVC{
    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:paramVC
                                             selector:keyboardWillShow
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:paramVC
                                             selector:keyboardWillHide
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

+ (void)removeNotificationsOfKeyboardWithWhichVC:(id)paramVC
{
    [[NSNotificationCenter defaultCenter] removeObserver:paramVC name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:paramVC name:UIKeyboardWillHideNotification object:nil];
}

+ (BOOL)isNull:(NSString*)text
{
    //去掉多余空格
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!text || [text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *)replaceSpeaceChar:(NSString *)text{
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return text;
}

+ (CGSize)sizeString:(NSString*)string withFont:(UIFont*)font{
    if(font == nil){return CGSizeZero;}
    CGSize size = CGSizeZero;
    
    if (string.length > 0) {
        if ([string respondsToSelector:@selector(sizeWithAttributes:)]){
            
            NSMutableDictionary *atts = [NSMutableDictionary  dictionary];
            [atts setObject:font forKey:NSFontAttributeName];
            size = [string sizeWithAttributes:atts];
            size.height += 1;
            size.height = (NSInteger)size.height;
        }
        else{
            size = [string sizeWithFont:font];
        }
    }
    
    return size;
}

+(UIImage *)createImageWithColor:(UIColor *)color  
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (CGSize)sizeString:(NSString *)string WithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if(string.length == 0){
        return CGSizeZero;
    }
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:lineBreakMode];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [string boundingRectWithSize:size
                                           options:opts
                                        attributes:attributes
                                           context:nil];
        return rect.size;
    }else{
        return [string sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }
}
//+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
//{
//    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
//    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    
//    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
//    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
//    
//    NSString *hash = [HMAC base64EncodedString];
//    
//    return hash;
//}

//转换评论内容
+ (NSString *)composeCommentContent:(NSString *)comment atSomeOne:(NSString *)atSomeOne{
    if(atSomeOne.length > 0){
        NSString *string = [NSString stringWithFormat:@"<font color='#2a91f1'>%@</font>%@",atSomeOne,comment];
        return string;
    }
    
    return comment;
}

#pragma mark - 此项目
//点赞动画
+ (CAAnimation *)likeAnimationWithRepeatCount:(float)repCount{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];

    anim.duration = 0.4;
    
    if (repCount > 0) {
        anim.values = @[@(0.9), @(1.0),@(1.1), @(1.2), @(1.1),@(1.0),@(0.9)];
        anim.duration = 1.5;
    }
    else{
        anim.values = @[@(0.5) ,@(0.8),@(1.3), @(1.0)];
        //    anim.keyTimes = @[@(0),@(0.25),@(0.5),@(0.8), @(1.0)];
        anim.calculationMode = kCAAnimationLinear;
    }
    
    
    anim.repeatCount = repCount;
    
    return anim;
}

+ (void)clickZanAddAnimationToView:(UIView *)view withRepeatCount:(float)repCount
{
    [view.layer removeAnimationForKey:LikeAnimation];
    [view.layer addAnimation:[self likeAnimationWithRepeatCount:repCount] forKey:LikeAnimation];
    
    return;
    
//    view.transform = CGAffineTransformIdentity;
//    [UIView animateWithDuration:0.25 animations:^{
//        view.transform = CGAffineTransformMakeScale(1.5, 1.5); //放大
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.25 animations:^{
//            view.transform = CGAffineTransformMakeScale(0.8, 0.8); //缩小
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.25 animations:^{
//                view.transform = CGAffineTransformMakeScale(1.0, 1.0); //正常
//            } completion:^(BOOL finished) {
//                
//            }];
//        }];
//    }];
}

// 双击点赞 飘心
+  (void)createImgViewWithCGPoint:(CGPoint)point  andSuperView:(UIView *)superView
{
    UIImage *image = [UIImage imageNamed:@"home_video_like"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.tag = Tag_ZanImageV;
    imgView.frame = CGRectMake(0, 0 , image.size.width * 2, image.size.height * 2);
    imgView.center = point;
    [superView addSubview:imgView];
    
    //frame.origin，动画开始的地方
    CGPoint viewOrigin = point;
    //    viewOrigin.y = viewOrigin.y + imgView.height / 2.0f;
    //    viewOrigin.x = viewOrigin.x + imgView.width / 2.0f;
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    //设置缩放
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imgView.size.height * (40.0f / imgView.size.width))]];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    //设置动画结束点
    CGPoint endPoint = CGPointMake(point.x + 30.0f, point.y -  40.0f);
    //在最后一个选项卡结束动画
    //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, viewOrigin.x, endPoint.y, viewOrigin.x, endPoint.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
    group.duration = 0.7f;
    group.delegate = self;
    [group setValue:imgView forKey:@"imageViewBeingAnimated"];
    
    [imgView.layer addAnimation:group forKey:@"savingAnimation"];
    
    [imgView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.7f];
}

+ (BOOL)judgeDeviceIsInstalledAppWithNameStr:(NSString *)strSign
{
    //whatsapp://    fb://
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strSign]];
    return isInstalled;
}

+ (NSDate *)getCurrentDateWithFirstDate:(NSDate *)originDate andSeconds:(int)seconds
{
    NSDate *currentDate = [NSDate dateWithTimeInterval:seconds sinceDate:originDate];
    return currentDate;
}

//time 150703
+ (NSString *)getNewStringWithOldString:(NSString *)oldString componetByStr:(NSString *)fuhao
{
    NSArray *arr = [oldString componentsSeparatedByString:fuhao];
    NSString *newStr = @"";
    for (NSString *str in arr) {
        
        newStr = [newStr stringByAppendingString:str];
    }
    
    return newStr;
}

+ (NSString *)setTimeStyleWithSeconds:(NSString *)time
{
    NSTimeInterval currentSeconds = [[NSDate date] timeIntervalSince1970];
    //    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    //    NSLog(@"interval=%f",interval);
    //    long long totalMilliseconds = interval*1000;
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.floatValue];
    int diffTime = currentSeconds - [time doubleValue];
    NSString *strTime = @"";
    
    int day = diffTime / 60 / 60 / 24;
    int hour = diffTime / 60 / 60;
    int minute = diffTime / 60;
//    int weak = day / 7;
//    int month = day / 30;
//    int year = day / 365;
    
    if(tpDateFormatter == nil){
        tpDateFormatter = [[NSDateFormatter alloc] init];
        [tpDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }

    if(day >= 5){
        strTime = [tpDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time.floatValue]];
    
    }else if (day >= 1) {
        
        strTime = StringWithFormat(@"%d天前",day);
        
    }else if (hour >= 1){
        
        strTime = StringWithFormat(@"%d小时前",hour);
    }else if (minute >= 1){
        strTime = StringWithFormat(@"%d分钟前",minute);
    }else{
        strTime = StringWithFormat(@"刚刚");
    }
    
    return strTime;
}

+(NSString *)getVideoTimeWithSeconds:(NSNumber *)num
{
    NSInteger time = [num integerValue];
    NSString *timeSting;;
    
    NSInteger min = time / 60;
    NSInteger sec = time % 60;
    
    if(min < 10){
        timeSting = StringWithFormat(@"0%zd",min);
    }
    else{
        timeSting = StringWithFormat(@"%zd",min);
    }
    
    NSString *secondString = StringWithFormat(@":%zd",sec);
    if(sec < 10){
        secondString = StringWithFormat(@":0%zd",sec);
    }
    
    timeSting = [timeSting stringByAppendingString:secondString];
    
    return timeSting;
}

+(NSString *)getVideoStaticsInfoWithSeconds:(NSInteger)seconds andViewNum:(NSInteger)viewNum
{
    NSString *strPublish = [ToolUtility setTimeStyleWithSeconds:StringWithInteger(seconds)];
    NSString *strViews = StringWithInteger(viewNum);
    return [strPublish stringByAppendingString:StringWithFormat(@" %@", strViews)];
}

+ (NSString *)stringWithURLEncodeding:(NSString *)str
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+ (void)refreshGoodsListInfoWithSelector:(SEL)refreshListSelector WithCurObject:(id)curObj andNotiName:(NSString *)notiName
{
    [[NSNotificationCenter defaultCenter] addObserver:curObj
                                             selector:refreshListSelector
                                                 name:notiName
                                               object:nil];
}

+ (void)removeNotificationsWithCurObject:(id)curObj andNotiName:(NSString *)notiName
{
    [Notification removeObserver:curObj name:notiName object:nil];
}


+ (UIImage *)placeholderImageForProvider {
    return [UIImage imageNamed:@"default_providerImage"];
}
+ (UIImage *)placeholderImageForGoods {
    return [UIImage imageNamed:@"default_image"];
}
+ (void)createToastViewWithCenter:(BOOL)center WithContent:(NSString *)text withSuperView:(UIView *)selfView andFrame:(CGRect)frame{
    
    if (nil == selfView) {
        
        selfView = [[UIApplication sharedApplication] keyWindow];
    }
    
    if ([NSStringFromCGRect(frame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        frame = selfView.frame;
    }
 
    if ([selfView viewWithTag:666]) {
        [[selfView viewWithTag:666] removeFromSuperview];
    }
    
    UIImage *image = [UIImage imageNamed:@"toast_bg"];
    CGSize size = [ToolUtility sizeString:text WithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(frame.size.width - 60, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel *lblToast = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width + 30, image.size.height)];
    lblToast.text = text;
    lblToast.backgroundColor = [UIColor clearColor];
    lblToast.textColor = [UIColor whiteColor];
    lblToast.textAlignment = NSTextAlignmentCenter;
    lblToast.font = [UIFont boldSystemFontOfSize:15];
    [lblToast setNumberOfLines:1];
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(lblToast.height / 3, lblToast.width / 3, lblToast.height / 3, lblToast.width / 3) resizingMode:UIImageResizingModeTile];
    
    UIImageView *viewBg = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - lblToast.width) / 2, (frame.size.height - lblToast.height)  * 2 /  3,lblToast.width , lblToast.height)];
    viewBg.backgroundColor = [UIColor clearColor];
    viewBg.image = image;
    viewBg.tag = 666;
    viewBg.alpha = 0;
    
    if (center) {
        viewBg.center = selfView.center;
    }
    
    [viewBg addSubview:lblToast];
    [selfView addSubview:viewBg];
    
    //toast提示渐变出现
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        viewBg.alpha = 1;
    } completion:^(BOOL finished) {
        //toast提示渐变消失
        [UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            viewBg.alpha = 0;
            
        } completion:^(BOOL finished) {
            [viewBg removeFromSuperview];
        }];
    }];
    
}

+ (void)createToastViewWithContent:(NSString *)text WithSuperView:(UIView *)selfView andFrame:(CGRect)frame
{
    [ToolUtility createToastViewWithCenter:NO WithContent:text withSuperView:selfView andFrame:frame];
}

//获取本机国家地址
+ (NSString *)getLocalCountryCode{
    NSString *udCountryCode = [UserDefaults objectForKey:@"CountryCode"];
    if(udCountryCode.length > 0){
        return udCountryCode;
    }
    else{
        NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        [UserDefaults setObject:countryCode forKey:@"CountryCode"];
        [UserDefaults synchronize];
        return countryCode;
    }
}

+ (void)saveLocalCountryCode{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    [UserDefaults setObject:countryCode forKey:@"CountryCode"];
    [UserDefaults synchronize];
}

//获取本机语言
+ (NSString *)getLocalLanguageCode{
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}
//获取本机MCC
+ (NSString *)getLocalMCC{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
//    NSString *mnc = [carrier mobileNetworkCode];
    return mcc;
}
+ (void)gotoAppstore{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1088805741"]];
    
}





+ (void)showErrorInternet{
//    if([SVProgressHUD isVisible]){
//        return;
//    }
//    [SVProgressHUD showErrorWithStatus:@"Not Connected"];
    [ToolUtility createToastViewWithContent:InternetError WithSuperView:nil andFrame:CGRectZero];
}

+ (void)saveHaveLaunchedApp{
    [UserDefaults setObject:@"haveLaunched" forKey:@"GagsIsFirstLaunch"];
    [UserDefaults synchronize];
}

+ (BOOL)isFirstLaunchApp{
    NSString *ll = [UserDefaults objectForKey:@"GagsIsFirstLaunch"];
    if(ll == nil){
        return YES;
    }
    else{
        return NO;
    }
    return NO;
}

+ (void)saveAutoPlayUserConfig:(BOOL)isPlay{
    [UserDefaults setBool:isPlay forKey:@"GagsAutoPlayConfigKey"];
    [UserDefaults synchronize];
}

+ (BOOL)isAutoPlayUserConfiged{
    return [UserDefaults boolForKey:@"GagsAutoPlayConfigKey"];
}





@end
