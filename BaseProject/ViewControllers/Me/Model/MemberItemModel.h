//
//  MemberItemModel.h
//  BaseProject
//
//  Created by super on 2019/10/22.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberItemDetailModel : BaseModel
@property (nonatomic , copy) NSString *value;//价格
@property (nonatomic , copy) NSString *id;//会员价格唯一认证标识
@property (nonatomic , copy) NSString *name;//时间
@property (nonatomic , copy) NSString *mark;//苹果商品id
@end

@interface MemberItemModel : BaseModel
@property (nonatomic , strong) NSArray <MemberItemDetailModel *> *list;
@property (nonatomic , copy) NSString *merberDate;//会员到期日期
@end

NS_ASSUME_NONNULL_END
