//
//  CommonTool.h
//  ProjectXmall
//
//  Created by 冷超 on 2017/6/6.
//  Copyright © 2017年 yao liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

/**
 获取当前手机网络类型
 */
+ (NSString *)networkType;

/**
 获取build版本号
 */
+ (NSString *)appBuild;

/**
 获取version版本号
 */
+ (NSString *)appVersion;

/**
 获取系统版本号
 */
+ (NSString *)systemVersion;

/**
 获取设备名称
 */
+ (NSString *)deviceName;
/**
 获取当前设备时区
 */
+ (NSString *)timeZone;
+ (NSString *)country;
+ (NSString *)language;
+ (NSString *)uuid;
+ (NSString *)displayName;
//判空
+(BOOL)isNull:(id)object;

/**
 获取当前控制器
 */
+ (UIViewController *)currentViewController;


//保存UUID到钥匙串
+(void)saveDeviceIdentifier;
//从钥匙串中取出UUID
+(NSString *)getDeviceIdentifier;

//年龄1: 00后 2：90后 3：80后
+(NSInteger)getAgeNumberWithAge:(NSString *)age;
+(NSString *)getAgeStrWithIndex:(NSInteger)index;
//类型1上门 2居家 3实体店
+(NSInteger)getTypeNumberWithType:(NSString *)type;
+(NSString *)getTypeStrWithIndex:(NSInteger)index;
//会员状态 1、待申请 2、审核中 3、使用中 4、已失效 5、免费
+(NSString *)getMemberStatusDescWithInt:(NSInteger)i;
//禁止输入表情
+ (NSString*)disable_EmojiString:(NSString *)text;
// 获取视频第一帧图片
+ (UIImage *)getFirstFrameWithVideoURL:(NSURL *)URL;
// 获取视频文件的时长。
+ (int)getVideoLength:(NSURL *)URL;
// 获取文件的大小，返回的是单位是MB。
+ (CGFloat)getFileSize:(NSString *)path;
//获取一个随机长度的字符串
+ (NSString *)randomStringWithLength:(NSInteger)length;
@end
