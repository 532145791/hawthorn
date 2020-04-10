//
//  BuyCoinHeaderView.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BuyCoinHeaderView.h"

@interface BuyCoinHeaderView ()
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIImageView *cardBgImgView;
@property (nonatomic , strong) UILabel *vipLab;
@property (nonatomic , strong) UILabel *dateLab;
@property (nonatomic , strong) UILabel *privilegeLab;
@property (nonatomic , strong) CAGradientLayer *gradientLayer;
@end

@implementation BuyCoinHeaderView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer addSublayer:self.gradientLayer];
        [self initViews];
    }
    return self;
}

-(void)setMerberDate:(NSString *)merberDate{
    _merberDate = merberDate;
    self.dateLab.text = [NSString stringWithFormat:@"会员到期 %@",merberDate];
}

-(void)initViews{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(Adapt_Height(190));
    }];
    
    [self addSubview:self.cardBgImgView];
    [self.cardBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(Adapt_Height(50));
        make.centerX.equalTo(self);
    }];
    
    [self.cardBgImgView addSubview:self.vipLab];
    [self.vipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(70));
        make.left.mas_equalTo(Adapt_Width(23));
    }];
    
    [self.cardBgImgView addSubview:self.dateLab];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipLab.mas_bottom).offset(Adapt_Height(14));
        make.left.mas_equalTo(Adapt_Width(23));
    }];
    
    [self.cardBgImgView addSubview:self.privilegeLab];
    [self.privilegeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLab.mas_bottom);
        make.left.mas_equalTo(Adapt_Width(23));
    }];
}

-(UIImageView *)cardBgImgView{
    if (!_cardBgImgView) {
        _cardBgImgView = [UIView getImageViewWithImageName:@"me_coin_bgImg"];
    }
    return _cardBgImgView;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(20,20)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
    return _bgView;
}

-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, Adapt_Width(375), Adapt_Height(190));
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        _gradientLayer.colors = @[(__bridge id)Color(@"16253B").CGColor,
                                          (__bridge id)Color(@"2F233B").CGColor];
        _gradientLayer.locations = @[@(0.5f), @(1.0f)];
    }
    return _gradientLayer;
}

-(UILabel *)vipLab{
    if (!_vipLab) {
        _vipLab = [UIView getLabelWithFontSize:Font_Medium(17) textColorHex:kColor_White];
        _vipLab.text = @"VIP";
    }
    return _vipLab;
}

-(UILabel *)dateLab{
    if (!_dateLab) {
        _dateLab = [UIView getLabelWithFontSize:Font_Regular(11) textColorHex:kColor_White];
        _dateLab.text = @"会员到期 未开通";
    }
    return _dateLab;
}

-(UILabel *)privilegeLab{
    if (!_privilegeLab) {
        _privilegeLab = [UIView getLabelWithFontSize:Font_Regular(11) textColorHex:kColor_White];
        _privilegeLab.text = @"会员特权 可以查看所有人的全部个人资料";
    }
    return _privilegeLab;
}

@end
