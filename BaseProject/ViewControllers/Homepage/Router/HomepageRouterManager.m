//
//  HomepageRouterManager.m
//  BaseProject
//
//  Created by super on 2019/9/27.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "HomepageRouterManager.h"
#import "ReportViewController.h"
#import "UserDetailViewController.h"
#import "RegisterViewController.h"
@implementation HomepageRouterManager
+(void)load{
    //登录
    [MGJRouter registerURLPattern:kLoginViewController toHandler:^(NSDictionary *routerParameters) {
        BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        navi.hidesBottomBarWhenPushed = YES;
        navi.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [[CommonTool currentViewController] presentViewController:navi animated:YES completion:nil];
    }];
    
    //注册
    [MGJRouter registerURLPattern:kRegisterViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    //举报
    [MGJRouter registerURLPattern:kReportViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        ReportViewController *vc = [[ReportViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    //用户详情页
    [MGJRouter registerURLPattern:kUserDetailViewController toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *dic = routerParameters[MGJRouterParameterUserInfo];
        UserDetailViewController *vc = [[UserDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.params = [dic copy];
        [[CommonTool currentViewController].navigationController pushViewController:vc animated:YES];
    }];
}
@end
