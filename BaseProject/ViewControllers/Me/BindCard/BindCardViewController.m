//
//  BindCardViewController.m
//  BaseProject
//
//  Created by super on 2020/3/12.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BindCardViewController.h"
#import "BindCardView.h"
@interface BindCardViewController ()
@property (nonatomic , strong) BindCardView *nameView;
@property (nonatomic , strong) BindCardView *IdView;
@property (nonatomic , strong) BindCardView *cardNumView;
@property (nonatomic , strong) BindCardView *phoneView;
@property (nonatomic , strong) UIButton *bindBtn;
@end

@implementation BindCardViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title: @"绑定银行卡",
                     kNav_LeftButton: @(NavBarItemTypeBack)
                    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self listenEvents];
}

-(void)listenEvents{
    [[self.bindBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
}

-(void)initViews{
    [self.view addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.IdView];
    [self.IdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.cardNumView];
    [self.cardNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IdView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.phoneView];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.cardNumView.mas_bottom);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.bindBtn];
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(Adapt_Width(335));
        make.height.mas_equalTo(Adapt_Height(44));
        make.bottom.mas_equalTo(Adapt_Height(-15));
    }];
}

-(BindCardView *)nameView{
    if (!_nameView) {
        _nameView = [BindCardView new];
        _nameView.title = @"姓名";
        _nameView.isHiddenLine = NO;
        _nameView.placeholder = @"请输入姓名";
    }
    return _nameView;
}

-(BindCardView *)IdView{
    if (!_IdView) {
        _IdView = [BindCardView new];
        _IdView.title = @"身份证号码";
        _IdView.isHiddenLine = NO;
        _IdView.placeholder = @"请输入身份证号码";
    }
    return _IdView;
}

-(BindCardView *)cardNumView{
    if (!_cardNumView) {
        _cardNumView = [BindCardView new];
        _cardNumView.title = @"银行卡号";
        _cardNumView.isHiddenLine = NO;
        _cardNumView.placeholder = @"请输入银行卡号";
    }
    return _cardNumView;
}

-(BindCardView *)phoneView{
    if (!_phoneView) {
        _phoneView = [BindCardView new];
        _phoneView.title = @"手机号";
        _phoneView.isHiddenLine = YES;
        _phoneView.placeholder = @"请输入手机号(银行预留)";
    }
    return _phoneView;
}

-(UIButton *)bindBtn{
    if (!_bindBtn) {
        _bindBtn = [UIView getButtonWithFontSize:Font_Medium(17) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_bindBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
        _bindBtn.layer.masksToBounds = YES;
        _bindBtn.layer.cornerRadius = Adapt_Height(22);
    }
    return _bindBtn;
}

@end
