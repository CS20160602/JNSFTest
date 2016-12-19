//
//  ToolUtility.h
//  Travel
//
//  Created by ydf on 14-7-15.
//  Copyright (c) 2014年 Elroy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Tag_ZanImageV 88
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

static  NSString *InternetError = @"请检查您的网络连接";

static  NSString *likeNumPerVersion = @"OldVersionLikeNum";  //旧版本点赞

static NSString *ReadedVideoWhichIds = @"readedVideoWhichIds";  //已读标题视频id值

static NSString *WWANNoticeOnlyOnce = @"WWANNoticeOnlyOnce"; //WWAN模式下 提示弹窗仅仅出现一次 1.冷启动置nil  2.切WWAN置nil 3.点击提示弹窗的playNow 置show

static NSString *WWANNoticeShowed   = @"WWANNoticeShowed";

//颜色转换
//#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define Notification [NSNotificationCenter defaultCenter]

#define DeselectRowAtIndexPath  [tableView deselectRowAtIndexPath:indexPath animated:YES]

#define StringWithInt(num) [NSString stringWithFormat:@"%d",num]

#define StringWithInteger(num) [NSString stringWithFormat:@"%zd",num]

#define StringWihtObject(object) [NSString stringWithFormat:@"%@",object]

#define StringWithFormat(fmt,...) [NSString stringWithFormat:fmt,##__VA_ARGS__]

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define NumberWithInteger(num)  [NSNumber numberWithInteger:num]

#define NumberWithFloat(num)     [NSNumber numberWithFloat:num]



@interface ToolUtility : NSObject

#pragma mark - 通用

+ (NSString *)getUUID;
+ (NSDictionary *)getUUIDDic;
+ (NSString *)getAppVersion;

+ (CGFloat)calculateVideoHeight;
+ (CGFloat)tpCalculateVideoHeight;
+ (CGFloat)calculateVideoHeightWithWidth:(CGFloat)width height:(CGFloat)height;
+ (CGFloat)getPlayerHeightWithScaleWidth:(CGFloat)width;
+ (void)savePlayerScaleSize:(CGFloat)width height:(CGFloat)height;

+ (int)getStringLength:(NSString *)text;    //计算字符串长度，汉字为2个字符

+ (NSString *)getNewStringWithOldString:(NSString *)oldStr andSubStringOfOld:(NSString *)subStr; //删除字符串中的某个子字串，得到新串

//注册两个键盘将出现和将隐藏的通知事件
+ (void)KeyboardWillShowSelector:(SEL)keyboardWillShow KeyboardWillHideNotificationSelector:(SEL)keyboardWillHide andWhichVC:(id)paramVC;

+ (void)removeNotificationsOfKeyboardWithWhichVC:(id)paramVC;

+ (BOOL)isNull:(NSString*)text;

+ (NSString *)replaceSpeaceChar:(NSString *)text;

+ (UIImage *) createImageWithColor: (UIColor *) color;

+ (BOOL)judgeDeviceIsInstalledAppWithNameStr:(NSString *)strSign;

//转换评论内容
+ (NSString *)composeCommentContent:(NSString *)comment atSomeOne:(NSString *)atSomeOne;

//点赞动画
//+ (CAAnimation *)likeAnimation;

#define LikeAnimation @"like_scale"

#pragma mark - 动画和分享
+ (void)clickZanAddAnimationToView:(UIView *)view withRepeatCount:(float)repCount;
// 双击点赞 飘心
+ (void)createImgViewWithCGPoint:(CGPoint)point  andSuperView:(UIView *)superView;

//设置视图的边框
//+ (void)setViewBorder:(UIView *)view;

+ (NSDate *)getCurrentDateWithFirstDate:(NSDate *)originDate andSeconds:(int)seconds;

//time 150703
+ (NSString *)getNewStringWithOldString:(NSString *)oldString componetByStr:(NSString *)fuhao;


#pragma mark - 视频相关
/**
 *  @brief      //获取视频发布的时间点
 *  @param  time视频发布的时间
 */
+ (NSString *)setTimeStyleWithSeconds:(NSString *)time;


/**
 *  @brief     //获取视频的播放时长格式
 *  @param  num  视频播放总秒数
 */
+ (NSString *)getVideoTimeWithSeconds:(NSNumber *)num;

/**
 *   @brief 获取视频的数量统计字符串
 *  @param  seconds  视频播放总秒数
 *  @param  viewNum  视频播放总秒数
 */
+ (NSString *)getVideoStaticsInfoWithSeconds:(NSInteger)seconds andViewNum:(NSInteger)viewNum;

//url编码
+ (NSString *)stringWithURLEncodeding:(NSString *)str;

//刷新商品列表 保持与下一个页面的商品在数量，到货通知等同步
+ (void)refreshGoodsListInfoWithSelector:(SEL)refreshListSelector WithCurObject:(id)curObj andNotiName:(NSString *)notiName;
+ (void)removeNotificationsWithCurObject:(id)curObj andNotiName:(NSString *)notiName;

// 获取设备唯一标识
+ (NSString *) deviceId;
+ (UIImage *)placeholderImageForProvider;
+ (UIImage *)placeholderImageForGoods;

+ (CGSize)sizeString:(NSString*)string withFont:(UIFont*)font;

+ (CGSize)sizeString:(NSString *)string WithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

//+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text;

//获取本机国家地址
+ (NSString *)getLocalCountryCode;
//获取本机语言
+ (NSString *)getLocalLanguageCode;
//获取本机MCC
+ (NSString *)getLocalMCC;

+ (void)gotoAppstore;

#pragma mark - 此项目 生成一些复用的自定义view
/**
 *  @brief //生成toast提示
 *  @param text 生成的提示文本
 *  @param selfView toast的父视图
 */
+ (void)createToastViewWithContent:(NSString *)text WithSuperView:(UIView *)selfView andFrame:(CGRect)frame;

+ (void)createToastViewWithCenter:(BOOL)center WithContent:(NSString *)text withSuperView:(UIView *)selfView andFrame:(CGRect)frame;

@end
