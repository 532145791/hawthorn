//
//  VersionModel.m
//  BaseProject
//
//  Created by super on 2019/10/23.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "VersionModel.h"

@implementation VersionModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
        @"kswitch" : @"switch",
    };
}
@end
