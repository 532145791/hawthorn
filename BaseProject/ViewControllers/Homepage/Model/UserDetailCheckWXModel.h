//
//  UserDetailCheckWXModel.h
//  BaseProject
//
//  Created by super on 2020/3/23.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailCheckWXModel : BaseModel
@property (nonatomic , assign) int times;//剩余次数（999表示已开通会员）
@property (nonatomic , copy) NSString *weixin;//微信号
@end

NS_ASSUME_NONNULL_END
