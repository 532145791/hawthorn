//
//  CommonTool.m
//  ProjectXmall
//
//  Created by 冷超 on 2017/6/6.
//  Copyright © 2017年 yao liu. All rights reserved.
//

#import "CommonTool.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UICKeyChainStore.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation CommonTool
+ (NSString *)networkType {
    NSString *netconnType = @"";
    
    // 获取手机网络类型
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *currentStatus = info.currentRadioAccessTechnology;
    
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        
        netconnType = @"GPRS";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        
        netconnType = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        
        netconnType = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        
        netconnType = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        
        netconnType = @"2G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        
        netconnType = @"3G";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        
        netconnType = @"HRPD";
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        
        netconnType = @"4G";
    }
    
    return netconnType;
}


+ (NSString *)appBuild {
    return   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)appBuildId{
    return   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

+ (NSString *)appVersion {
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)systemVersion {
    return  [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)deviceName {
    return [[UIDevice currentDevice] systemName];
}

+ (NSString *)timeZone {
    return [NSTimeZone localTimeZone].name;
}

+ (NSString *)country {
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    return  [currentLocale objectForKey:NSLocaleCountryCode];
}

+ (NSString *)language {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+ (NSString *)uuid {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+(NSString *)displayName{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

+(BOOL)isNull:(id)object{
    if(object==nil||object==[NSNull null]){
        return YES;
    }else if([object isKindOfClass:[NSString class]]){
        NSString *string=object;
        if ([string isEqual:@""]||string.length == 0) {
            return YES;
        }
    }else if([object isKindOfClass:[NSData class]]){
        NSData *data=object;
        if (data.length==0) {
            return YES;
        }
    }else if([object isKindOfClass:[NSDictionary class]]){
        NSDictionary *dictionary=object;
        if (dictionary.count==0) {
            return YES;
        }
    }else if([object isKindOfClass:[NSArray class]]){
        NSArray *array=object;
        if (array.count==0) {
            return YES;
        }
    }
    return NO;
}

+ (UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (UIViewController *)currentViewController
{
    UIViewController *currentViewController;
    currentViewController = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (currentViewController.presentedViewController) {
        currentViewController = [self topViewController:currentViewController.presentedViewController];
    }
    return currentViewController;
}

+(void)saveDeviceIdentifier{
    [UICKeyChainStore setString:[self uuid] forKey:@"keychain" service:[self appBuildId]];
}

+(NSString *)getDeviceIdentifier{
    return [UICKeyChainStore stringForKey:@"keychain" service:[self appBuildId]];
}

//年龄1: 00后 2：90后 3：80后
+(NSInteger)getAgeNumberWithAge:(NSString *)age{
    if ([age isEqualToString:@"00后"]) {
        return 1;
    }
    
    if ([age isEqualToString:@"90后"]) {
        return 2;
    }
    
    if ([age isEqualToString:@"80后"]) {
        return 3;
    }
    
    return 0;
}

+(NSString *)getAgeStrWithIndex:(NSInteger)index{
    switch (index) {
        case 1:
            return @"00后";
            break;
            
            case 2:
            return @"90后";
            break;
            
            case 3:
            return @"80后";
            break;
        default:
            break;
    }
    
    return @"90后";
}

//类型1上门 2居家 3实体店
+(NSInteger)getTypeNumberWithType:(NSString *)type{
    if ([type isEqualToString:@"上门"]) {
        return 1;
    }
    
    if ([type isEqualToString:@"居家"]) {
        return 2;
    }
    
    if ([type isEqualToString:@"实体店"]) {
        return 3;
    }
    
    return 0;
}

+(NSString *)getTypeStrWithIndex:(NSInteger)index{
    switch (index) {
        case 1:
            return @"上门";
            break;
            
            case 2:
            return @"居家";
            break;
            
            case 3:
            return @"实体店";
            break;
            
        default:
            break;
    }
    
    return @"居家";
}

+ (NSString*)disable_EmojiString:(NSString *)text{
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* result = [expression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    return result;
}

//会员状态 1、待申请 2、审核中 3、使用中 4、已失效 5、免费
+(NSString *)getMemberStatusDescWithInt:(NSInteger)i{
    switch (i) {
        case 1:
            return @"待申请";
            break;
            case 2:
            return @"审核中";
            break;
            
            case 3:
            return @"使用中";
            break;
            
            case 4:
            return @"已失效";
            break;
            
            case 5:
            return @"免费";
            break;
        default:
            break;
    }
    return @"已失效";
}

// 获取视频第一帧图片
+ (UIImage *)getFirstFrameWithVideoURL:(NSURL *)URL{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(375, 375);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    if (!error) {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

// 获取视频文件的时长。
+ (int)getVideoLength:(NSURL *)URL{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value / time.timescale);
    return second;
}

+(NSString *)randomStringWithLength:(NSInteger)length{
    NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    if (randomString) {
        return randomString;
    }
    return @"0";
}

// 获取文件的大小，返回的是单位是MB。
+ (CGFloat)getFileSize:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        // 获取文件的属性
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024/1024;
    } else {
        NSLog(@"没有找到相关文件");
    }
    return filesize;
}
@end
