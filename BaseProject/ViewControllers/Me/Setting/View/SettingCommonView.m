//
//  SettingCommonView.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "SettingCommonView.h"
#import "LoginViewModel.h"
@interface SettingCommonView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UILabel *contentLab;
@end

@implementation SettingCommonView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_White);
        [self initViews];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.contentLab.text = content;
}

-(void)setType:(SettingCommonViewType)type{
    _type = type;
    switch (type) {
        case SettingCommonViewTypeLogo:
        {
            [self addSubview:self.imgView];
            [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(Adapt_Width(-18));
                make.centerY.equalTo(self);
            }];
            self.imgView.image = [UIImage imageNamed:@"me_setting_logo"];
        }
            break;
        case SettingCommonViewTypeJump:
        {
            [self addSubview:self.imgView];
            [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(Adapt_Width(-18));
                make.centerY.equalTo(self);
            }];
            self.imgView.image = [UIImage imageNamed:@"light-arrow"];
            
            WS(weakSelf)
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                if ([weakSelf.title isEqualToString:@"用户协议"]) {
                    [MGJRouter openURL:kBaseWebViewController withUserInfo:@{@"url":kProtocol} completion:nil];
                }else if ([weakSelf.title isEqualToString:@"隐私政策"]) {
                    [MGJRouter openURL:kBaseWebViewController withUserInfo:@{@"url":kPrivacyPolicy} completion:nil];
                }
            }];
            [self addGestureRecognizer:tap];
        }
            break;
        case SettingCommonViewTypeContent:
        {
            [self addSubview:self.contentLab];
            [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(Adapt_Width(-18));
                make.centerY.equalTo(self);
            }];
            
            if ([self.title isEqualToString:@"版本号"]) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                    //版本号检测
                    [[LoginViewModel new] checkNewVersion];
                }];
                [self addGestureRecognizer:tap];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)initViews{
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(22));
        make.centerY.equalTo(self);
    }];
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(15) textColorHex:kColor_333333];
    }
    return _titleLab;
}

-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:kColor_999999];
    }
    return _contentLab;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}
@end
