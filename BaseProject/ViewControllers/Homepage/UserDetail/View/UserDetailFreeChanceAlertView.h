//
//  UserDetailFreeChanceAlertView.h
//  BaseProject
//
//  Created by super on 2020/3/23.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailFreeChanceAlertView : BaseAlertView
@property (nonatomic , strong) RACSubject *tapCheckSignal;
@property (nonatomic , assign) BOOL isNoChance;//yes-没有免费次数了 no-还有免费次数
@property (nonatomic , assign) NSInteger chance;//免费次数
@end

NS_ASSUME_NONNULL_END
