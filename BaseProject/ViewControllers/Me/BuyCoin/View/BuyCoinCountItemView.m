//
//  BuyCoinCountItemView.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BuyCoinCountItemView.h"

@interface BuyCoinCountItemView ()
@property (nonatomic , strong) UILabel *countLab;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UILabel *descLab;
@end

@implementation BuyCoinCountItemView

-(instancetype)init{
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = Adapt_Height(22);
        self.layer.borderColor = Color(@"F0F0F0").CGColor;
        self.layer.borderWidth = 1;
        [self initViews];
    }
    return self;
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.layer.borderColor = isSelect?Color(kColor_Theme).CGColor:Color(@"F0F0F0").CGColor;
}

-(void)setModel:(MemberItemDetailModel *)model{
    _model = model;
    self.countLab.text = model.name;
    NSArray *priceArr = [model.value componentsSeparatedByString:@"/"];
    if (priceArr.count == 2) {
        self.moneyLab.text = [NSString stringWithFormat:@"￥%@",priceArr[0]];
        self.descLab.text = [NSString stringWithFormat:@"限时折扣！原价￥%@",priceArr[1]];
    }else{
        self.moneyLab.text = [NSString stringWithFormat:@"￥%@",model.value];
    }
}

-(void)initViews{
    [self addSubview:self.countLab];
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(Adapt_Width(29));
    }];
    
    [self addSubview:self.descLab];
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self addSubview:self.moneyLab];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(Adapt_Width(-16));
        make.width.mas_equalTo(Adapt_Width(80));
        make.height.mas_equalTo(Adapt_Height(30));
    }];
}

-(UILabel *)countLab{
    if (!_countLab) {
        _countLab = [UIView getLabelWithFontSize:Font_Semibold(17) textColorHex:kColor_333333];
    }
    return _countLab;
}

-(UILabel *)descLab{
    if (!_descLab) {
        _descLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:kColor_666666];
    }
    return _descLab;
}

-(UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [UIView getLabelWithFontSize:Font_Medium(15) textColorHex:kColor_White];
        _moneyLab.backgroundColor = Color(kColor_Theme);
        _moneyLab.layer.masksToBounds = YES;
        _moneyLab.layer.cornerRadius = Adapt_Height(15);
        _moneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLab;
}

@end
