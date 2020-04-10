//
//  SettingViewController.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCommonView.h"
#import "MeViewModel.h"
#import <YYCache.h>
@interface SettingViewController ()
@property (nonatomic , strong) SettingCommonView *logoView;
@property (nonatomic , strong) SettingCommonView *userProtocolView;
@property (nonatomic , strong) SettingCommonView *privacyPolicyView;
@property (nonatomic , strong) SettingCommonView *versionView;
@property (nonatomic , strong) SettingCommonView *contactView;
@property (nonatomic , strong) UIButton *logoutBtn;
@property (nonatomic , strong) UIButton *cancellationBtn;
@end

@implementation SettingViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title: @"设置",
                     kNav_LeftButton: @(NavBarItemTypeBack)
                    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self listenEvents];
}

-(void)listenEvents{
    //退出登录
    [[self.logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"立即退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserDefaults removeWithKey:@"Token"];
            [UserInfoManager deleteUserInfo];
            BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
            [AppDelegate sharedAppDelegate].window.rootViewController = nv;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:cameraAction];
        [alert addAction:cancelAction];
        
        [[CommonTool currentViewController] presentViewController:alert animated:YES completion:nil];
    }];
    
    //注销账户
    [[self.cancellationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注销账户会删除您所有的信息，请慎重" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"立即注销" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[MeViewModel new] logout];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:cameraAction];
        [alert addAction:cancelAction];
        
        [[CommonTool currentViewController] presentViewController:alert animated:YES completion:nil];
    }];
}

-(void)initViews{
    [self.view addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(Adapt_Height(94));
    }];
    
    [self.view addSubview:self.userProtocolView];
    [self.userProtocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.logoView.mas_bottom).offset(Adapt_Height(10));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.privacyPolicyView];
    [self.privacyPolicyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.userProtocolView.mas_bottom).offset(Adapt_Height(10));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.versionView];
    [self.versionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.privacyPolicyView.mas_bottom).offset(Adapt_Height(10));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.contactView];
    [self.contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.versionView.mas_bottom).offset(Adapt_Height(10));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.contactView.mas_bottom).offset(Adapt_Height(17));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.view addSubview:self.cancellationBtn];
    [self.cancellationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.logoutBtn.mas_bottom).offset(Adapt_Height(10));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
}

- (SettingCommonView *)logoView{
    if (!_logoView) {
        _logoView = [SettingCommonView new];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _logoView.title = [infoDictionary objectForKey:@"CFBundleName"];
        _logoView.type = SettingCommonViewTypeLogo;
    }
    return _logoView;
}

- (SettingCommonView *)userProtocolView{
    if (!_userProtocolView) {
        _userProtocolView = [SettingCommonView new];
        _userProtocolView.title = @"用户协议";
        _userProtocolView.type = SettingCommonViewTypeJump;
    }
    return _userProtocolView;
}

- (SettingCommonView *)privacyPolicyView{
    if (!_privacyPolicyView) {
        _privacyPolicyView = [SettingCommonView new];
        _privacyPolicyView.title = @"隐私政策";
        _privacyPolicyView.type = SettingCommonViewTypeJump;
    }
    return _privacyPolicyView;
}

- (SettingCommonView *)versionView{
    if (!_versionView) {
        _versionView = [SettingCommonView new];
        _versionView.title = @"版本号";
        _versionView.type = SettingCommonViewTypeContent;
        _versionView.content = [CommonTool appVersion];
    }
    return _versionView;
}

- (SettingCommonView *)contactView{
    if (!_contactView) {
        _contactView = [SettingCommonView new];
        _contactView.title = @"联系我们";
        _contactView.type = SettingCommonViewTypeContent;
        _contactView.content = [NSString stringWithFormat:@"官方QQ:%@",kCustomerServiceQQ];
    }
    return _contactView;
}

-(UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [UIView getButtonWithFontSize:Font_Medium(15) textColorHex:kColor_333333 backGroundColor:kColor_White];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    return _logoutBtn;
}

-(UIButton *)cancellationBtn{
    if (!_cancellationBtn) {
        _cancellationBtn = [UIView getButtonWithFontSize:Font_Medium(15) textColorHex:kColor_333333 backGroundColor:kColor_White];
        [_cancellationBtn setTitle:@"账户注销" forState:UIControlStateNormal];
    }
    return _cancellationBtn;
}

@end
