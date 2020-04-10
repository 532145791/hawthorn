//
//  BannerListModel.h
//  BaseProject
//
//  Created by super on 2019/10/21.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerListModel : BaseModel
@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *imageLink;
@property (nonatomic , copy) NSString *privateIntermediaryId;//私教或中介ID
@property (nonatomic , assign) NSInteger status;
@property (nonatomic , assign) NSInteger type;//类型：1、中介轮播 2、私教轮播
@end

NS_ASSUME_NONNULL_END
