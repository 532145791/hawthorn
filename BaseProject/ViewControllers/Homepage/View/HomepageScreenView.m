//
//  HomepageScreenView.m
//  BaseProject
//
//  Created by super on 2020/3/4.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "HomepageScreenView.h"
#import <BRAddressPickerView.h>
@interface HomepageScreenView ()
@property (nonatomic , strong) UIButton *cityBtn;
@property (nonatomic , strong) UIImageView *arrowIcon;
@property (nonatomic , strong) UIButton *personBtn;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , assign) BOOL isSelect;//女神或大佬是否选中
@end

@implementation HomepageScreenView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_White);
        [self initViews];
        [self listenEvents];
        self.isSelect = NO;
        
        UserInfoModel *userInfo = [UserInfoManager getUserInfo];
        self.isMale = userInfo.sex==1;
    }
    return self;
}

-(void)listenEvents{
    Weakify(self);
    [[self.personBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        self.isSelect = !self.isSelect;
        [self.selectPersonSignal sendNext:@(self.isSelect)];
    }];
    
    //选择城市
    [[self.cityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self showAddressPicker];
    }];
}

//选择常驻城市
-(void)showAddressPicker{
    BRAddressPickerView *addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeArea];
    addressPicker.title = @"选择常驻城市";
    addressPicker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
//    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    addressPicker.defaultSelectedArr = @[@"上海市",@"上海市",@"浦东新区"];
    addressPicker.isAutoSelect = YES;
    [addressPicker show];
    addressPicker.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        self.province = province.name;
        self.city = city.name;
        self.area = area.name;
        [self.cityBtn setTitle:self.area forState:UIControlStateNormal];
        [self.selectCitySignal sendNext:@(1)];
    };
}

-(void)setIsMale:(BOOL)isMale{
    _isMale = isMale;
    [self.personBtn setTitle:isMale?@"大佬":@"女神" forState:UIControlStateNormal];
    if (self.isSelect) {
        [self.personBtn setBackgroundColor:Color(self.isMale?@"1046FF":kColor_Theme)];
        [self.personBtn setTitleColor:Color(kColor_White) forState:UIControlStateNormal];
    }else{
        [self.personBtn setBackgroundColor:Color(kColor_White)];
        [self.personBtn setTitleColor:Color(self.isMale?@"1046FF":kColor_Theme) forState:UIControlStateNormal];
        self.personBtn.layer.borderWidth = 1;
        self.personBtn.layer.borderColor =Color(self.isMale?@"1046FF":kColor_Theme).CGColor;
    }
    self.isSelect = NO;
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        [self.personBtn setBackgroundColor:Color(self.isMale?@"1046FF":kColor_Theme)];
        [self.personBtn setTitleColor:Color(kColor_White) forState:UIControlStateNormal];
    }else{
        [self.personBtn setBackgroundColor:Color(kColor_White)];
        [self.personBtn setTitleColor:Color(self.isMale?@"1046FF":kColor_Theme) forState:UIControlStateNormal];
        self.personBtn.layer.borderWidth = 1;
        self.personBtn.layer.borderColor =Color(self.isMale?@"1046FF":kColor_Theme).CGColor;
    }
}

-(void)initViews{
    [self addSubview:self.cityBtn];
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(16));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityBtn.mas_right).offset(Adapt_Width(1));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.personBtn];
    [self.personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-15));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(Adapt_Width(64));
        make.height.mas_equalTo(Adapt_Height(24));
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

-(UIButton *)cityBtn{
    if (!_cityBtn) {
        _cityBtn = [UIView getButtonWithFontSize:Font_Regular(13) textColorHex:kColor_333333 backGroundColor:kColor_White];
    }
    return _cityBtn;
}

-(UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [UIView getImageViewWithImageName:@"homepage_arrow_down"];
    }
    return _arrowIcon;
}

-(UIButton *)personBtn{
    if (!_personBtn) {
        _personBtn = [UIView getButtonWithFontSize:Font_Medium(13) textColorHex:kColor_White backGroundColor:kColor_Theme];
        _personBtn.layer.masksToBounds = YES;
        _personBtn.layer.cornerRadius = Adapt_Height(12);
    }
    return _personBtn;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView getViewWithBgColorHex:@"d8d8d8"];
    }
    return _line;
}

-(RACSubject *)selectPersonSignal{
    if (!_selectPersonSignal) {
        _selectPersonSignal = [RACSubject subject];
    }
    return _selectPersonSignal;
}

-(RACSubject *)selectCitySignal{
    if (!_selectCitySignal) {
        _selectCitySignal = [RACSubject subject];
    }
    return _selectCitySignal;
}
@end
