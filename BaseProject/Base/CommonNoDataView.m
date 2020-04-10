//
//  CommonNoDataView.m
//  BaseProject
//
//  Created by super on 2019/1/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "CommonNoDataView.h"

@interface CommonNoDataView ()
@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UILabel *hintLab;
@end

@implementation CommonNoDataView

-(instancetype)init{
    if (self = [super init]) {
        [self initViews];
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return self;
}

-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    self.icon.image = [UIImage imageNamed:iconName];
}

-(void)setHintMessage:(NSString *)hintMessage{
    _hintMessage = hintMessage;
    self.hintLab.text = hintMessage;
}

-(void)initViews{
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-13);
    }];
    
    [self addSubview:self.hintLab];
    [self.hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [UIView getImageViewWithImageName:@"nodata_icon"];
    }
    return _icon;
}

-(UILabel *)hintLab{
    if (!_hintLab) {
        _hintLab = [UIView getLabelWithFontSize:Font_Regular(14) textColorHex:kColor_333333];
        _hintLab.text = @"暂无数据";
    }
    return _hintLab;
}
@end
