//
//  MyVideoOrAlbumModel.h
//  BaseProject
//
//  Created by super on 2020/3/24.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVideoOrAlbumItemModel : BaseModel
@property (nonatomic , copy) NSString *path;
@property (nonatomic , copy) NSString *id;
@end

@interface MyVideoOrAlbumModel : BaseModel
@property (nonatomic , strong) NSArray <MyVideoOrAlbumItemModel *> *list;
@end

NS_ASSUME_NONNULL_END
