//
//  HomepageSexSwitchView.m
//  BaseProject
//
//  Created by super on 2020/3/2.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "HomepageSexSwitchView.h"

@interface HomepageSexSwitchView ()
@property (nonatomic , strong) UIImageView *maleIcon;
@property (nonatomic , strong) UIImageView *femaleIcon;
@end

@implementation HomepageSexSwitchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.maleIcon];
    [self.maleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(-8);
    }];
    
    [self addSubview:self.femaleIcon];
    [self.femaleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(8);
    }];
    
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    self.isMale = userInfo.sex==2;
}

-(void)listenEvents{
    WS(weakSelf)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        weakSelf.isMale = !weakSelf.isMale;
    }];
    [self addGestureRecognizer:tap];
}

-(void)setIsMale:(BOOL)isMale{
    _isMale = isMale;
    self.maleIcon.image = [UIImage imageNamed:isMale?@"homepage_male_select":@"homepage_male_normal"];
    self.femaleIcon.image = [UIImage imageNamed:isMale?@"homepage_female_normal":@"homepage_female_select"];
    [self.selectSignal sendNext:@(self.isMale)];
}

-(UIImageView *)maleIcon{
    if (!_maleIcon) {
        _maleIcon = [UIView getImageViewWithImageName:@"homepage_male_normal"];
    }
    return _maleIcon;
}

-(UIImageView *)femaleIcon{
    if (!_femaleIcon) {
        _femaleIcon = [UIView getImageViewWithImageName:@"homepage_female_normal"];
    }
    return _femaleIcon;
}

-(RACSubject *)selectSignal{
    if (!_selectSignal) {
        _selectSignal = [RACSubject subject];
    }
    return _selectSignal;
}

@end
