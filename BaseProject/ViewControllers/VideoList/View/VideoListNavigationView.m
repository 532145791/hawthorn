//
//  VideoListNavigationView.m
//  BaseProject
//
//  Created by super on 2020/3/5.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoListNavigationView.h"
#import "HomepageSexSwitchView.h"
#import "VideoHintAlertView.h"
#import "VideoUploadAlertView.h"
@interface VideoListNavigationView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIButton *publicBtn;//秀一秀
@property (nonatomic , strong) HomepageSexSwitchView *sexSwitchView;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) VideoHintAlertView *hintView;
@end

@implementation VideoListNavigationView

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
    
    [self addSubview:self.sexSwitchView];
    [self.sexSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(self.titleLab);
    }];
    
    [self addSubview:self.publicBtn];
    [self.publicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(Adapt_Height(24));
        make.width.mas_equalTo(Adapt_Width(64));
        make.centerY.equalTo(self.titleLab);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)listenEvents{
    Weakify(self);
    [[self.publicBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        int isFirst = [[UserDefaults getDataWithKey:@"FirstUploadVideo"] intValue];
        if (isFirst != 2) {//说明没有弹过
            [self.hintView showInCenter];
        }else{
            //说明弹过
            [[VideoUploadAlertView new] showInCenter];
        }
    }];
    
    [self.hintView.selectSignal subscribeNext:^(id  _Nullable x) {
        [[VideoUploadAlertView new] showInCenter];
    }];
    
    //性别筛选
    [self.sexSwitchView.selectSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        [self.sexSelectSignal sendNext:x];
    }];
}

-(VideoHintAlertView *)hintView{
    if (!_hintView) {
        _hintView = [VideoHintAlertView new];
    }
    return _hintView;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Medium(17) textColorHex:kColor_333333];
        _titleLab.text = @"个人秀";
    }
    return _titleLab;
}

-(HomepageSexSwitchView *)sexSwitchView{
    if (!_sexSwitchView) {
        _sexSwitchView = [[HomepageSexSwitchView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    }
    return _sexSwitchView;
}

-(UIButton *)publicBtn{
    if (!_publicBtn) {
        _publicBtn = [UIView getButtonWithFontSize:Font_Regular(13) textColorHex:@"313131" backGroundColor:kColor_White];
        [_publicBtn setTitle:@"秀一秀" forState:UIControlStateNormal];
        _publicBtn.layer.masksToBounds = YES;
        _publicBtn.layer.cornerRadius = 2;
        _publicBtn.layer.borderColor = Color(kColor_eeeeee).CGColor;
        _publicBtn.layer.borderWidth = 1;
    }
    return _publicBtn;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView getViewWithBgColorHex:@"D8D8D8"];
    }
    return _line;
}

-(RACSubject *)sexSelectSignal{
    if (!_sexSelectSignal) {
        _sexSelectSignal = [RACSubject subject];
    }
    return _sexSelectSignal;
}
@end
