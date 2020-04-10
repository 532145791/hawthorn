//
//  UserDetailHeaderView.m
//  BaseProject
//
//  Created by super on 2020/3/9.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "UserDetailHeaderView.h"
#import "HomepageTableViewCell.h"
#import "UserDetailBottomView.h"
#import "VideoListCollectionViewCell.h"
#import "PreviewBigImageTool.h"
@interface UserDetailHeaderView ()
@property (nonatomic , strong) UIImageView *userIconView;
@property (nonatomic , strong) UILabel *userNameLab;
@property (nonatomic , strong) VideoListAgeView *ageView;
@property (nonatomic , strong) UIView *whiteBgView;
@property (nonatomic , strong) UserDetailBottomView *infoView;
@property (nonatomic , strong) UILabel *hintLab;

@end

@implementation UserDetailHeaderView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(@"ffffff");
        [self initViews];
    }
    return self;
}

-(void)setModel:(MyInfoModel *)model{
    _model = model;
    [self.userIconView setImageWithURL:[NSURL URLWithString:model.headPath] placeholder:[UIImage imageNamed:@"user_default_icon"]];
    self.userNameLab.text = model.nickname;
    self.ageView.isMale = model.gender==1;
    self.ageView.age = model.age;
    self.infoView.model = model;
}

-(void)setIsShowWX:(BOOL)isShowWX{
    _isShowWX = isShowWX;
    self.infoView.isShowWX = isShowWX;
}

-(void)setUserWeixin:(NSString *)userWeixin{
    _userWeixin = userWeixin;
    self.infoView.userWeixin = userWeixin;
}

-(void)initViews{
    [self addSubview:self.whiteBgView];
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(35));
        make.height.mas_equalTo(Adapt_Height(218));
        make.width.mas_equalTo(Adapt_Width(343));
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.userIconView];
    [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(Adapt_Width(57));
        make.left.mas_equalTo(Adapt_Width(34));
    }];
    
    [self addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIconView);
        make.left.equalTo(self.userIconView.mas_right).offset(Adapt_Width(7));
    }];
    
    [self addSubview:self.ageView];
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userNameLab);
        make.left.equalTo(self.userNameLab.mas_right).offset(Adapt_Width(9));
        make.width.mas_equalTo(Adapt_Width(36));
        make.height.mas_equalTo(Adapt_Height(16));
    }];
    
    [self.whiteBgView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(22));
        make.height.mas_equalTo(Adapt_Height(34*5));
        make.width.centerX.equalTo(self.whiteBgView);
    }];
    
    [self.whiteBgView addSubview:self.hintLab];
    [self.hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.whiteBgView);
        make.top.equalTo(self.infoView.mas_bottom);
        make.height.mas_equalTo(Adapt_Height(28));
    }];
    
    WS(weakSelf)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:weakSelf.model.headPath];
        [PreviewBigImageTool showWithImageUrlArr:arr inView:[UIApplication sharedApplication].keyWindow selectIndex:0];
    }];
    [self.userIconView addGestureRecognizer:tap];
}

-(UIImageView *)userIconView{
    if (!_userIconView) {
        _userIconView = [UIImageView new];
        _userIconView.layer.masksToBounds = YES;
        _userIconView.contentMode = UIViewContentModeScaleAspectFill;
        _userIconView.userInteractionEnabled = YES;
    }
    return _userIconView;
}

-(UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [UIView getLabelWithFontSize:Font_Medium(17) textColorHex:kColor_333333];
    }
    return _userNameLab;
}

-(VideoListAgeView *)ageView{
    if (!_ageView) {
        _ageView = [VideoListAgeView new];
    }
    return _ageView;
}

-(UIView *)whiteBgView{
    if (!_whiteBgView) {
        _whiteBgView = [UIView getViewWithBgColorHex:kColor_White];
//        _whiteBgView.layer.masksToBounds = YES;
        _whiteBgView.layer.cornerRadius = 6;
        // 阴影颜色
        _whiteBgView.layer.shadowColor = Color_alpha(@"000000", 0.2).CGColor;
        // 阴影偏移，默认(0, -3)
        _whiteBgView.layer.shadowOffset = CGSizeMake(0,3);
        // 阴影透明度，默认0
        _whiteBgView.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        _whiteBgView.layer.shadowRadius = 5;
    }
    return _whiteBgView;
}

-(UILabel *)hintLab{
    if (!_hintLab) {
        _hintLab = [UIView getLabelWithFontSize:Font_Regular(11) textColorHex:@"#C4AE60"];
        _hintLab.backgroundColor = Color(@"#FFF8E0");
        _hintLab.textAlignment = NSTextAlignmentCenter;
        _hintLab.text = @"请勿通过平台进行不法交易，如被举报核实将做封号处理";
    }
    return _hintLab;
}

-(UserDetailBottomView *)infoView{
    if (!_infoView) {
        _infoView = [UserDetailBottomView new];
    }
    return _infoView;
}
@end
