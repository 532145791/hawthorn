//
//  LoginResultModel.h
//  BaseProject
//
//  Created by super on 2019/10/21.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginResultModel : BaseModel
@property (nonatomic , copy) NSString *token;
@property (nonatomic , copy) NSString *id;//唯一认证标示
@property (nonatomic , copy) NSString *headPath;//头像地址
@property (nonatomic , copy) NSString *nickname;//昵称
@property (nonatomic , assign) int gender;//用户性别（默认为0）：0-无；1-男；2-女
@property (nonatomic , copy) NSString *city;//常驻城市
@property (nonatomic , copy) NSString *weixin;//微信号
@property (nonatomic , copy) NSString *age;
@property (nonatomic , copy) NSString *likes;//爱好
@property (nonatomic , copy) NSString *occupation;//职业
@property (nonatomic , copy) NSString *height;
@property (nonatomic , copy) NSString *weight;
@end

NS_ASSUME_NONNULL_END
