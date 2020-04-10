//
//  HomepageTableViewCell.m
//  BaseProject
//
//  Created by super on 2020/3/5.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "HomepageTableViewCell.h"

@interface HomepageTableViewCell ()
@property (nonatomic , strong) UIImageView *userIcon;
@property (nonatomic , strong) UILabel *userNameLab;
@property (nonatomic , strong) HomepageAgeView *ageView;
@property (nonatomic , strong) UILabel *areaLab;//区
@property (nonatomic , strong) UILabel *hobbyLab;//爱好
@property (nonatomic , strong) UILabel *occupationLab;//职业
@property (nonatomic , strong) UIView *line;
@end

@implementation HomepageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = Color(kColor_White);
        [self initViews];
    }
    return self;
}

-(void)setModel:(HomepageItemModel *)model{
    _model = model;
    [self.userIcon setImageWithURL:[NSURL URLWithString:model.headPath] placeholder:[UIImage imageNamed:@"user_default_icon"]];
    self.userNameLab.text = model.nickname;
    self.ageView.isMale = model.gender==1;
    self.ageView.age = model.age;
    NSArray *cityArr = [model.city componentsSeparatedByString:@"_"];
    self.areaLab.text = cityArr[2];
    self.hobbyLab.text = model.likes;
    self.occupationLab.text = model.occupation;
}

-(void)setAge:(NSString *)age{
    _age = age;
    self.ageView.age = age;
}

-(void)setIsMale:(BOOL)isMale{
    _isMale = isMale;
    self.ageView.isMale = isMale;
    self.areaLab.backgroundColor = isMale?Color_alpha(@"1046FF", 0.15):Color_alpha(kColor_Theme, 0.19);
}

-(void)initViews{
    [self.contentView addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(16));
        make.width.height.mas_equalTo(Adapt_Width(80));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Adapt_Width(15));
        make.top.equalTo(self.userIcon);
    }];
    
    [self.contentView addSubview:self.ageView];
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Adapt_Width(15));
        make.top.equalTo(self.userNameLab.mas_bottom).offset(Adapt_Height(11));
        make.width.mas_equalTo(Adapt_Width(68));
        make.height.mas_equalTo(Adapt_Height(20));
    }];
    
    [self.contentView addSubview:self.areaLab];
    [self.areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageView.mas_right).offset(Adapt_Width(4));
        make.centerY.equalTo(self.ageView);
        make.width.mas_equalTo(Adapt_Width(68));
        make.height.mas_equalTo(Adapt_Height(20));
    }];
    
    [self.contentView addSubview:self.hobbyLab];
    [self.hobbyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Adapt_Width(15));
        make.top.equalTo(self.ageView.mas_bottom).offset(Adapt_Height(8));
        make.width.mas_equalTo(Adapt_Width(68));
        make.height.mas_equalTo(Adapt_Height(20));
    }];
    
    [self.contentView addSubview:self.occupationLab];
    [self.occupationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hobbyLab.mas_right).offset(Adapt_Width(4));
        make.centerY.equalTo(self.hobbyLab);
        make.width.mas_equalTo(Adapt_Width(68));
        make.height.mas_equalTo(Adapt_Height(20));
    }];
    
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(15));
        make.right.mas_equalTo(Adapt_Width(-15));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

-(UIImageView *)userIcon{
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = 4;
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userIcon;
}

-(UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [UIView getLabelWithFontSize:Font_Medium(17) textColorHex:kColor_333333];
    }
    return _userNameLab;
}

-(HomepageAgeView *)ageView{
    if (!_ageView) {
        _ageView = [HomepageAgeView new];
    }
    return _ageView;
}

-(UILabel *)areaLab{
    if (!_areaLab) {
        _areaLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:kColor_333333];
        _areaLab.backgroundColor = Color_alpha(kColor_Theme, 0.19);
        _areaLab.textAlignment = NSTextAlignmentCenter;
        _areaLab.layer.masksToBounds = YES;
        _areaLab.layer.cornerRadius = Adapt_Height(10);
    }
    return _areaLab;
}

-(UILabel *)hobbyLab{
    if (!_hobbyLab) {
        _hobbyLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:kColor_333333];
        _hobbyLab.backgroundColor = Color(@"E5EAEC");
        _hobbyLab.textAlignment = NSTextAlignmentCenter;
        _hobbyLab.layer.masksToBounds = YES;
        _hobbyLab.layer.cornerRadius = Adapt_Height(10);
    }
    return _hobbyLab;
}

-(UILabel *)occupationLab{
    if (!_occupationLab) {
        _occupationLab = [UIView getLabelWithFontSize:Font_Regular(12) textColorHex:kColor_333333];
        _occupationLab.backgroundColor = Color(@"E5EAEC");
        _occupationLab.textAlignment = NSTextAlignmentCenter;
        _occupationLab.layer.masksToBounds = YES;
        _occupationLab.layer.cornerRadius = Adapt_Height(10);
    }
    return _occupationLab;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView getViewWithBgColorHex:@"d8d8d8"];
    }
    return _line;
}

@end

@interface HomepageAgeView ()
@property (nonatomic , strong) UIImageView *sexIcon;
@property (nonatomic , strong) UILabel *ageLab;
@end

@implementation HomepageAgeView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color_alpha(kColor_Theme, 0.19);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = Adapt_Height(10);
        [self initViews];
    }
    return self;
}

-(void)setAge:(NSString *)age{
    _age = age;
    self.ageLab.text = age;
}

-(void)setIsMale:(BOOL)isMale{
    _isMale = isMale;
    self.sexIcon.image = [UIImage imageNamed:isMale?@"homepage_male_small":@"homepage_female_small"];
    self.backgroundColor = isMale?Color_alpha(@"1046FF", 0.15):Color_alpha(kColor_Theme, 0.19);
    self.ageLab.textColor = isMale?Color(@"1046FF"):Color(kColor_Theme);
}

-(void)initViews{
    [self addSubview:self.ageLab];
    [self.ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-20));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.sexIcon];
    [self.sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ageLab.mas_left);
        make.centerY.equalTo(self);
    }];
}

-(UIImageView *)sexIcon{
    if (!_sexIcon) {
        _sexIcon = [UIView getImageViewWithImageName:@""];
    }
    return _sexIcon;
}

-(UILabel *)ageLab{
    if (!_ageLab) {
        _ageLab = [UIView getLabelWithFontSize:Font_Medium(14) textColorHex:kColor_Theme];
        _ageLab.text = @"00";
    }
    return _ageLab;
}

@end
