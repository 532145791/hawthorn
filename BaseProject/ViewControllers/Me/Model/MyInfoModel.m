//
//  MyInfoModel.m
//  BaseProject
//
//  Created by super on 2019/10/21.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "MyInfoModel.h"

@implementation MyInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"albumList" : [AlbumOrVideoModel class],
             @"videoList" : [AlbumOrVideoModel class],
             };
}
@end

@implementation AlbumOrVideoModel

@end
