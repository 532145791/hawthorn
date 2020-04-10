//
//  SJInfoModel.h
//  BaseProject
//
//  Created by super on 2019/10/21.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJInfoModel : BaseModel
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *address;
@property (nonatomic , assign) NSInteger age;
@property (nonatomic , copy) NSString *area;
@property (nonatomic , copy) NSString *city;
@property (nonatomic , copy) NSString *duration;
@property (nonatomic , copy) NSString *height;
@property (nonatomic , copy) NSString *id;//私教ID
@property (nonatomic , copy) NSString *image;
@property (nonatomic , copy) NSString *introduce;
@property (nonatomic , assign) NSInteger modifiableTimes;//可更改次数
@property (nonatomic , copy) NSString *occupation;//职业
@property (nonatomic , assign) NSInteger price;
@property (nonatomic , assign) NSInteger privateEducationStatus;
@property (nonatomic , copy) NSString *province;
@property (nonatomic , assign) NSInteger status;
@property (nonatomic , copy) NSString *taIntermediaryId;//中介ID
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , copy) NSString *weight;
@property (nonatomic , copy) NSString *qq;//中介qq
@end

NS_ASSUME_NONNULL_END
