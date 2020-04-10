//
//  HomepageNavigationView.m
//  BaseProject
//
//  Created by super on 2020/3/4.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "HomepageNavigationView.h"
#import "HomepageSexSwitchView.h"
#import <BRAddressPickerView.h>
@interface HomepageNavigationView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) HomepageSexSwitchView *sexSwitchView;
@property (nonatomic , strong) UIButton *cityBtn;
@property (nonatomic , strong) UIImageView *arrowIcon;
@end

@implementation HomepageNavigationView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_White);
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(KNavigationBar_HEIGHT-44);
    }];
    
    [self addSubview:self.cityBtn];
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(16));
        make.centerY.equalTo(self.titleLab);
    }];
    
    [self addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityBtn.mas_right).offset(Adapt_Width(1));
        make.centerY.equalTo(self.titleLab);
    }];
    
    [self addSubview:self.sexSwitchView];
    [self.sexSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(Adapt_Height(44));
        make.width.mas_equalTo(Adapt_Width(60));
        make.centerY.equalTo(self.titleLab);
    }];
    
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    if (userInfo.city) {
        NSArray *arr = [userInfo.city componentsSeparatedByString:@"_"];
        self.province = arr[0];
        self.city = arr[1];
        self.area = arr[2];
    }else{
        self.province = @"上海市";
        self.city = @"上海市";
        self.area = @"浦东新区";
    }
}

-(void)listenEvents{
    Weakify(self);
    //性别筛选
    [self.sexSwitchView.selectSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        [self.sexSelectSignal sendNext:x];
    }];
    
    //选择城市
    [[self.cityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self showAddressPicker];
    }];
}

-(void)setArea:(NSString *)area{
    _area = area;
    [self.cityBtn setTitle:area forState:UIControlStateNormal];
}

//选择常驻城市
-(void)showAddressPicker{
    BRAddressPickerView *addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeArea];
    addressPicker.title = @"选择常驻城市";
    addressPicker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    addressPicker.defaultSelectedArr = @[self.province,self.city,self.area];
    [addressPicker show];
    addressPicker.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        self.province = province.name;
        self.city = city.name;
        self.area = area.name;
        NSString *result = [NSString stringWithFormat:@"%@_%@_%@",self.province,self.city,self.area];
        [self.selectCitySignal sendNext:result];
    };
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Medium(17) textColorHex:kColor_333333];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _titleLab.text = [infoDictionary objectForKey:@"CFBundleName"];
    }
    return _titleLab;
}

-(HomepageSexSwitchView *)sexSwitchView{
    if (!_sexSwitchView) {
        _sexSwitchView = [[HomepageSexSwitchView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    }
    return _sexSwitchView;
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

-(RACSubject *)sexSelectSignal{
    if (!_sexSelectSignal) {
        _sexSelectSignal = [RACSubject subject];
    }
    return _sexSelectSignal;
}

-(RACSubject *)selectCitySignal{
    if (!_selectCitySignal) {
        _selectCitySignal = [RACSubject subject];
    }
    return _selectCitySignal;
}

@end
