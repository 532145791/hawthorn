//
//  BuyCoinNavigationView.m
//  BaseProject
//
//  Created by super on 2020/3/24.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BuyCoinNavigationView.h"

@interface BuyCoinNavigationView ()
@property (nonatomic , strong) UIButton *backBtn;
@property (nonatomic , strong) UILabel *titleLab;
@end

@implementation BuyCoinNavigationView

-(instancetype)init{
    if (self = [super init]) {
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(44);
    }];
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.backBtn);
    }];
}

-(void)listenEvents{
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[CommonTool currentViewController].navigationController popViewControllerAnimated:YES];
    }];
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn  setImage:[UIImage imageNamed:@"nav-white-back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Medium(17) textColorHex:kColor_White];
        _titleLab.text = @"购买";
    }
    return _titleLab;
}

@end
