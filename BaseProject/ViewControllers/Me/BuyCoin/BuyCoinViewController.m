//
//  BuyCoinViewController.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BuyCoinViewController.h"
#import "BuyCoinHeaderView.h"
#import "BuyCoinCountItemView.h"
#import "BuyCoinBottomView.h"
#import "BuyCoinNavigationView.h"
#import "MeViewModel.h"
#import "StoreManager.h"
@interface BuyCoinViewController ()
@property (nonatomic , strong) BuyCoinHeaderView *headerView;
@property (nonatomic , strong) BuyCoinNavigationView *naviView;
@property (nonatomic , strong) UIView *itemsView;
@property (nonatomic , strong) BuyCoinBottomView *bottomView;
@property (nonatomic , strong) BuyCoinBottomTypeView *zfbView;
@property (nonatomic , strong) BuyCoinBottomPayView *payView;
@property (nonatomic , assign) NSInteger selectItem;
@property (nonatomic , strong) MeViewModel *viewModel;
@property (nonatomic , copy) NSString *merberId;//选择的会员id
@property (nonatomic , copy) NSString *productId;//选择的商品id
@property (nonatomic , assign) BOOL isSelectWX;
@property (nonatomic , strong) MemberItemModel *model;
@end

@implementation BuyCoinViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(YES)
                    };
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self listenEvents];
    [self.viewModel getMerberInfo];
    self.isSelectWX = NO;
}

-(void)listenEvents{
    Weakify(self);
    [self.viewModel.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.model = x;
        self.headerView.merberDate = self.model.merberDate;
        if (self.itemsView.subviews.count > 0) {
            for (BuyCoinCountItemView *itemView in self.itemsView.subviews) {
                [itemView removeFromSuperview];
            }
        }
        
        CGFloat totalHeight = 0;
        for (NSInteger i = 0; i < self.viewModel.dataArr.count; i ++) {
            MemberItemDetailModel *model = self.viewModel.dataArr[i];
            BuyCoinCountItemView *itemView = [BuyCoinCountItemView new];
            itemView.tag = i;
            itemView.model = model;
            [self.itemsView addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(totalHeight);
                make.width.mas_equalTo(Adapt_Width(346));
                make.height.mas_equalTo(Adapt_Height(44));
                make.centerX.equalTo(self.itemsView);
            }];
            if (i != 3) {
                totalHeight += Adapt_Height(10);
                totalHeight += Adapt_Height(44);
            }
            
            if (i == 0) {
                itemView.isSelect = YES;
                self.merberId = model.id;
                self.productId = model.mark;
                NSArray *priceArr = [model.value componentsSeparatedByString:@"/"];
                if (priceArr.count == 2) {
                    self.payView.money = [NSString stringWithFormat:@"￥%@",priceArr[0]];
                }else{
                    self.payView.money = [NSString stringWithFormat:@"￥%@",model.value];
                }
            }
            
            WS(weakSelf)
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                [weakSelf switchItemWithTag:itemView.tag];
            }];
            [itemView addGestureRecognizer:tap];
        }
    }];
    
    //选择微信或支付宝
//    [self.bottomView.selectResultSignal subscribeNext:^(id  _Nullable x) {
//        Strongify(self);
//        self.isSelectWX = [x boolValue];
//    }];
    
    //点击支付按钮
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kTapPayBtn object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        NSInteger k = [[UserDefaults getDataWithKey:@"kswitch"] integerValue];
        if (k == 1) {//苹果支付
            [[StoreManager sharedInstance] fetchProductInformationForIds:@[self.productId]];
        }else{
            [self.viewModel submitOrderWithMerberId:self.merberId type:self.isSelectWX?2:1];
        }
    }];
    
    //支付宝成功回调
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPay_ZFB_Result object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        NSDictionary *resultDic = [x.userInfo copy];
        if ([resultDic[@"resultStatus"] integerValue] == 9000) {
            [SVProgressHUD showErrorWithStatus:@"支付成功"];
            [self.viewModel getMerberInfo];
        }else if ([resultDic[@"resultStatus"] integerValue] == 8000){//正在处理中
            [SVProgressHUD showErrorWithStatus:@"正在处理中"];
        }else if ([resultDic[@"resultStatus"] integerValue] == 4000){//订单支付失败
            [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
        }else if ([resultDic[@"resultStatus"] integerValue] == 6001){//用户中途取消
            [SVProgressHUD showErrorWithStatus:@"付款被取消"];
        }else if ([resultDic[@"resultStatus"] integerValue] == 6002){//网络连接出错
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }
    }];
    
    //微信成功回调
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPay_WX_Result object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        NSDictionary *resultDic = [x.userInfo copy];
        if ([resultDic[@"errCode"] integerValue] == 0) {
            [SVProgressHUD showErrorWithStatus:@"支付成功"];
            [self.viewModel getMerberInfo];
        }else if ([resultDic[@"errCode"] integerValue] == -4){//授权失败
            [SVProgressHUD showErrorWithStatus:@"授权失败"];
        }else if ([resultDic[@"errCode"] integerValue] == -1){//订单支付失败
            [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
        }else if ([resultDic[@"errCode"] integerValue] == -2){//用户中途取消
            [SVProgressHUD showErrorWithStatus:@"付款被取消"];
        }else if ([resultDic[@"errCode"] integerValue] == -3){//网络连接出错
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }
    }];
}

-(void)initViews{
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(Adapt_Height(-54));
    }];
    
    [self.view addSubview:self.payView];
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(Adapt_Width(343));
        make.height.mas_equalTo(Adapt_Height(44));
        make.bottom.mas_equalTo(Adapt_Height(-10));
    }];
    
    NSInteger k = [[UserDefaults getDataWithKey:@"kswitch"] integerValue];
    if (k == 2) {
        [self.view addSubview:self.zfbView];
        [self.zfbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(Adapt_Width(343));
            make.height.mas_equalTo(Adapt_Height(44));
            make.bottom.equalTo(self.payView.mas_top).offset(Adapt_Height(-10));
        }];
    }
    
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(KNavigationBar_HEIGHT);
    }];
    
    [self.containerView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(257));
    }];
    
    [self.containerView addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(Adapt_Height(44*4+30));
        make.left.right.bottom.equalTo(self.containerView);
    }];
}

-(void)switchItemWithTag:(NSInteger)tag{
    self.selectItem = tag;
    for (BuyCoinCountItemView *itemView in self.itemsView.subviews) {
        itemView.isSelect = tag == itemView.tag;
    }
    
    MemberItemDetailModel *model = self.viewModel.dataArr[tag];
    self.merberId = model.id;
    self.productId = model.mark;
    NSArray *priceArr = [model.value componentsSeparatedByString:@"/"];
    if (priceArr.count == 2) {
        self.payView.money = [NSString stringWithFormat:@"￥%@",priceArr[0]];
    }else{
        self.payView.money = [NSString stringWithFormat:@"￥%@",model.value];
    }
}

-(BuyCoinHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [BuyCoinHeaderView new];
    }
    return _headerView;
}

-(BuyCoinNavigationView *)naviView{
    if (!_naviView) {
        _naviView = [BuyCoinNavigationView new];
    }
    return _naviView;
}

-(UIView *)itemsView{
    if (!_itemsView) {
        _itemsView = [UIView getViewWithBgColorHex:kColor_White];
    }
    return _itemsView;
}

-(BuyCoinBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [BuyCoinBottomView new];
    }
    return _bottomView;
}

-(MeViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [MeViewModel new];
    }
    return _viewModel;
}

-(BuyCoinBottomPayView *)payView{
    if (!_payView) {
        _payView = [BuyCoinBottomPayView new];
    }
    return _payView;
}

-(BuyCoinBottomTypeView *)zfbView{
    if (!_zfbView) {
        _zfbView = [BuyCoinBottomTypeView new];
        _zfbView.type = BuyCoinBottomTypeViewTypeZFB;
    }
    return _zfbView;
}
@end
