//
//  UserDetailNavigationView.m
//  BaseProject
//
//  Created by super on 2020/3/9.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "UserDetailNavigationView.h"

@interface UserDetailNavigationView ()
@property (nonatomic , strong) UIButton *backBtn;
@property (nonatomic , strong) UIButton *complaintBtn;
@end

@implementation UserDetailNavigationView

-(instancetype)init{
    if (self = [super init]) {
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)setIsShowWhiteIcon:(BOOL)isShowWhiteIcon{
    _isShowWhiteIcon = isShowWhiteIcon;
    [self.backBtn setImage:[UIImage imageNamed:isShowWhiteIcon?@"nav-white-back":@"nav-black-back"] forState:UIControlStateNormal];
    [self.complaintBtn setTitleColor:isShowWhiteIcon?Color(kColor_White):Color(kColor_333333) forState:UIControlStateNormal];
}

-(void)listenEvents{
    Weakify(self);
    //返回
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[CommonTool currentViewController].navigationController popViewControllerAnimated:YES];
    }];
    
    //投诉
    [[self.complaintBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [MGJRouter openURL:kReportViewController withUserInfo:@{@"id":self.userId} completion:nil];
    }];
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
}

-(void)initViews{
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(44);
    }];
    
    [self addSubview:self.complaintBtn];
    [self.complaintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(44);
    }];
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn  setImage:[UIImage imageNamed:@"nav-black-back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UIButton *)complaintBtn{
    if (!_complaintBtn) {
        _complaintBtn = [UIView getButtonWithFontSize:Font_Regular(14) textColorHex:kColor_White backGroundColor:nil];
        [_complaintBtn setTitle:@"举报" forState:UIControlStateNormal];
    }
    return _complaintBtn;
}

-(RACSubject *)reportSignal{
    if (!_reportSignal) {
        _reportSignal = [RACSubject subject];
    }
    return _reportSignal;
}

@end
