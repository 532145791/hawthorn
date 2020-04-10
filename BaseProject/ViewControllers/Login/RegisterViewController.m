//
//  RegisterViewController.m
//  BaseProject
//
//  Created by super on 2020/4/2.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewModel.h"
#import "LoginHintAlertView.h"
@interface RegisterViewController ()
@property (nonatomic , strong) UITextField *phoneTF;
@property (nonatomic , strong) UIButton *codeBtn;
@property (nonatomic , strong) UIView *line1;
@property (nonatomic , strong) UITextField *codeTF;
@property (nonatomic , strong) UIView *line2;
@property (nonatomic , strong) UITextField *inviteCodeTF;
@property (nonatomic , strong) UIView *line3;
@property (nonatomic , strong) UIButton *registerBtn;
@property (nonatomic , strong) LoginViewModel *loginViewModel;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger second;
@property (nonatomic , strong) LoginHintAlertView *hintAlertView;
@end

@implementation RegisterViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title:@"注册",
                     kNav_LeftButton:@(NavBarItemTypeBack)
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
    
    //点击注册
    [[self.registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        int firstLogin = [[UserDefaults getDataWithKey:@"FirstLogin"] intValue];
        if (firstLogin != 2) {
            [self.hintAlertView showInCenter];
        }else{
            [self.loginViewModel registerWithPhone:self.phoneTF.text code:self.codeTF.text inviteCode:self.inviteCodeTF.text];
        }
    }];
    
    //同意协议了
    [self.hintAlertView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        [self.loginViewModel registerWithPhone:self.phoneTF.text code:self.codeTF.text inviteCode:self.inviteCodeTF.text];
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
    [self.view addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(20));
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
    
    [self.view addSubview:self.inviteCodeTF];
    [self.inviteCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(Adapt_Height(21));
        make.left.mas_equalTo(Adapt_Width(38));
        make.width.mas_equalTo(Adapt_Width(250));
        make.height.mas_equalTo(Adapt_Height(24));
    }];
    
    [self.view addSubview:self.line3];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inviteCodeTF.mas_bottom).offset(Adapt_Height(10));
        make.left.mas_equalTo(Adapt_Width(38));
        make.right.mas_equalTo(Adapt_Width(-26));
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3.mas_bottom).offset(Adapt_Height(51));
        make.left.mas_equalTo(Adapt_Width(26));
        make.right.mas_equalTo(Adapt_Width(-26));
        make.height.mas_equalTo(44);
    }];
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

-(UIView *)line3{
    if (!_line3) {
        _line3 = [UIView getViewWithBgColorHex:kColor_eeeeee];
    }
    return _line3;
}

-(UITextField *)codeTF{
    if (!_codeTF) {
        _codeTF = [UIView getTextFieldWithFontSize:Font_Medium(17) textColorHex:kColor_333333 placeHolder:@"验证码"];
        _codeTF.textAlignment = NSTextAlignmentLeft;
        _codeTF.keyboardType = UIKeyboardTypePhonePad;
    }
    return _codeTF;
}

-(UITextField *)inviteCodeTF{
    if (!_inviteCodeTF) {
        _inviteCodeTF = [UIView getTextFieldWithFontSize:Font_Medium(17) textColorHex:kColor_333333 placeHolder:@"邀请码(必填)"];
        _inviteCodeTF.textAlignment = NSTextAlignmentLeft;
        _inviteCodeTF.keyboardType = UIKeyboardTypePhonePad;
    }
    return _inviteCodeTF;
}

-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIView getButtonWithFontSize:Font_Medium(20) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 22;
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
