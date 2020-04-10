//
//  LoginViewModel.m
//  BaseProject
//
//  Created by super on 2019/10/9.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginResultModel.h"
@implementation LoginViewModel

/// 登录
/// @param phone 手机号
/// @param code 验证码
-(void)loginWithPhone:(NSString *)phone code:(NSString *)code{
    if ([CommonTool isNull:phone]) {
        [SVProgressHUD showMessageWithStatus:@"请输入手机号"];
    }
    
    if ([CommonTool isNull:code]) {
        [SVProgressHUD showMessageWithStatus:@"请输入验证码"];
    }
    
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/login"] paras:@{@"mobileNumber":phone,@"verCode":code} success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        LoginResultModel *model = [LoginResultModel modelWithJSON:result.data];
        if (model.token) {
            UserInfoModel *userInfo = [UserInfoManager getUserInfo];
            userInfo.uid = model.id;
            userInfo.sex = model.gender;
            userInfo.city = model.city;
            userInfo.weixin = model.weixin;
            [UserInfoManager setUserInfo:userInfo];
            [UserDefaults saveDataWithKey:@"Token" value:model.token];
            
            [[AppDelegate sharedAppDelegate].window setRootViewController:[AppDelegate sharedAppDelegate].tabbar];
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 注册
/// @param phone 手机号
/// @param code 验证码
/// @param inviteCode 邀请码
-(void)registerWithPhone:(NSString *)phone code:(NSString *)code inviteCode:(NSString *)inviteCode{
    if ([CommonTool isNull:phone]) {
        [SVProgressHUD showMessageWithStatus:@"请输入手机号"];
    }
    
    if ([CommonTool isNull:code]) {
        [SVProgressHUD showMessageWithStatus:@"请输入验证码"];
    }
    
    if ([CommonTool isNull:inviteCode]) {
        [SVProgressHUD showMessageWithStatus:@"请输入邀请码"];
    }
    
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/register"] paras:@{@"mobileNumber":phone,@"verCode":code,@"inviteCode":inviteCode} success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        LoginResultModel *model = [LoginResultModel modelWithJSON:result.data];
        if (model.token) {
            UserInfoModel *userInfo = [UserInfoManager getUserInfo];
            userInfo.uid = model.id;
            userInfo.sex = model.gender;
            userInfo.city = model.city;
            userInfo.weixin = model.weixin;
            [UserInfoManager setUserInfo:userInfo];
            [UserDefaults saveDataWithKey:@"Token" value:model.token];
            [UserDefaults saveDataWithKey:@"FirstLogin" value:@(2)];
            
            [[AppDelegate sharedAppDelegate].window setRootViewController:[AppDelegate sharedAppDelegate].tabbar];
        }
    } failure:^(NSError *error) {
        
    }];
}

//随机一个上海城市数据
-(NSString *)randomCity{
    NSArray *cityArr = @[@"黄浦区",@"徐汇区",@"长宁区",@"静安区",@"普陀区",@"虹口区",@"杨浦区",@"闵行区",@"宝山区",@"嘉定区",@"浦东新区",@"金山区",@"松江区",@"青浦区",@"奉贤区",@"崇明县",@"南汇区",@"卢湾区",@"闸北区"];
    int x =( arc4random() % 19) ;
    return [NSString stringWithFormat:@"上海市_上海市_%@",cityArr[x]];
}

/// 获取验证码
/// @param phone 手机号
-(void)getVeriCodeWithPhone:(NSString *)phone{
    if ([CommonTool isNull:phone]) {
        [SVProgressHUD showMessageWithStatus:@"请输入手机号"];
    }
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/sendCode"] paras:@{@"mobileNumber":phone,@"deviceId":[CommonTool getDeviceIdentifier]} success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        [self.getVeriCodeResultSignal sendNext:@"1"];
    } failure:^(NSError *error) {
        
    }];
}

/// 检测版本更新
-(void)checkNewVersion{
    [HttpTool postWithUrl:[BaseUrl stringByAppendingString:@"/users/version"] paras:@{@"type":@"1",@"version":[CommonTool appVersion]} success:^(ResultModel *result) {
        VersionModel *model = [VersionModel modelWithJSON:result.data];
        if (model) {
            [UserDefaults saveDataWithKey:@"kswitch" value:@(model.kswitch)];
            if (model.type == 1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请立即更新到最新版本，否则无法继续使用APP" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadUrl] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
                    
                }];
                [alert addAction:cameraAction];
                [[CommonTool currentViewController] presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(RACSubject *)getVeriCodeResultSignal{
    if (!_getVeriCodeResultSignal) {
        _getVeriCodeResultSignal = [RACSubject subject];
    }
    return _getVeriCodeResultSignal;
}
@end
