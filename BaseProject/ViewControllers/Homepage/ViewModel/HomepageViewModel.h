//
//  HomepageViewModel.h
//  BaseProject
//
//  Created by super on 2019/10/9.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseViewModel.h"
#import "CheckUserInfoModel.h"
#import "HomepageListModel.h"
#import "MyInfoModel.h"
#import "UserDetailCheckWXModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomepageViewModel : BaseViewModel
@property (nonatomic , strong) RACSubject *checkResultSignal;
/// 检测个人信息是否完善
-(void)checkUserInfo;

/// 首页列表
/// @param city 常驻城市
/// @param gender 性别：1-男，2-女
/// @param currentPage 当前页码
-(void)loadListDataWithCity:(NSString *)city gender:(NSInteger)gender currentPage:(NSInteger)currentPage;

/// 获取用户信息
/// @param userId 用户id
-(void)loadUserDetailWithUserId:(NSString *)userId;

/// 查看微信号
/// @param userId 用户id
-(void)getWeixinWithUserId:(NSString *)userId;

/// 举报
/// @param userId 用户id
/// @param content 举报内容
-(void)reportWithUserId:(NSString *)userId content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
