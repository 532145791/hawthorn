

//--------------******** 宏定义 ********--------------//

#ifndef AppMacroDefine_h
#define AppMacroDefine_h

#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define NoKnowError @"抱歉，服务器出错，请重试"
#define DismissTime 1.5
#define BackGround_Color Color(kColor_White)
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Adapt_Width(x) ((x) * [UIScreen mainScreen].bounds.size.width / 375.0)
#define Adapt_Height(x) ((x) * [UIScreen mainScreen].bounds.size.height / 667.0)
#define System_Version [[[UIDevice currentDevice] systemVersion] floatValue]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//是否为X
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//底部距离
#define Home_Indicator ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 83.0 : 49.0)
//导航栏高度
#define KNavigationBar_HEIGHT ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)


//字体
#define Font_Semibold(fontValue)  [UIFont fontWithName:@"PingFangSC-Semibold"  size:fontValue]
#define Font_Light(fontValue)  [UIFont fontWithName:@"PingFangSC-Light"  size:fontValue]
#define Font_Regular(fontValue)  [UIFont fontWithName:@"PingFangSC-Regular"  size:fontValue]
#define Font_Medium(fontValue)  [UIFont fontWithName:@"PingFangSC-Medium"  size:fontValue]

//颜色
#define Color(colorHex) [UIColor colorWithHexString:colorHex]
#define Color_alpha(colorHex,a) [UIColor colorWithHexString:colorHex alpha:a]

//信号监听
#define Weakify(x) @weakify(x)
#define Strongify(x) @strongify(x)

#define kCustomerServiceQQ @"3294668249"
#define kWXAppID @"wx56aae5768a7fc7d2"
#define kWXAppSecret @"f976258b7e85f955136850ba918c4d3a"
#define kUmengAppKey @"5e69dea50cafb2d381000127"
#define kBuglyAppID @"a15740bb4e"
#define kQQAppID @"1110259151"
#define kQQAppKey @"pG5LOt4zzWfPt2dI"
#define kDownloadUrl @"http://xtmsmp.com/qy/jgeq"
#define kOSSEndpoint @"oss-cn-shanghai.aliyuncs.com"
#define kOSSBucketName @"hawthorn"
#define kPrivacyPolicy @"http://q7oz2vuc3.bkt.clouddn.com/privacyPolicy.html"
#define kProtocol @"http://q7oz2vuc3.bkt.clouddn.com/protocol.html"
#define kQiniuHost @"http://q7oz2vuc3.bkt.clouddn.com/"
#endif /* AppMacroDefine_h */
