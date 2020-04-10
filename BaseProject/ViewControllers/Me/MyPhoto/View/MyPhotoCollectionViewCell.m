//
//  MyPhotoCollectionViewCell.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "MyPhotoCollectionViewCell.h"

@interface MyPhotoCollectionViewCell ()
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UIImageView *selectIcon;
@property (nonatomic , strong) UIImageView *videoIcon;
@end

@implementation MyPhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

-(void)setIsPhoto:(BOOL)isPhoto{
    _isPhoto = isPhoto;
    self.videoIcon.hidden = isPhoto;
}

-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self.imgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"user_default_icon"]];
}

-(void)setIsShowSelectIcon:(BOOL)isShowSelectIcon{
    _isShowSelectIcon = isShowSelectIcon;
    self.selectIcon.hidden = !isShowSelectIcon;
}

-(void)initViews{
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.selectIcon];
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(Adapt_Height(-7));
        make.right.mas_equalTo(Adapt_Width(-10));
    }];
    
    [self.contentView addSubview:self.videoIcon];
    [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

-(UIImageView *)selectIcon{
    if (!_selectIcon) {
        _selectIcon = [UIView getImageViewWithImageName:@"me_photo_select"];
    }
    return _selectIcon;
}

-(UIImageView *)videoIcon{
    if (!_videoIcon) {
        _videoIcon = [UIView getImageViewWithImageName:@"video_play_small_icon"];
    }
    return _videoIcon;
}

@end
