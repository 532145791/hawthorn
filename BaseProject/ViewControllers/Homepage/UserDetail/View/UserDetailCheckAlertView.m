//
//  UserDetailCheckAlertView.m
//  BaseProject
//
//  Created by super on 2020/3/9.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "UserDetailCheckAlertView.h"

@interface UserDetailCheckAlertView ()
@property (nonatomic , strong) UIImageView *bgImgView;
@property (nonatomic , strong) UILabel *accountCountLab;//0金币
@property (nonatomic , strong) UILabel *countLab;//10金币
@property (nonatomic , strong) UILabel *bottomHintLab;//支付成功后 永久显示
@property (nonatomic , strong) UIButton *payBtn;//立即支付
@property (nonatomic , strong) UIButton *rechargeBtn;//立即充值
@property (nonatomic , strong) UIButton *cancelBtn;
@end

@implementation UserDetailCheckAlertView

-(void)initViews{
    [super initViews];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(301));
        make.height.mas_equalTo(Adapt_Height(331));
    }];
    
    [self.contentView addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.accountCountLab];
    [self.accountCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.mas_equalTo(Adapt_Height(99));
    }];
    
    [self.contentView addSubview:self.countLab];
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountCountLab.mas_bottom).offset(Adapt_Height(33));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.bottomHintLab];
    [self.bottomHintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.countLab.mas_bottom).offset(Adapt_Height(7));
    }];
    
    [self.contentView addSubview:self.rechargeBtn];
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(30));
        make.top.equalTo(self.bottomHintLab.mas_bottom).offset(Adapt_Height(28));
        make.width.mas_equalTo(Adapt_Width(116));
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self.contentView addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-30));
        make.width.height.centerY.equalTo(self.rechargeBtn);
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(Adapt_Height(-20));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self removeGesture];
    [self listenEvents];
}

-(void)listenEvents{
    Weakify(self);
    //立即充值
    [[self.rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self dismiss];
        [MGJRouter openURL:kBuyCoinViewController];
    }];
    
    //立即支付
    [[self.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    //取消
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self dismiss];
    }];
}

-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [UIView getImageViewWithImageName:@"homepage_alert_bgImage"];
    }
    return _bgImgView;
}

-(UILabel *)accountCountLab{
    if (!_accountCountLab) {
        _accountCountLab = [UIView getLabelWithFontSize:Font_Medium(15) textColorHex:kColor_333333];
        UserInfoModel *userInfo = [UserInfoManager getUserInfo];
        NSString *countStr = [NSString stringWithFormat:@"%d金币",userInfo.coinCount];
        NSString *str = [NSString stringWithFormat:@"当前账户 %@",countStr];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:countStr];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = Color(kColor_Theme);
        [attri addAttributes:dic range:range1];
        _accountCountLab.attributedText = attri;
    }
    return _accountCountLab;
}

-(UILabel *)bottomHintLab{
    if (!_bottomHintLab) {
        _bottomHintLab = [UIView getLabelWithFontSize:Font_Regular(15) textColorHex:kColor_999999];
        _bottomHintLab.text = @"支付成功后 永久显示";
    }
    return _bottomHintLab;
}

-(UILabel *)countLab{
    if (!_countLab) {
        _countLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:@"000000"];
        NSString *str1 = @"10金币";
        NSString *str2 = @"需要支付";
        NSString *str = [NSString stringWithFormat:@"获取TA的微信号 %@%@",str2,str1];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:str1];
        NSRange range2 = [str rangeOfString:str2];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        dic1[NSForegroundColorAttributeName] = Color(kColor_Theme);
        dic1[NSFontAttributeName] = Font_Medium(17);
        [attri addAttributes:dic1 range:range1];
        
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        dic2[NSForegroundColorAttributeName] = Color(@"000000");
        dic2[NSFontAttributeName] = Font_Medium(17);
        [attri addAttributes:dic2 range:range2];
        
        _countLab.attributedText = attri;
    }
    return _countLab;
}

-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = Adapt_Height(17);
    }
    return _payBtn;
}

-(UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        _rechargeBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_Theme backGroundColor:kColor_White];
        [_rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        _rechargeBtn.layer.masksToBounds = YES;
        _rechargeBtn.layer.cornerRadius = Adapt_Height(17);
        _rechargeBtn.layer.borderColor = Color(kColor_Theme).CGColor;
        _rechargeBtn.layer.borderWidth = 1;
    }
    return _rechargeBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_333333 backGroundColor:kColor_White];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

@end
