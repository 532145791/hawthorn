//
//  UserDetailFreeChanceAlertView.m
//  BaseProject
//
//  Created by super on 2020/3/23.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "UserDetailFreeChanceAlertView.h"

@interface UserDetailFreeChanceAlertView ()
@property (nonatomic , strong) UIImageView *bgImgView;
@property (nonatomic , strong) UILabel *chanceLab;
@property (nonatomic , strong) UILabel *leftLab;
@property (nonatomic , strong) UILabel *rightLab;
@property (nonatomic , strong) UIButton *openBtn;
@property (nonatomic , strong) UIButton *cancelBtn;
@property (nonatomic , strong) UILabel *openHintLab;
@end

@implementation UserDetailFreeChanceAlertView

-(void)initViews{
    [super initViews];
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(301));
        make.height.mas_equalTo(Adapt_Height(313));
    }];
    
    [self.contentView addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(Adapt_Height(23));
    }];
    
    [self.contentView addSubview:self.chanceLab];
    [self.chanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(Adapt_Height(33));
        make.left.mas_equalTo(Adapt_Width(101));
        make.width.mas_equalTo(Adapt_Width(65));
        make.height.mas_equalTo(Adapt_Height(24));
    }];
    
    [self.contentView addSubview:self.leftLab];
    [self.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chanceLab.mas_left).offset(Adapt_Width(-10));
        make.centerY.equalTo(self.chanceLab);
    }];
    
    [self.contentView addSubview:self.rightLab];
    [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chanceLab.mas_right).offset(Adapt_Width(10));
        make.centerY.equalTo(self.chanceLab);
    }];
    
    [self.contentView addSubview:self.openHintLab];
    [self.openHintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(Adapt_Height(16));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.openBtn];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chanceLab.mas_bottom).offset(Adapt_Height(38));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(Adapt_Width(230));
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openBtn.mas_bottom).offset(Adapt_Height(10));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(Adapt_Width(230));
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self removeGesture];
    [self listenEvents];
}

-(void)listenEvents{
    Weakify(self);
    //立即开通会员
    [[self.openBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self dismiss];
        [MGJRouter openURL:kBuyCoinViewController];
    }];
    
    //查看微信号
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self dismiss];
        if (!self.isNoChance) {
            [self.tapCheckSignal sendNext:@(1)];
        }
    }];
}

-(void)setChance:(NSInteger)chance{
    _chance = chance;
    self.chanceLab.text = [NSString stringWithFormat:@"%ld次免费",chance];
}

-(void)setIsNoChance:(BOOL)isNoChance{
    _isNoChance = isNoChance;
    if (isNoChance) {
        self.openHintLab.hidden = NO;
        self.chanceLab.hidden = YES;
        self.leftLab.hidden = YES;
        self.rightLab.hidden = YES;
    }else{
        self.openHintLab.hidden = YES;
        self.chanceLab.hidden = NO;
        self.leftLab.hidden = NO;
        self.rightLab.hidden = NO;
    }
}

-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [UIView getImageViewWithImageName:@"homepage_alert_bgImage"];
    }
    return _bgImgView;
}

-(UILabel *)chanceLab{
    if (!_chanceLab) {
        _chanceLab = [UIView getLabelWithFontSize:Font_Medium(14) textColorHex:kColor_Theme];
        _chanceLab.layer.masksToBounds = YES;
        _chanceLab.layer.cornerRadius = Adapt_Height(12);
        _chanceLab.layer.borderColor = Color(kColor_Theme).CGColor;
        _chanceLab.layer.borderWidth = 0.5;
        _chanceLab.textAlignment = NSTextAlignmentCenter;
    }
    return _chanceLab;
}

-(UILabel *)openHintLab{
    if (!_openHintLab) {
        _openHintLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:kColor_333333];
        _openHintLab.textAlignment = NSTextAlignmentCenter;
        _openHintLab.numberOfLines = 2;
        NSString *message = @"免费查看次数已用完\n开通会员即可查看所有用户的微信";
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:message];
        NSRange range1 = [message rangeOfString:@"开通会员"];
        NSRange range2 = [message rangeOfString:@"即可查看所有用户的微信"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        dic1[NSForegroundColorAttributeName] = Color(kColor_Theme);
        dic1[NSFontAttributeName] = Font_Medium(17);
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        dic2[NSFontAttributeName] = Font_Medium(17);
        [attri addAttributes:dic1 range:range1];
        [attri addAttributes:dic2 range:range2];
        _openHintLab.attributedText = attri;
    }
    return _openHintLab;
}

-(UILabel *)leftLab{
    if (!_leftLab) {
        _leftLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:kColor_333333];
        _leftLab.text = @"您还有";
    }
    return _leftLab;
}

-(UILabel *)rightLab{
    if (!_rightLab) {
        _rightLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:kColor_333333];
        _rightLab.text = @"查看机会哦";
    }
    return _rightLab;
}

-(UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_White backGroundColor:kColor_Theme];
        _openBtn.layer.masksToBounds = YES;
        _openBtn.layer.cornerRadius = Adapt_Height(17);
        [_openBtn setTitle:@"立即开通会员" forState:UIControlStateNormal];
    }
    return _openBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_Theme backGroundColor:kColor_White];
        [_cancelBtn setTitle:@"立即查看" forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

-(RACSubject *)tapCheckSignal{
    if (!_tapCheckSignal) {
        _tapCheckSignal = [RACSubject subject];
    }
    return _tapCheckSignal;
}
@end
