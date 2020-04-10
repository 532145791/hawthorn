//
//  MeViewModel.h
//  BaseProject
//
//  Created by super on 2019/10/21.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseViewModel.h"
#import "MyInfoModel.h"
#import "MemberItemModel.h"
#import "MyVideoOrAlbumModel.h"
#import "SubmitWXOrderResultModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MeViewModel : BaseViewModel
@property (nonatomic , strong) RACSubject *orderSignal;
@property (nonatomic , strong) RACSubject *modifyUserIconSignal;
//获取个人资料
-(void)getMyInfoData;

//获取我的信息接口
-(void)getMyData;

/// 提交个人信息
/// @param params 参数
-(void)commitMyInfoWithParams:(NSMutableDictionary *)params;

/// 获取会员信息
-(void)getMerberInfo;

/// 查看我的相册或视频列表数据
/// @param type 1-视频 2-相册
-(void)getVideoOrAlbumWithType:(NSInteger)type;

/**
 提交订单
 @param merberId 会员价格Id
 @param type 支付类型： 1--支付宝 2--微信
 */
-(void)submitOrderWithMerberId:(NSString *)merberId type:(NSInteger)type;

/// 注销账户
-(void)logout;
@end

NS_ASSUME_NONNULL_END
