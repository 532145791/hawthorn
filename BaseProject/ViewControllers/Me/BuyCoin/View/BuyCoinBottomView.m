//
//  BuyCoinBottomView.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BuyCoinBottomView.h"

@interface BuyCoinBottomView ()
@property (nonatomic , strong) BuyCoinBottomTypeView *wxView;
@property (nonatomic , strong) BuyCoinBottomTypeView *zfbView;
@property (nonatomic , strong) BuyCoinBottomPayView *payView;
@end

@implementation BuyCoinBottomView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(@"f7f7f7");
        [self initViews];
        [self listenEvents];
        self.isSelectWX = NO;
    }
    return self;
}

-(void)listenEvents{
    WS(weakSelf)
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [SVProgressHUD showMessageWithStatus:@"暂未开放，请使用支付宝"];
//        weakSelf.isSelectWX = YES;
    }];
    [self.wxView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        weakSelf.isSelectWX = NO;
    }];
    [self.zfbView addGestureRecognizer:tap2];
}

-(void)setMoney:(NSString *)money{
    _money = money;
    self.payView.money = money;
}

-(void)setIsSelectWX:(BOOL)isSelectWX{
    _isSelectWX = isSelectWX;
    if (isSelectWX) {
        self.wxView.layer.borderColor = Color(@"#4CBF00").CGColor;
        self.zfbView.layer.borderColor = Color(@"#dadada").CGColor;
    }else{
        self.wxView.layer.borderColor = Color(@"#dadada").CGColor;
        self.zfbView.layer.borderColor = Color(@"#02A9F1").CGColor;
    }
    [self.selectResultSignal sendNext:@(self.isSelectWX)];
}

-(void)initViews{
    [self addSubview:self.wxView];
    [self.wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(Adapt_Width(346));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self addSubview:self.zfbView];
    [self.zfbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wxView.mas_bottom).offset(Adapt_Height(7));
        make.centerX.equalTo(self);
        make.width.mas_equalTo(Adapt_Width(346));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
//    [self addSubview:self.payView];
//    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(Adapt_Height(-10));
//        make.centerX.equalTo(self);
//        make.width.mas_equalTo(Adapt_Width(343));
//        make.height.mas_equalTo(Adapt_Height(44));
//    }];
}

-(BuyCoinBottomTypeView *)wxView{
    if (!_wxView) {
        _wxView = [BuyCoinBottomTypeView new];
        _wxView.type = BuyCoinBottomTypeViewTypeWX;
    }
    return _wxView;
}

-(BuyCoinBottomTypeView *)zfbView{
    if (!_zfbView) {
        _zfbView = [BuyCoinBottomTypeView new];
        _zfbView.type = BuyCoinBottomTypeViewTypeZFB;
    }
    return _zfbView;
}

-(BuyCoinBottomPayView *)payView{
    if (!_payView) {
        _payView = [BuyCoinBottomPayView new];
    }
    return _payView;
}

-(RACSubject *)selectResultSignal{
    if (!_selectResultSignal) {
        _selectResultSignal = [RACSubject subject];
    }
    return _selectResultSignal;
}

@end

@interface BuyCoinBottomPayView ()
@property (nonatomic , strong) UILabel *totalLab;
@property (nonatomic , strong) UILabel *unitLab;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UIButton *payBtn;
@end

@implementation BuyCoinBottomPayView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_Theme);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = Adapt_Height(22);
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)listenEvents{
    [[self.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTapPayBtn object:nil];
    }];
}

-(void)setMoney:(NSString *)money{
    _money = money;
    self.moneyLab.text = money;
}

-(void)initViews{
    [self addSubview:self.totalLab];
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(Adapt_Width(25)));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.unitLab];
    [self.unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalLab.mas_right).offset(Adapt_Width(4));
        make.bottom.equalTo(self.totalLab);
    }];
    
    [self addSubview:self.moneyLab];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unitLab.mas_right);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-6));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(Adapt_Width(120));
        make.height.mas_equalTo(Adapt_Height(36));
    }];
}

-(UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [UIView getLabelWithFontSize:Font_Medium(14) textColorHex:kColor_White];
        _totalLab.text = @"合计";
    }
    return _totalLab;
}

-(UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [UIView getLabelWithFontSize:Font_Medium(24) textColorHex:kColor_White];
        _moneyLab.text = @"0";
    }
    return _moneyLab;
}

-(UILabel *)unitLab{
    if (!_unitLab) {
        _unitLab = [UIView getLabelWithFontSize:Font_Regular(10) textColorHex:kColor_White];
        _unitLab.text = @"￥";
    }
    return _unitLab;
}

-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIView getButtonWithFontSize:Font_Medium(17) textColorHex:kColor_Theme backGroundColor:kColor_White];
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = Adapt_Height(18);
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    }
    return _payBtn;
}

@end

@interface BuyCoinBottomTypeView ()
@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UILabel *titleLab;
@end

@implementation BuyCoinBottomTypeView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_White);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = Adapt_Height(22);
        self.layer.borderColor = Color(kColor_Theme).CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

-(void)setType:(BuyCoinBottomTypeViewType)type{
    _type = type;
    switch (type) {
        case BuyCoinBottomTypeViewTypeWX:
        {
            [self addSubview:self.icon];
            [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapt_Width(16));
                make.centerY.equalTo(self);
            }];
            
            [self addSubview:self.titleLab];
            [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapt_Width(53));
                make.centerY.equalTo(self);
            }];
            self.titleLab.text = @"微信";
            self.icon.image = [UIImage imageNamed:@"me_wx_icon"];
        }
            break;
        case BuyCoinBottomTypeViewTypeZFB:
        {
            [self addSubview:self.icon];
            [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapt_Width(16));
                make.centerY.equalTo(self);
            }];
            
            [self addSubview:self.titleLab];
            [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapt_Width(53));
                make.centerY.equalTo(self);
            }];
            self.titleLab.text = @"支付宝";
            self.icon.image = [UIImage imageNamed:@"me_zfb_icon"];
        }
            break;
            
        default:
            break;
    }
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:kColor_333333];
    }
    return _titleLab;
}

@end

