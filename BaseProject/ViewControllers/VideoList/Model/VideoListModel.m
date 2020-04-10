//
//  VideoListModel.m
//  BaseProject
//
//  Created by super on 2020/3/18.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [VideoItemModel class]
             };
}
@end

@implementation VideoItemModel

@end
