//
//  AppDelegate+AppService.h
//  BaseProject
//
//  Created by super on 2018/1/23.
//  Copyright © 2018年 lengchao. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface AppDelegate (AppService)<WXApiDelegate,QQApiInterfaceDelegate>

/**
 设置HUD风格
 */
-(void)setUpHUDStyle;

/**
 集成IQKeyboardManager
 */
-(void)setUpIQKeyboardManager;

/**
 集成友盟
 */
-(void)setUpUMeng;

/**
设置导航条风格
*/
-(void)setUpNavigationBar;

/**
 集成微信
 */
-(void)setUpWX;

/**
 集成QQ
 */
-(void)setUpQQ;

/**
集成Bugly
*/
-(void)setUpBugly;
@end
