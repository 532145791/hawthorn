//
//  UserInfoModel.h
//  BaseProject
//
//  Created by 冷超 on 2017/6/30.
//  Copyright © 2017年 lengchao. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel <NSCoding>

/**
 用户id
 */
@property(copy, nonatomic) NSString *uid;

/**
 昵称
 */
@property(copy, nonatomic) NSString *nickname;

/**
 头像
 */
@property(copy, nonatomic) NSString *avatar;
@property (nonatomic , copy) NSString *city;//常驻城市
@property(copy, nonatomic) NSString *age;

/**
 性别
 */
@property(assign, nonatomic) int sex;//1-男 2-女
/**
 手机号
 */
@property(copy, nonatomic) NSString *mobile;
/**
 城市编号
 */
@property(copy, nonatomic) NSString *countryCode;

@property(assign, nonatomic) BOOL isLogined;//是否登录

@property(assign, nonatomic) BOOL ifPartner;//是否是合伙人

@property(assign, nonatomic) int memberStatus;//会员状态 1、待申请 2、审核中 3、使用中 4、已失效 5、免费
@property(copy, nonatomic) NSString *memberLevel;//会员等级

@property(copy, nonatomic) NSString *memberStartDate;//会员起始时间

@property(copy, nonatomic) NSString *memberEndDate;//会员结束时间

@property(copy, nonatomic) NSString *qq;//qq号

@property(copy, nonatomic) NSString *alipayNumber;//支付宝账号

@property (nonatomic , copy) NSString *province;//省

@property (nonatomic , copy) NSString *area;//区

@property (nonatomic , assign) int coinCount;//账户金币数量
@property (nonatomic , assign) NSInteger albumCount;//已上传的相片数量
@property (nonatomic , assign) NSInteger videoCount;//已上传的视频数量
@property(copy, nonatomic) NSString *weixin;//微信号
@end
