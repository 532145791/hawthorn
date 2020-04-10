//
//  VideoListModel.h
//  BaseProject
//
//  Created by super on 2020/3/18.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseModel.h"
#import "CommonPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoItemModel : BaseModel
@property (nonatomic , copy) NSString *id;//用户唯一标识
@property (nonatomic , copy) NSString *headPath;//头像地址
@property (nonatomic , copy) NSString *nickname;//昵称
@property (nonatomic , assign) int gender;//用户性别（默认为0）：0-无；1-男；2-女
@property (nonatomic , copy) NSString *city;//常驻城市
@property (nonatomic , copy) NSString *age;
@property (nonatomic , copy) NSString *likes;//爱好
@property (nonatomic , copy) NSString *occupation;//职业
@property (nonatomic , copy) NSString *createTime;//发布时间
@property (nonatomic , copy) NSString *path;//路径
@end



@interface VideoListModel : BaseModel
@property (nonatomic , strong) NSArray <VideoItemModel *> *list;
@property (nonatomic , strong) CommonPageModel *pagination;
@end

NS_ASSUME_NONNULL_END
