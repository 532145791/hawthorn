//
//  MeTableViewCell.m
//  BaseProject
//
//  Created by super on 2019/10/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "MeTableViewCell.h"

@interface MeTableViewCell ()
@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *subtitleLab;
@property (nonatomic , strong) UIImageView *arrowIcon;
@end

@implementation MeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    self.icon.image = [UIImage imageNamed:iconName];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

-(void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
    self.subtitleLab.text = subtitle;
}

-(void)setIsHiddenArrowIcon:(BOOL)isHiddenArrowIcon{
    _isHiddenArrowIcon = isHiddenArrowIcon;
    self.arrowIcon.hidden = isHiddenArrowIcon;
    
    [self.subtitleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-17));
        make.centerY.equalTo(self.contentView);
    }];
}

-(void)initViews{
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(17));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Adapt_Width(10));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.arrowIcon];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-17));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.subtitleLab];
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowIcon.mas_left).offset(Adapt_Width(-10));
        make.centerY.equalTo(self.contentView);
    }];
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
    }
    return _icon;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(15) textColorHex:kColor_333333];
    }
    return _titleLab;
}

-(UILabel *)subtitleLab{
    if (!_subtitleLab) {
        _subtitleLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:kColor_999999];
    }
    return _subtitleLab;
}

-(UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [UIView getImageViewWithImageName:@"light-arrow"];
    }
    return _arrowIcon;
}
@end
