//
//  VideoPlayView.m
//  BaseProject
//
//  Created by super on 2020/3/10.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoPlayView.h"
#import <SJBaseVideoPlayer.h>
@interface VideoPlayView ()
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIView *gestureView;
@property (nonatomic , strong) SJBaseVideoPlayer *player;
@end

@implementation VideoPlayView

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
}

-(void)play{
    self.player.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self.bgView addSubview:self.player.view];
    // 设置资源进行播放
    SJVideoPlayerURLAsset *asset = [[SJVideoPlayerURLAsset alloc] initWithURL:self.videoUrl];
    self.player.URLAsset = asset;
    [self.player play];
    
    [self addSubview:self.gestureView];
    [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self bringSubviewToFront:self.gestureView];
    
    WS(weakSelf)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf dismiss];
    }];
    [self.gestureView addGestureRecognizer:tap];
}

-(void)setVideoUrl:(NSURL *)videoUrl{
    _videoUrl = videoUrl;
    [self play];
}

-(void)show{
    self.alpha = 1;
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.bgView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.transform = CGAffineTransformIdentity;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.player stop];
        [self removeFromSuperview];
    }];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:1];
    }
    return _bgView;
}

-(SJBaseVideoPlayer *)player{
    if (!_player) {
        _player = [SJBaseVideoPlayer player];
//        _player.autoManageViewToFitOnScreenOrRotation = YES;
//        [_player.fitOnScreenManager setFitOnScreen:YES];
//        _player.controlLayerDelegate = self;
    }
    return _player;
}

-(UIView *)gestureView{
    if (!_gestureView) {
        _gestureView = [UIView new];
    }
    return _gestureView;
}

@end
