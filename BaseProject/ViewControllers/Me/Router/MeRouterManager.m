//
//  MeRouterManager.m
//  BaseProject
//
//  Created by super on 2019/10/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "MeRouterManager.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "BuyCoinViewController.h"
#import "MyPhotoViewController.h"
#import "BindCardViewController.h"
#import "BaseWebViewController.h"
@implementation MeRouterManager
+(void)load{
    //个人资料
    [MGJRouter registerURLPattern:kProfileViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        ProfileViewController *vc = [[ProfileViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    //设置
    [MGJRouter registerURLPattern:kSettingViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        SettingViewController *vc = [[SettingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    //金币购买
    [MGJRouter registerURLPattern:kBuyCoinViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        BuyCoinViewController *vc = [[BuyCoinViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    //我的相册额
    [MGJRouter registerURLPattern:kMyPhotoViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        MyPhotoViewController *vc = [[MyPhotoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    //绑定银行卡
    [MGJRouter registerURLPattern:kBindCardViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        BindCardViewController *vc = [[BindCardViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    //通用的h5页面
    [MGJRouter registerURLPattern:kBaseWebViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        BaseWebViewController *vc = [[BaseWebViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
}
@end
