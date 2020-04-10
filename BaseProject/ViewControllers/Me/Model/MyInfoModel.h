//
//  MyInfoModel.h
//  BaseProject
//
//  Created by super on 2019/10/21.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AlbumOrVideoModel : BaseModel
@property (nonatomic , copy) NSString *path;//路径
@end

@interface MyInfoModel : BaseModel
@property (nonatomic , copy) NSString *userIdTo;//用户id
@property (nonatomic , copy) NSString *headPath;//头像地址
@property (nonatomic , copy) NSString *nickname;//昵称
@property (nonatomic , assign) int gender;//用户性别（默认为0）：0-无；1-男；2-女
@property (nonatomic , copy) NSString *city;//常驻城市
@property (nonatomic , copy) NSString *age;
@property (nonatomic , copy) NSString *likes;//爱好
@property (nonatomic , copy) NSString *occupation;//职业
@property (nonatomic , copy) NSString *height;
@property (nonatomic , copy) NSString *weixin;
@property (nonatomic , copy) NSString *weight;
@property (nonatomic , copy) NSString *merberStatus;//会员状态：未开通、已开通、已过期
@property (nonatomic , copy) NSString *inviteCode;//邀请码
@property (nonatomic , assign) int album;
@property (nonatomic , assign) int video;
@property (nonatomic , strong) NSArray <AlbumOrVideoModel *>*albumList;
@property (nonatomic , strong) NSArray <AlbumOrVideoModel *>*videoList;
@end

NS_ASSUME_NONNULL_END
