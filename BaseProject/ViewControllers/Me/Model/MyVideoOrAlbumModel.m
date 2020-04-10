//
//  MyVideoOrAlbumModel.m
//  BaseProject
//
//  Created by super on 2020/3/24.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "MyVideoOrAlbumModel.h"

@implementation MyVideoOrAlbumModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [MyVideoOrAlbumItemModel class]
             };
}
@end

@implementation MyVideoOrAlbumItemModel

@end
