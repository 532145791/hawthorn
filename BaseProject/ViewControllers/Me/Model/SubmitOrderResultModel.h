//
//  SubmitOrderResultModel.h
//  BaseProject
//
//  Created by super on 2018/12/11.
//  Copyright © 2018 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubmitOrderResultModel : BaseModel
@property (nonatomic , copy) NSString *orderNumb;//订单唯一认证标识
@property (nonatomic , copy) NSString *orderContent;//订单内容
@end

NS_ASSUME_NONNULL_END
