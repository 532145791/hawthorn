//
//  HomepageListModel.m
//  BaseProject
//
//  Created by super on 2020/3/23.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "HomepageListModel.h"

@implementation HomepageListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [HomepageItemModel class]
             };
}
@end

@implementation HomepageItemModel

@end
