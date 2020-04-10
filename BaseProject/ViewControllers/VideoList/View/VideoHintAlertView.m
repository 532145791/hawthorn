//
//  VideoHintAlertView.m
//  BaseProject
//
//  Created by super on 2020/3/8.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoHintAlertView.h"

@interface VideoHintAlertView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *messageLab;
@property (nonatomic , strong) UIButton *okBtn;
@end

@implementation VideoHintAlertView

-(void)initViews{
    [super initViews];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(300));
        make.height.mas_equalTo(Adapt_Height(280));
    }];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(27));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.messageLab];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(Adapt_Height(10));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(Adapt_Width(220));
    }];
    
    [self.contentView addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(Adapt_Height(-20));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(Adapt_Width(116));
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self listenEvents];
    
    [self removeGesture];
}

-(void)listenEvents{
    Weakify(self);
    [[self.okBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self dismiss];
        [UserDefaults saveDataWithKey:@"FirstUploadVideo" value:@(2)];
        [self.selectSignal sendNext:@(1)];
    }];
}

-(RACSubject *)selectSignal{
    if (!_selectSignal) {
        _selectSignal = [RACSubject subject];
    }
    return _selectSignal;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:kColor_333333];
        _titleLab.text = @"用户隐私政策概要";
    }
    return _titleLab;
}

-(UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:@"363636"];
        _messageLab.numberOfLines = 0;
        _messageLab.textAlignment = NSTextAlignmentLeft;
        _messageLab.text = @"1，请不要在视频中透露您的任何联系方式；\n2，请不要发布黄赌毒相关的违法视频；\n3，请不要发布含有辱骂、恐吓、威胁内容的视频；\n一旦发现，将做封号处理，谢谢配合！";
    }
    return _messageLab;
}

-(UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_okBtn setTitle:@"同意" forState:UIControlStateNormal];
        _okBtn.layer.masksToBounds = YES;
        _okBtn.layer.cornerRadius = Adapt_Height(17);
    }
    return _okBtn;
}

@end
