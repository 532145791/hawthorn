//
//  UserDetailBottomView.m
//  BaseProject
//
//  Created by super on 2020/3/9.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "UserDetailBottomView.h"
#import "UserDetailCheckAlertView.h"
@interface UserDetailBottomView ()
@property (nonatomic , strong) UserDetailBottomItemView *wxView;
@property (nonatomic , strong) UserDetailBottomItemView *heightView;
@property (nonatomic , strong) UserDetailBottomItemView *cityView;
@property (nonatomic , strong) UserDetailBottomItemView *hobbyView;
@property (nonatomic , strong) UserDetailBottomItemView *occupationView;
@end

@implementation UserDetailBottomView

-(instancetype)init{
    if (self = [super init]) {
        [self initViews];
    }
    return self;
}

-(void)setIsShowWX:(BOOL)isShowWX{
    _isShowWX = isShowWX;
    self.wxView.isShowWX = isShowWX;
}

-(void)setUserWeixin:(NSString *)userWeixin{
    _userWeixin = userWeixin;
    self.wxView.content = userWeixin;
}

-(void)setModel:(MyInfoModel *)model{
    _model = model;
    self.heightView.content = [NSString stringWithFormat:@"%@CM/%@KG",model.height,model.weight];
    self.hobbyView.content = model.likes;
    self.occupationView.content = model.occupation;
    NSArray *cityArr = [model.city componentsSeparatedByString:@"_"];
    self.cityView.content = [NSString stringWithFormat:@"%@%@%@",cityArr[0],cityArr[1],cityArr[2]];
}

-(void)initViews{
    [self addSubview:self.wxView];
    [self.wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self addSubview:self.heightView];
    [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.wxView.mas_bottom);
        make.height.equalTo(self.wxView);
    }];
    
    [self addSubview:self.cityView];
    [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.heightView.mas_bottom);
        make.height.equalTo(self.wxView);
    }];
    
    [self addSubview:self.hobbyView];
    [self.hobbyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.cityView.mas_bottom);
        make.height.equalTo(self.wxView);
    }];
    
    [self addSubview:self.occupationView];
    [self.occupationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.hobbyView.mas_bottom);
        make.height.equalTo(self.wxView);
    }];
}

-(UserDetailBottomItemView *)wxView{
    if (!_wxView) {
        _wxView = [UserDetailBottomItemView new];
        _wxView.title = @"微信号";
    }
    return _wxView;
}

-(UserDetailBottomItemView *)heightView{
    if (!_heightView) {
        _heightView = [UserDetailBottomItemView new];
        _heightView.title = @"身高/体重";
    }
    return _heightView;
}

-(UserDetailBottomItemView *)hobbyView{
    if (!_hobbyView) {
        _hobbyView = [UserDetailBottomItemView new];
        _hobbyView.title = @"爱好";
    }
    return _hobbyView;
}

-(UserDetailBottomItemView *)occupationView{
    if (!_occupationView) {
        _occupationView = [UserDetailBottomItemView new];
        _occupationView.title = @"职业";
    }
    return _occupationView;
}

-(UserDetailBottomItemView *)cityView{
    if (!_cityView) {
        _cityView = [UserDetailBottomItemView new];
        _cityView.title = @"常驻城市";
    }
    return _cityView;
}

@end

@interface UserDetailBottomItemView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) UIButton *checkBtn;
@end

@implementation UserDetailBottomItemView

-(instancetype)init{
    if (self = [super init]) {
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)listenEvents{
    [[self.checkBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTapCheckWeixin object:nil];
    }];
}

-(void)setIsShowWX:(BOOL)isShowWX{
    _isShowWX = isShowWX;
    if (isShowWX) {
        self.checkBtn.hidden = YES;
        self.contentLab.hidden = NO;
    }else{
        self.checkBtn.hidden = NO;
        self.contentLab.hidden = YES;
    }
}

-(UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIView getButtonWithFontSize:Font_Regular(12) textColorHex:kColor_Theme backGroundColor:kColor_White];
        _checkBtn.layer.masksToBounds = YES;
        _checkBtn.layer.cornerRadius = Adapt_Height(12);
        _checkBtn.layer.borderColor = Color(kColor_Theme).CGColor;
        _checkBtn.layer.borderWidth = 1;
        [_checkBtn setTitle:@"立即查看" forState:UIControlStateNormal];
    }
    return _checkBtn;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
    if ([title isEqualToString:@"微信号"]) {
        [self addSubview:self.checkBtn];
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(Adapt_Width(-20));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(Adapt_Width(72));
            make.height.mas_equalTo(Adapt_Height(24));
        }];
    }
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.contentLab.text = content;
}

-(void)initViews{
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(17));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-20));
        make.centerY.equalTo(self);
    }];
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(14) textColorHex:kColor_333333];
    }
    return _titleLab;
}

-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UIView getLabelWithFontSize:Font_Regular(14) textColorHex:kColor_999999];
        _contentLab.text = @"暂未填写";
    }
    return _contentLab;
}

@end
