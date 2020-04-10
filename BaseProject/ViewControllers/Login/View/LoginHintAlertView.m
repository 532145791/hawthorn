//
//  LoginHintAlertView.m
//  BaseProject
//
//  Created by super on 2020/3/8.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "LoginHintAlertView.h"

@interface LoginHintAlertView ()<UITextViewDelegate>
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UITextView *messageLab;
@property (nonatomic , strong) UIButton *cancelBtn;
@property (nonatomic , strong) UIButton *okBtn;
@end

@implementation LoginHintAlertView

-(void)initViews{
    [super initViews];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(300));
        make.height.mas_equalTo(Adapt_Height(300));
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
        make.bottom.mas_equalTo(Adapt_Height(-50));
    }];
    
    [self.contentView addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(Adapt_Height(-16));
        make.right.mas_equalTo(Adapt_Width(-41));
        make.width.mas_equalTo(Adapt_Width(116));
        make.height.mas_equalTo(Adapt_Height(34));
    }];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.okBtn);
        make.left.mas_equalTo(Adapt_Width(55));
    }];
    
    [self listenEvents];
    
    [self removeGesture];
}

-(void)listenEvents{
    Weakify(self);
    //同意协议
    [[self.okBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self.resultSignal sendNext:@"1"];
        [self dismiss];
    }];
    
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self dismiss];
    }];
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([URL.scheme isEqualToString:@"privacy"]) {
        [MGJRouter openURL:kBaseWebViewController withUserInfo:@{@"url":kPrivacyPolicy} completion:nil];
        [self dismiss];
        return NO;
    }else if ([URL.scheme isEqualToString:@"protocol"]) {
        [MGJRouter openURL:kBaseWebViewController withUserInfo:@{@"url":kProtocol} completion:nil];
        [self dismiss];
        return NO;
    }
    return YES;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(17) textColorHex:kColor_333333];
        _titleLab.text = @"用户隐私政策概要";
    }
    return _titleLab;
}

-(UITextView *)messageLab{
    if (!_messageLab) {
        _messageLab = [UITextView new];
        _messageLab.textColor = Color(@"363636");
        _messageLab.font = Font_Regular(12);
        _messageLab.textAlignment = NSTextAlignmentLeft;
        NSString *message = @"亲爱的用户：\n应国家政策要求，您必须认真阅读并同意以下协议后《用户协议》和《隐私政策》，才能正常使用山楂APP，特向您说明下：\n1、为向您提供交易相关基本功能，我们会收集和使用必要的信息；\n2、未经您同意，我们不会从第三方处获取、共享或向其提供您的信息；\n3、您可以查询、更正、删除您的个人信息，我们提供账户注销渠道。";
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:message];
        NSRange range1 = [message rangeOfString:@"《用户协议》"];
        NSRange range2 = [message rangeOfString:@"《隐私政策》"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = Color(kColor_Theme);
        [attri addAttributes:dic range:range1];
        [attri addAttribute:NSLinkAttributeName value:@"protocol://" range:range1];
        [attri addAttribute:NSLinkAttributeName value:@"privacy://" range:range2];
        [attri addAttributes:dic range:range2];
        _messageLab.attributedText = attri;
        _messageLab.delegate = self;
        _messageLab.editable = NO;
//        _messageLab.scrollEnabled = NO;
    }
    return _messageLab;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:@"4D4D4D" backGroundColor:kColor_White];
        [_cancelBtn setTitle:@"不同意" forState:UIControlStateNormal];
    }
    return _cancelBtn;
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

-(RACSubject *)resultSignal{
    if (!_resultSignal) {
        _resultSignal = [RACSubject subject];
    }
    return _resultSignal;
}

@end
