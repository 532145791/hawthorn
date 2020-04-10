//
//  LoginViewController.m
//  BaseProject
//
//  Created by super on 2019/10/9.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "LoginHintAlertView.h"
@interface LoginViewController ()
@property (nonatomic , strong) UIImageView *logo;
@property (nonatomic , strong) UILabel *hintLab;
@property (nonatomic , strong) UITextField *phoneTF;
@property (nonatomic , strong) UIButton *codeBtn;
@property (nonatomic , strong) UIView *line1;
@property (nonatomic , strong) UITextField *codeTF;
@property (nonatomic , strong) UIView *line2;
@property (nonatomic , strong) UIButton *loginBtn;
@property (nonatomic , strong) UIButton *registerBtn;
@property (nonatomic , strong) LoginViewModel *loginViewModel;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger second;
@property (nonatomic , strong) LoginHintAlertView *hintAlertView;
@end

@implementation LoginViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(YES)
                     };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color(kColor_White);
    self.second = 60;
    [self initViews];
    [self listenEvents];
}

-(void)listenEvents{
    Weakify(self);
    
    //获取验证码
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self.loginViewModel getVeriCodeWithPhone:self.phoneTF.text];
    }];
    
    //获取验证码成功
    [self.loginViewModel.getVeriCodeResultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        [self.timer setFireDate:[NSDate distantPast]];
    }];
    
    //登录
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self.loginViewModel loginWithPhone:self.phoneTF.text code:self.codeTF.text];
    }];
    
    //注册
    [[self.registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [MGJRouter openURL:kRegisterViewController];
    }];
}

-(void)beginCountDown{
    self.second --;
    if (self.second == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.enabled = YES;
        self.second = 60;
        return;
    }
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.second] forState:UIControlStateNormal];
    self.codeBtn.enabled = NO;
}

-(void)initViews{
    [self.view addSubview:self.logo];
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(58));
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(Adapt_Width(120));
    }];
    
    [self.view addSubview:self.hintLab];
    [self.hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logo.mas_bottom).offset(Adapt_Height(10));
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintLab.mas_bottom).offset(Adapt_Height(55));
        make.left.mas_equalTo(Adapt_Width(38));
        make.width.mas_equalTo(Adapt_Width(170));
        make.height.mas_equalTo(Adapt_Height(24));
    }];
    
    [self.view addSubview:self.codeBtn];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneTF);
        make.right.mas_equalTo(Adapt_Width(-38));
    }];
    
    [self.view addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).offset(Adapt_Height(10));
        make.left.mas_equalTo(Adapt_Width(38));
        make.right.mas_equalTo(Adapt_Width(-26));
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.codeTF];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(Adapt_Height(21));
        make.left.mas_equalTo(Adapt_Width(38));
        make.width.mas_equalTo(Adapt_Width(250));
        make.height.mas_equalTo(Adapt_Height(24));
    }];
    
    [self.view addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom).offset(Adapt_Height(10));
        make.left.mas_equalTo(Adapt_Width(38));
        make.right.mas_equalTo(Adapt_Width(-26));
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(Adapt_Height(51));
        make.left.mas_equalTo(Adapt_Width(26));
        make.right.mas_equalTo(Adapt_Width(-26));
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(Adapt_Height(10));
        make.left.mas_equalTo(Adapt_Width(26));
        make.right.mas_equalTo(Adapt_Width(-26));
        make.height.mas_equalTo(44);
    }];
}

-(UIImageView *)logo{
    if (!_logo) {
        _logo = [UIView getImageViewWithImageName:@"login_logo"];
    }
    return _logo;
}

-(UILabel *)hintLab{
    if (!_hintLab) {
        _hintLab = [UIView getLabelWithFontSize:Font_Medium(17) textColorHex:kColor_Theme];
        _hintLab.text = @"山楂";
    }
    return _hintLab;
}

-(UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [UIView getTextFieldWithFontSize:Font_Medium(17) textColorHex:kColor_333333 placeHolder:@"手机号"];
        _phoneTF.textAlignment = NSTextAlignmentLeft;
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneTF;
}

-(UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [UIView getButtonWithFontSize:Font_Medium(12) textColorHex:kColor_Theme backGroundColor:nil];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _codeBtn;
}

-(UIView *)line1{
    if (!_line1) {
        _line1 = [UIView getViewWithBgColorHex:kColor_eeeeee];
    }
    return _line1;
}

-(UIView *)line2{
    if (!_line2) {
        _line2 = [UIView getViewWithBgColorHex:kColor_eeeeee];
    }
    return _line2;
}

-(UITextField *)codeTF{
    if (!_codeTF) {
        _codeTF = [UIView getTextFieldWithFontSize:Font_Medium(17) textColorHex:kColor_333333 placeHolder:@"验证码"];
        _codeTF.textAlignment = NSTextAlignmentLeft;
        _codeTF.keyboardType = UIKeyboardTypePhonePad;
    }
    return _codeTF;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIView getButtonWithFontSize:Font_Medium(20) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 22;
    }
    return _loginBtn;
}

-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIView getButtonWithFontSize:Font_Medium(20) textColorHex:kColor_Theme backGroundColor:kColor_White];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 22;
        _registerBtn.layer.borderColor = Color(kColor_Theme).CGColor;
        _registerBtn.layer.borderWidth = 1;
    }
    return _registerBtn;
}

-(LoginViewModel *)loginViewModel{
    if (!_loginViewModel) {
        _loginViewModel = [LoginViewModel new];
    }
    return _loginViewModel;
}

-(NSTimer *)timer{
    if (!_timer) {
        WS(weakSelf);
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            [weakSelf beginCountDown];
        } repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

-(LoginHintAlertView *)hintAlertView{
    if (!_hintAlertView) {
        _hintAlertView = [LoginHintAlertView new];
    }
    return _hintAlertView;
}
@end
