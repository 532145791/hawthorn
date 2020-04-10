//
//  ProfileCommonEditView.h
//  BaseProject
//
//  Created by super on 2020/3/6.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , EditCommonViewType) {
    EditCommonViewTypeInput = 0 , //输入
    EditCommonViewTypeImage , //图片
    EditCommonViewTypeSelect, //选择
};

@interface ProfileCommonEditView : UIView
@property (nonatomic , assign) EditCommonViewType type;
@property (nonatomic , strong) UITextField *textField;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , assign) BOOL isHiddenLine;
@property (nonatomic , copy) NSString *placeholder;
@property (nonatomic , copy) NSString *userIconUrl;
@property (nonatomic , strong) UIImage *image;
@property (nonatomic , strong) RACSubject *resultSignal;
@property (nonatomic , copy) NSString *province;//省
@property (nonatomic , copy) NSString *city;//市
@property (nonatomic , copy) NSString *area;//区
@end

NS_ASSUME_NONNULL_END
