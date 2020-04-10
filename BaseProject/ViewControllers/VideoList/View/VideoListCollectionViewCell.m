//
//  VideoListCollectionViewCell.m
//  BaseProject
//
//  Created by super on 2020/3/5.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoListCollectionViewCell.h"

@interface VideoListCollectionViewCell ()
@property (nonatomic , strong) UIView *timeBgView;
@property (nonatomic , strong) UIImageView *timeIcon;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UIButton *playBtn;
@property (nonatomic , strong) UIView *infoBgView;
@property (nonatomic , strong) UILabel *userNameLab;
@property (nonatomic , strong) VideoListAgeView *ageView;
@property (nonatomic , strong) UILabel *areaLab;//区
@property (nonatomic , strong) UILabel *occupationLab;//职业
@end

@implementation VideoListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [self initViews];
        [self listenEvents];
    }
    return self;
}

-(void)listenEvents{
    WS(weakSelf)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [MGJRouter openURL:kUserDetailViewController withUserInfo:@{@"id":weakSelf.model.id} completion:nil];
    }];
    [self.infoBgView addGestureRecognizer:tap];
}

-(void)setModel:(VideoItemModel *)model{
    _model = model;
    [self updateTimeLabWidthWithTimeStr:[NSDate getFormatterTime:model.createTime]];
    [self.videoThumbnailView setImageWithURL:[NSURL URLWithString:[model.path stringByAppendingString:@"?vframe/jpg/offset/1"]] placeholder:[UIImage imageNamed:@"user_default_icon"]];
    self.userNameLab.text = model.nickname;
    self.ageView.isMale = model.gender==1;
    self.ageView.age = model.age;
    self.occupationLab.text = model.occupation;
    NSArray *cityArr = [model.city componentsSeparatedByString:@"_"];
    self.areaLab.text = cityArr[2];
}

-(void)updateTimeLabWidthWithTimeStr:(NSString *)timeStr{
    self.timeLab.text = timeStr;
    CGSize size = [self.timeLab sizeThatFits:CGSizeMake(MAXFLOAT, Adapt_Height(16))];
    [self.timeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(16) + Adapt_Width(4) + size.width + Adapt_Width(4));
    }];
}

-(void)initViews{
    [self.contentView addSubview:self.videoThumbnailView];
    [self.videoThumbnailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(Adapt_Height(220));
    }];
    
    [self.videoThumbnailView addSubview:self.timeBgView];
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(7));
        make.top.mas_equalTo(Adapt_Height(9));
        make.height.mas_equalTo(Adapt_Height(16));
        make.width.mas_equalTo(Adapt_Width(80));
    }];
    
    [self.videoThumbnailView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoThumbnailView);
    }];
    
    [self.timeBgView addSubview:self.timeIcon];
    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.timeBgView);
        make.width.height.mas_equalTo(Adapt_Width(16));
    }];
    
    [self.timeBgView addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeBgView);
        make.left.equalTo(self.timeIcon.mas_right).offset(Adapt_Width(4));
    }];
    
    [self.contentView addSubview:self.infoBgView];
    [self.infoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(Adapt_Height(54));
    }];
    
    [self.infoBgView addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(9));
        make.top.mas_equalTo(Adapt_Height(5));
        make.width.mas_lessThanOrEqualTo(Adapt_Width(110));
    }];
    
    [self.infoBgView addSubview:self.ageView];
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLab.mas_right).offset(Adapt_Width(3));
        make.centerY.equalTo(self.userNameLab);
        make.width.mas_equalTo(Adapt_Width(36));
        make.height.mas_equalTo(Adapt_Height(16));
    }];
    
    [self.infoBgView addSubview:self.areaLab];
    [self.areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLab);
        make.top.equalTo(self.userNameLab.mas_bottom).offset(Adapt_Height(8));
        make.width.mas_equalTo(Adapt_Width(48));
        make.height.mas_equalTo(Adapt_Height(16));
    }];
    
    [self.infoBgView addSubview:self.occupationLab];
    [self.occupationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.areaLab.mas_right).offset(Adapt_Width(2));
        make.centerY.equalTo(self.areaLab);
        make.width.mas_equalTo(Adapt_Width(48));
        make.height.mas_equalTo(Adapt_Height(16));
    }];
}

-(UIImageView *)videoThumbnailView{
    if (!_videoThumbnailView) {
        _videoThumbnailView = [UIImageView new];
        _videoThumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        _videoThumbnailView.layer.masksToBounds = YES;
        _videoThumbnailView.backgroundColor = Color(kColor_eeeeee);
    }
    return _videoThumbnailView;
}

-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    }
    return _playBtn;
}

-(UIView *)timeBgView{
    if (!_timeBgView) {
        _timeBgView = [UIView new];
        _timeBgView.backgroundColor = Color_alpha(@"000000", 0.25);
        _timeBgView.layer.masksToBounds = YES;
        _timeBgView.layer.cornerRadius = 4;
    }
    return _timeBgView;
}

-(UIImageView *)timeIcon{
    if (!_timeIcon) {
        _timeIcon = [UIView getImageViewWithImageName:@"video_time_icon"];
    }
    return _timeIcon;
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UIView getLabelWithFontSize:Font_Regular(10) textColorHex:kColor_White];
    }
    return _timeLab;
}

-(UIView *)infoBgView{
    if (!_infoBgView) {
        _infoBgView = [UIView getViewWithBgColorHex:@"2B2C2F"];
    }
    return _infoBgView;
}

-(UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [UIView getLabelWithFontSize:Font_Medium(14) textColorHex:kColor_White];
        _userNameLab.textAlignment = NSTextAlignmentLeft;
        _userNameLab.text = @"用户昵称";
    }
    return _userNameLab;
}

-(VideoListAgeView *)ageView{
    if (!_ageView) {
        _ageView = [VideoListAgeView new];
    }
    return _ageView;
}

-(UILabel *)areaLab{
    if (!_areaLab) {
        _areaLab = [UIView getLabelWithFontSize:Font_Regular(11) textColorHex:kColor_333333];
        _areaLab.backgroundColor = Color(@"E5EAEC");
        _areaLab.textAlignment = NSTextAlignmentCenter;
        _areaLab.layer.masksToBounds = YES;
        _areaLab.layer.cornerRadius = Adapt_Height(8);
        _areaLab.text = @"浦东新区";
    }
    return _areaLab;
}

-(UILabel *)occupationLab{
    if (!_occupationLab) {
        _occupationLab = [UIView getLabelWithFontSize:Font_Regular(11) textColorHex:kColor_333333];
        _occupationLab.backgroundColor = Color(@"E5EAEC");
        _occupationLab.textAlignment = NSTextAlignmentCenter;
        _occupationLab.layer.masksToBounds = YES;
        _occupationLab.layer.cornerRadius = Adapt_Height(8);
        _occupationLab.text = @"上班族";
    }
    return _occupationLab;
}

@end

@interface VideoListAgeView ()
@property (nonatomic , strong) UIImageView *sexIcon;
@property (nonatomic , strong) UILabel *ageLab;
@end

@implementation VideoListAgeView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_Theme);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = Adapt_Height(8);
        [self initViews];
    }
    return self;
}

-(void)setIsMale:(BOOL)isMale{
    _isMale = isMale;
    self.sexIcon.image = [UIImage imageNamed:isMale?@"video_sexIcon_male_white":@"video_sexIcon_female_white"];
    self.backgroundColor = isMale?Color(@"1046FF"):Color(kColor_Theme);
}

-(void)setAge:(NSString *)age{
    _age = age;
    self.ageLab.text = age;
}

-(void)initViews{
    [self addSubview:self.ageLab];
    [self.ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-6));
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
        _sexIcon = [UIView getImageViewWithImageName:@"video_sexIcon_female_white"];
    }
    return _sexIcon;
}

-(UILabel *)ageLab{
    if (!_ageLab) {
        _ageLab = [UIView getLabelWithFontSize:Font_Medium(12) textColorHex:kColor_White];
        _ageLab.text = @"00";
    }
    return _ageLab;
}

@end
