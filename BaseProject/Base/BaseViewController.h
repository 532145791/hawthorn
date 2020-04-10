//
//  BaseViewController.h
//  BaseProject
//
//  Created by 冷超 on 2017/6/30.
//  Copyright © 2017年 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonNoDataView.h"
@interface BaseViewController : UIViewController

/**
 *
 *  描述:
 配置属性  需要在初始化时设置 如init方法中设置
 内容:
 confDic : @{
 kNav_Hidden:@(),    //是否隐藏导航条
 kNav_Title:@(),     //导航条title
 kNav_LeftButton:@(),  //导航条左按钮
 kNav_RightButton:@()  //导航条右按钮
 }
 */
@property (nonatomic , strong) NSDictionary *confDic;

/**
 界面之间传值用的
 */
@property (nonatomic , strong) NSDictionary *params;

@property (nonatomic , strong) CommonNoDataView *noDataView;//无数据view

/**
 显示无数据界面

 @param hintMessage 提示信息
 @param iconName 图片名称，nil：显示默认图
 */
-(void)showNoDataViewWithHintMessage:(NSString *)hintMessage iconName:(NSString *)iconName;

/**
 移除无数据界面
 */
-(void)removeNoDataView;
@end
