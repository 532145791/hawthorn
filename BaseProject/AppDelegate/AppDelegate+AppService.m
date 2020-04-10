//
//  AppDelegate+AppService.m
//  BaseProject
//
//  Created by super on 2018/1/23.
//  Copyright © 2018年 lengchao. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <Bugly/Bugly.h>

@implementation AppDelegate (AppService)
-(void)setUpHUDStyle{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setCornerRadius:2.0];
    [SVProgressHUD setFont:Font_Regular(14)];
}

-(void)setUpUMeng{
    [UMConfigure initWithAppkey:kUmengAppKey channel:@"AppStore"];
}

-(void)setUpNavigationBar{
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : Font_Regular(17),
                                     NSForegroundColorAttributeName : Color(kColor_333333)
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:Color(kColor_333333)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
}

-(void)setUpIQKeyboardManager{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

/**
集成Bugly
*/
-(void)setUpBugly{
    [Bugly startWithAppId:kBuglyAppID];
}

/**
 集成微信
 */
-(void)setUpWX{
    [WXApi registerApp:kWXAppID];
}

/**
 集成QQ
 */
-(void)setUpQQ{
    TencentOAuth *oath = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:nil];
    NSLog(@"self.tencentOAuth=%@",oath);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"] && [url.absoluteString containsString:@"pay"]){//微信支付回调
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.absoluteString hasPrefix:@"hawthorn://safepay"]) {//支付宝支付回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result11111 = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kPay_ZFB_Result object:nil userInfo:@{@"resultStatus":resultDic[@"resultStatus"]}];
        }];
        
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result222222 = %@",resultDic);
            
        }];
    }else if ([url.absoluteString hasPrefix:@"tencent1110259151://"]){//qq分享回调
        [QQApiInterface handleOpenURL:url delegate:self];
    }else if ([url.absoluteString hasPrefix:@"wx56aae5768a7fc7d2://"]){//微信分享回调
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// 从微信或QQ分享过后点击返回应用的时候调用
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]){//支付回调
        PayResp *response = (PayResp*)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPay_WX_Result object:nil userInfo:@{@"errCode":@(response.errCode)}];
    }else if ([resp isKindOfClass:[QQBaseResp class]]){
        QQBaseResp *reponse = (QQBaseResp *)resp;
        NSLog(@"分享结果：%@",reponse.result);
        if ([reponse.result isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShareSuccess object:nil];
            [SVProgressHUD showMessageWithStatus:@"分享成功"];
        }else{
            [SVProgressHUD showMessageWithStatus:@"分享失败"];
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){//微信分享结果不再提示成功还是失败了
        [[NSNotificationCenter defaultCenter] postNotificationName:kShareSuccess object:nil];
    }
}
@end
