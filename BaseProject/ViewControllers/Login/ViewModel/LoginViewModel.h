//
//  LoginViewModel.h
//  BaseProject
//
//  Created by super on 2019/10/9.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseViewModel.h"
#import "VersionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : BaseViewModel

@property (nonatomic , strong) RACSubject *getVeriCodeResultSignal;//获取验证码结果信号

/// 登录
/// @param phone 手机号
/// @param code 验证码
-(void)loginWithPhone:(NSString *)phone code:(NSString *)code;

/// 注册
/// @param phone 手机号
/// @param code 验证码
/// @param inviteCode 邀请码
-(void)registerWithPhone:(NSString *)phone code:(NSString *)code inviteCode:(NSString *)inviteCode;

/// 获取验证码
/// @param phone 手机号
-(void)getVeriCodeWithPhone:(NSString *)phone;

/// 检测版本更新
-(void)checkNewVersion;
@end

NS_ASSUME_NONNULL_END
