//
//  MemberItemModel.m
//  BaseProject
//
//  Created by super on 2019/10/22.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "MemberItemModel.h"

@implementation MemberItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [MemberItemDetailModel class]
             };
}
@end

@implementation MemberItemDetailModel

@end
