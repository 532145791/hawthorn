//
//  CommonPageModel.h
//  BaseProject
//
//  Created by super on 2020/3/26.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonPageModel : BaseModel
@property (nonatomic , assign) NSInteger currentPage;//当前页码
@property (nonatomic , assign) NSInteger pageSize;//每页多少条记录
@property (nonatomic , assign) NSInteger total;//总记录数
@end

NS_ASSUME_NONNULL_END
