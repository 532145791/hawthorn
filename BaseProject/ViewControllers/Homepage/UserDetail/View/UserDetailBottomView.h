//
//  UserDetailBottomView.h
//  BaseProject
//
//  Created by super on 2020/3/9.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserDetailBottomItemView : UIView
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , assign) BOOL isShowWX;//yes-显示微信号  no-隐藏微信号
@end

@interface UserDetailBottomView : UIView
@property (nonatomic , strong) MyInfoModel *model;
@property (nonatomic , assign) BOOL isShowWX;//yes-显示微信号  no-隐藏微信号
@property (nonatomic , copy) NSString *userWeixin;//用户微信号
@end

NS_ASSUME_NONNULL_END
