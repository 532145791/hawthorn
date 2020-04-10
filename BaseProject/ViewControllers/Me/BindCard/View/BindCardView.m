//
//  BindCardView.m
//  BaseProject
//
//  Created by super on 2020/3/12.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BindCardView.h"

@interface BindCardView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UITextField *textField;
@property (nonatomic , strong) UIView *line;
@end

@implementation BindCardView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_White);
        [self initViews];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(16));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(140));
        make.right.mas_equalTo(Adapt_Width(-10));
        make.height.mas_equalTo(Adapt_Height(44));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(16));
        make.bottom.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)setIsHiddenLine:(BOOL)isHiddenLine{
    _isHiddenLine = isHiddenLine;
    self.line.hidden = isHiddenLine;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
    if ([title isEqualToString:@"银行卡号"]||[title isEqualToString:@"手机号"]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.textField.text = content;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(15) textColorHex:kColor_333333];
    }
    return _titleLab;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [UIView getTextFieldWithFontSize:Font_Regular(15) textColorHex:kColor_999999 placeHolder:@"请输入"];
        _textField.textAlignment = NSTextAlignmentLeft;
    }
    return _textField;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView getViewWithBgColorHex:kColor_eeeeee];
    }
    return _line;
}

@end
