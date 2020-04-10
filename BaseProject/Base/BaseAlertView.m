//
//  BaseAlertView.m
//  BaseProject
//
//  Created by super on 2018/11/15.
//  Copyright © 2018 lengchao. All rights reserved.
//

#import "BaseAlertView.h"

@interface BaseAlertView ()

@property (nonatomic , strong) UITapGestureRecognizer *tap;
@end

@implementation BaseAlertView

-(instancetype)init{
    if (self = [super init]) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.bgView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.width.mas_equalTo(Adapt_Width(200));
        make.height.mas_equalTo(Adapt_Height(200));
    }];
}

-(void)showInCenter{
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.bgView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.bgView.alpha = 0.5;
    self.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.3];
        self.bgView.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 1;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)showInBottom{
    self.alpha = 1;
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.contentView layoutIfNeeded];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)removeGesture{
    [self.bgView removeGestureRecognizer:self.tap];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.3];
        self.tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self dismiss];
        }];
        [_bgView addGestureRecognizer:self.tap];
    }
    return _bgView;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView getViewWithBgColorHex:kColor_White];
    }
    return _contentView;
}
@end
