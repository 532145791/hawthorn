//
//  BaseViewController.m
//  BaseProject
//
//  Created by 冷超 on 2017/6/30.
//  Copyright © 2017年 lengchao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = Color(@"f7f7f7");
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initData];
    [self initWithConfDic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL navHidden = [self.confDic[kNav_Hidden] boolValue];
    [self.navigationController setNavigationBarHidden:navHidden animated:NO];
}

/**
 显示无数据界面
 
 @param hintMessage 提示信息
 @param iconName 图片名称，nil：显示默认图
 */
-(void)showNoDataViewWithHintMessage:(NSString *)hintMessage iconName:(NSString *)iconName{
    [self.view addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view bringSubviewToFront:self.noDataView];
    
    self.noDataView.hintMessage = hintMessage;
    if (![CommonTool isNull:iconName]) {
        self.noDataView.iconName = iconName;
    }
}

/**
 移除无数据界面
 */
-(void)removeNoDataView{
    [self.noDataView removeFromSuperview];
}

-(CommonNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [CommonNoDataView new];
    }
    return _noDataView;
}

@end
