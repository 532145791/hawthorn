//
//  VersionModel.h
//  BaseProject
//
//  Created by super on 2019/10/23.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VersionModel : BaseModel

@property (nonatomic , assign) NSInteger type;//1-强制更新  2-非强制更新
@property (nonatomic , assign) NSInteger kswitch;//1-强制更新  2-非强制更新
@property (nonatomic , copy) NSString *version;//版本号
@property (nonatomic , copy) NSString *downloadUrl;//下载地址
@end

NS_ASSUME_NONNULL_END
