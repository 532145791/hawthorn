//
//  MeViewModel.m
//  BaseProject
//
//  Created by super on 2019/10/21.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "MeViewModel.h"
#import "SubmitOrderResultModel.h"
#import "SubmitWXOrderResultModel.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation MeViewModel

//获取个人信息
-(void)getMyInfoData{
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingString:@"/users/getInfo"] paras:[NSDictionary dictionary] success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        MyInfoModel *model = [MyInfoModel modelWithJSON:result.data];
        if (model) {
            [self.resultSignal sendNext:model];
        }
    } failure:^(NSError *error) {
        
    }];
}

//获取我的信息接口
-(void)getMyData{
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingString:@"/users/myInfo"] paras:[NSDictionary dictionary] success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        MyInfoModel *model = [MyInfoModel modelWithJSON:result.data];
        if (model) {
            UserInfoModel *userInfo = [UserInfoManager getUserInfo];
            userInfo.nickname = model.nickname;
            userInfo.albumCount = model.album;
            userInfo.videoCount = model.video;
            [UserInfoManager setUserInfo:userInfo];
            [self.resultSignal sendNext:model];
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 提交个人信息
/// @param params 参数
-(void)commitMyInfoWithParams:(NSMutableDictionary *)params{
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingString:@"/users/editInfo"] paras:params success:^(ResultModel *result) {
        [SVProgressHUD showMessageWithStatus:@"提交成功"];
        UserInfoModel *userInfo = [UserInfoManager getUserInfo];
        userInfo.weixin = params[@"weixin"];
        userInfo.nickname = params[@"nickname"];
        userInfo.city = params[@"city"];
        [UserInfoManager setUserInfo:userInfo];
        [[CommonTool currentViewController].navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

/// 获取会员信息
-(void)getMerberInfo{
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingString:@"/users/getMerberInfo"] paras:[NSDictionary dictionary] success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        MemberItemModel *model = [MemberItemModel modelWithJSON:result.data];
        if (model) {
            if (self.dataArr.count > 0) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:model.list];
            [self.resultSignal sendNext:model];
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 查看我的相册或视频列表数据
/// @param type 1-视频 2-相册
-(void)getVideoOrAlbumWithType:(NSInteger)type{
    [SVProgressHUD show];
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userInfo.uid forKey:@"userIdTo"];
    [dic setObject:@(type) forKey:@"type"];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/look"] paras:dic success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        MyVideoOrAlbumModel *model = [MyVideoOrAlbumModel modelWithJSON:result.data];
        if (model) {
            if (self.dataArr.count > 0) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:model.list];
            UserInfoModel *userInfo = [UserInfoManager getUserInfo];
            if (type == 1) {
                userInfo.videoCount = model.list.count;
            }else{
                userInfo.albumCount = model.list.count;
            }
            [UserInfoManager setUserInfo:userInfo];
        }
        [self.resultSignal sendNext:@(1)];
    } failure:^(NSError *error) {
        
    }];
}

/**
 提交订单
 @param merberId 会员价格Id
 @param type 支付类型： 1--支付宝 2--微信
 */
-(void)submitOrderWithMerberId:(NSString *)merberId type:(NSInteger)type{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:merberId forKey:@"merberId"];
    [dic setObject:@(type) forKey:@"type"];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingString:@"/users/pay"] paras:dic success:^(ResultModel *result) {
        if (type == 1) {
            SubmitOrderResultModel *model = [SubmitOrderResultModel modelWithJSON:result.data];
            if (model) {
                [[AlipaySDK defaultService] payOrder:model.orderContent fromScheme:@"hawthorn" callback:^(NSDictionary *resultDic) {
                    NSLog(@"支付结果回调2 = %@",resultDic);
                }];
            }
        }else{
            SubmitWXOrderResultModel *model = [SubmitWXOrderResultModel modelWithJSON:result.data];
            if (model) {
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = model.orderContent.partnerid;
                request.prepayId = model.orderContent.prepayid;
                request.package = @"Sign=WXPay";
                request.nonceStr = model.orderContent.noncestr;
                request.timeStamp = model.orderContent.timestamp.intValue;
                request.sign = model.orderContent.sign;
                [WXApi sendReq:request];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/// 注销账户
-(void)logout{
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingString:@"/users/logout"] paras:[NSDictionary dictionary] success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        [UserDefaults removeWithKey:@"Token"];
        [UserInfoManager deleteUserInfo];
        BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [AppDelegate sharedAppDelegate].window.rootViewController = nv;
    } failure:^(NSError *error) {
        
    }];
}

-(RACSubject *)orderSignal{
    if (!_orderSignal) {
        _orderSignal = [RACSubject subject];
    }
    return _orderSignal;
}

-(RACSubject *)modifyUserIconSignal{
    if (!_modifyUserIconSignal) {
        _modifyUserIconSignal = [RACSubject subject];
    }
    return _modifyUserIconSignal;
}
@end
