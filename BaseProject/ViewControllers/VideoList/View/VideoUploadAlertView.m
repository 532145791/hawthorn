//
//  VideoUploadAlertView.m
//  BaseProject
//
//  Created by super on 2020/3/6.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoUploadAlertView.h"

@interface VideoUploadAlertView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *hintLab;
@property (nonatomic , strong) UIButton *recordBtn;
@property (nonatomic , strong) UIButton *localBtn;
@property (nonatomic , strong) UIButton *cancelBtn;
@end

@implementation VideoUploadAlertView

-(void)initViews{
    [super initViews];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(300));
        make.height.mas_equalTo(Adapt_Height(200));
    }];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(22));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.hintLab];
    [self.hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(Adapt_Height(17));
        make.centerX.equalTo(self.contentView);
    }];
    
//    [self.contentView addSubview:self.recordBtn];
//    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.hintLab.mas_bottom).offset(Adapt_Height(32));
//        make.centerX.equalTo(self.contentView);
//        make.width.mas_equalTo(Adapt_Width(160));
//        make.height.mas_equalTo(Adapt_Height(34));
//    }];
    
    [self.contentView addSubview:self.localBtn];
    [self.localBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintLab.mas_bottom).offset(Adapt_Height(32));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(Adapt_Width(160));
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(Adapt_Height(-17));
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(Adapt_Width(160));
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self removeGesture];
    [self listenEvents];
}

-(void)listenEvents{
    Weakify(self);
    //开始录制
//    [[self.recordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        Strongify(self);
//        [self.selectSignal sendNext:@1];
//        [self dismiss];
//    }];
    
    //本地相册
    [[self.localBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectLocalVideo object:nil];
        [self dismiss];
    }];
    
    //取消
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self dismiss];
    }];
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:@"000000"];
        _titleLab.text = @"上传视频";
    }
    return _titleLab;
}

-(UILabel *)hintLab{
    if (!_hintLab) {
        _hintLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:kColor_Theme];
        _hintLab.text = @"视频时长不要超过30秒";
    }
    return _hintLab;
}

-(UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_recordBtn setTitle:@"开始录制" forState:UIControlStateNormal];
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.layer.cornerRadius = Adapt_Height(17);
    }
    return _recordBtn;
}

-(UIButton *)localBtn{
    if (!_localBtn) {
        _localBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_Theme backGroundColor:kColor_White];
        [_localBtn setTitle:@"本地相册" forState:UIControlStateNormal];
        _localBtn.layer.masksToBounds = YES;
        _localBtn.layer.cornerRadius = Adapt_Height(17);
        _localBtn.layer.borderColor = Color(kColor_Theme).CGColor;
        _localBtn.layer.borderWidth = 1;
    }
    return _localBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_333333 backGroundColor:kColor_White];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

-(RACSubject *)selectSignal{
    if (!_selectSignal) {
        _selectSignal = [RACSubject subject];
    }
    return _selectSignal;
}

@end
