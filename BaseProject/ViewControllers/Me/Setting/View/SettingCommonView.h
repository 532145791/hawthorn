//
//  SettingCommonView.h
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , SettingCommonViewType) {
    SettingCommonViewTypeLogo = 0 , //logo
    SettingCommonViewTypeJump , //可跳转
    SettingCommonViewTypeContent, //显示内容
};

@interface SettingCommonView : UIView
@property (nonatomic , assign) SettingCommonViewType type;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
