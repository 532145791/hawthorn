//
//  SubmitWXOrderResultModel.h
//  BaseProject
//
//  Created by super on 2018/12/22.
//  Copyright © 2018 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubmitWXOrderContentModel : BaseModel
@property (nonatomic , copy) NSString *appid;//微信开放平台审核通过的应用APPID
@property (nonatomic , copy) NSString *partnerid;//微信支付分配的商户号
@property (nonatomic , copy) NSString *prepayid;//微信返回的支付交易会话ID
@property (nonatomic , copy) NSString *noncestr;//随机字符串，不长于32位。推荐随机数生成算法
@property (nonatomic , copy) NSString *timestamp;//时间戳
@property (nonatomic , copy) NSString *sign;//签名
@end

@interface SubmitWXOrderResultModel : BaseModel
@property (nonatomic , copy) NSString *orderGuid;//订单唯一认证标识
@property (nonatomic , copy) NSString *paymtNumb;//支付请求号
@property (nonatomic , strong) SubmitWXOrderContentModel *orderContent;//订单内容
@end

NS_ASSUME_NONNULL_END
