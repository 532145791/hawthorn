//
//  MeHeaderView.m
//  BaseProject
//
//  Created by super on 2019/10/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "MeHeaderView.h"
#import "MeViewModel.h"
#import "HomepageTableViewCell.h"
@interface MeHeaderView ()
@property (nonatomic , strong) UIImageView *userIcon;
@property (nonatomic , strong) UILabel *userNameLab;
//@property (nonatomic , strong) HomepageAgeView *ageView;
@property (nonatomic , strong) UIButton *profileBtn;
@property (nonatomic , strong) UIImageView *arrowIcon;
@end

@implementation MeHeaderView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_White);
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)listenEvents{
    [[self.profileBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [MGJRouter openURL:kProfileViewController withUserInfo:@{@"isFinishProfile":@(YES)} completion:nil];
    }];
}

-(void)setModel:(MyInfoModel *)model{
    _model = model;
    [self.userIcon setImageWithURL:[NSURL URLWithString:model.headPath] placeholder:[UIImage imageNamed:@"user_default_icon"]];
    if (![CommonTool isNull:model.nickname]) {
        self.userNameLab.text = model.nickname;
    }
}

-(void)initViews{
    [self addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(18));
        make.left.mas_equalTo(Adapt_Width(23));
        make.width.height.mas_equalTo(Adapt_Width(80));
    }];
    
    [self addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Adapt_Width(16));
        make.top.equalTo(self.userIcon);
    }];
    
    [self addSubview:self.profileBtn];
    [self.profileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLab);
        make.bottom.equalTo(self.userIcon);
    }];
    
    [self addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.profileBtn.mas_right).offset(Adapt_Width(4));
        make.centerY.equalTo(self.profileBtn);
    }];
}

-(UIImageView *)userIcon{
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userIcon;
}

-(UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [UIView getLabelWithFontSize:Font_Medium(20) textColorHex:kColor_333333];
        _userNameLab.text = @"昵称";
    }
    return _userNameLab;
}

-(UIButton *)profileBtn{
    if (!_profileBtn) {
        _profileBtn = [UIView getButtonWithFontSize:Font_Medium(12) textColorHex:kColor_333333 backGroundColor:nil];
        [_profileBtn setTitle:@"个人资料" forState:UIControlStateNormal];
    }
    return _profileBtn;
}

-(UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [UIView getImageViewWithImageName:@"light-arrow"];
    }
    return _arrowIcon;
}
@end
