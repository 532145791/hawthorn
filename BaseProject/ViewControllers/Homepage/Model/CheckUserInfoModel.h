//
//  CheckUserInfoModel.h
//  BaseProject
//
//  Created by super on 2020/3/23.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckUserInfoModel : BaseModel
@property (nonatomic , assign) int status;//状态：1-已完成；2-未完成
@end

NS_ASSUME_NONNULL_END
