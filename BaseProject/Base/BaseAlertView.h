//
//  BaseAlertView.h
//  BaseProject
//
//  Created by super on 2018/11/15.
//  Copyright © 2018 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseAlertView : UIView
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIView *contentView;
-(void)initViews;

/**
 移除点击手势
 */
-(void)removeGesture;

/**
 内容区域在屏幕中间
 */
-(void)showInCenter;

/**
 内容区域在屏幕底部
 */
-(void)showInBottom;

/**
 消失
 */
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
