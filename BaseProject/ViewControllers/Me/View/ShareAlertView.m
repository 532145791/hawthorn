//
//  ShareAlertView.m
//  BaseProject
//
//  Created by super on 2019/10/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "ShareAlertView.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface ShareAlertView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ShareAlertItemView *QQItem;
@property (nonatomic , strong) ShareAlertItemView *QQSpaceItem;
@property (nonatomic , strong) ShareAlertItemView *WXItem;
@property (nonatomic , strong) ShareAlertItemView *WXFriendItem;
@end

@implementation ShareAlertView

-(void)initViews{
    [super initViews];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(375));
        make.height.mas_equalTo(Adapt_Height(173));
        make.bottom.centerX.equalTo(self.bgView);
    }];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(17));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.WXItem];
    [self.WXItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(20));
        make.width.mas_equalTo(Adapt_Width(60));
        make.height.mas_equalTo(Adapt_Height(64));
        make.top.equalTo(self.titleLab.mas_bottom).offset(Adapt_Height(30));
    }];
    
    [self.contentView addSubview:self.WXFriendItem];
    [self.WXFriendItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.WXItem.mas_right).offset(Adapt_Width(31.66));
        make.width.height.centerY.equalTo(self.WXItem);
    }];
    
    [self.contentView addSubview:self.QQItem];
    [self.QQItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.WXFriendItem.mas_right).offset(Adapt_Width(31.66));
        make.width.height.centerY.equalTo(self.WXFriendItem);
    }];
    
    [self.contentView addSubview:self.QQSpaceItem];
    [self.QQSpaceItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QQItem.mas_right).offset(Adapt_Width(31.66));
        make.width.height.centerY.equalTo(self.QQItem);
    }];
    
    [self listenEvents];
}

-(void)listenEvents{
    WS(weakSelf)
    UITapGestureRecognizer *tapWX = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf shareToWXOrFriends:YES];
    }];
    [self.WXItem addGestureRecognizer:tapWX];
    
    UITapGestureRecognizer *tapWXFriend = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf shareToWXOrFriends:NO];
    }];
    [self.WXFriendItem addGestureRecognizer:tapWXFriend];
    
    UITapGestureRecognizer *tapQQ = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf shareToQQOrSpace:YES];
    }];
    [self.QQItem addGestureRecognizer:tapQQ];
    
    UITapGestureRecognizer *tapQQSpace = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf shareToQQOrSpace:NO];
    }];
    [self.QQSpaceItem addGestureRecognizer:tapQQSpace];
    
    //分享成功
    Weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kShareSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        [self dismiss];
    }];
}

-(void)setImage:(UIImage *)image{
    _image = image;
}

-(void)setDownloadUrl:(NSString *)downloadUrl{
    _downloadUrl = downloadUrl;
}

//分享到微信或者朋友圈
-(void)shareToWXOrFriends:(BOOL)isWX{
    if (self.type == 1) {
        //分享图片
        NSData *imageData = UIImageJPEGRepresentation(self.image, 1);
           
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = imageData;

        WXMediaMessage *message = [WXMediaMessage message];
        message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"login_logo"]);
        message.mediaObject = imageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = isWX?WXSceneSession:WXSceneTimeline;
        [WXApi sendReq:req];
    }else if (self.type == 2){
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = self.downloadUrl;
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"山楂";
        message.description = @"空虚寂寞就上山楂";
        [message setThumbImage:[UIImage imageNamed:@"login_logo"]];
        message.mediaObject = webpageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = isWX?WXSceneSession:WXSceneTimeline;
        [WXApi sendReq:req];
    }
}

-(void)shareToQQOrSpace:(BOOL)isQQ{
    if (self.type == 1) {
        //分享图片
        NSData *imageData = UIImageJPEGRepresentation(self.image, 1);
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imageData
                                                   previewImageData:imageData
                                                   title:@"山楂"
                                                   description :@"空虚寂寞就上山楂"];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        //将内容分享到
        if (isQQ) {
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            NSLog(@"分享到QQ好友%ld",(long)sent);
        }else{
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            NSLog(@"分享到QQ空间%ld",(long)sent);
        }
    }else if(self.type == 2){
        //分享图预览图URL地址
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL :[NSURL URLWithString:self.downloadUrl]
        title: @"山楂"
        description :@"空虚寂寞就上山楂"
        previewImageURL:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        if (isQQ) {
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            NSLog(@"分享到QQ好友%ld",(long)sent);
        }else{
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            NSLog(@"分享到QQ空间%ld",(long)sent);
        }
    }
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(15) textColorHex:kColor_666666];
        _titleLab.text = @"分享";
    }
    return _titleLab;
}

-(ShareAlertItemView *)QQItem{
    if (!_QQItem) {
        _QQItem = [ShareAlertItemView new];
        _QQItem.type = ShareAlertItemViewTypeQQ;
    }
    return _QQItem;
}

-(ShareAlertItemView *)QQSpaceItem{
    if (!_QQSpaceItem) {
        _QQSpaceItem = [ShareAlertItemView new];
        _QQSpaceItem.type = ShareAlertItemViewTypeQQSpace;
    }
    return _QQSpaceItem;
}

-(ShareAlertItemView *)WXItem{
    if (!_WXItem) {
        _WXItem = [ShareAlertItemView new];
        _WXItem.type = ShareAlertItemViewTypeWX;
    }
    return _WXItem;
}

-(ShareAlertItemView *)WXFriendItem{
    if (!_WXFriendItem) {
        _WXFriendItem = [ShareAlertItemView new];
        _WXFriendItem.type = ShareAlertItemViewTypeWXFriend;
    }
    return _WXFriendItem;
}
@end

@interface ShareAlertItemView ()
@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UILabel *titleLab;
@end

@implementation ShareAlertItemView

-(instancetype)init{
    if (self = [super init]) {
        [self initViews];
    }
    return self;
}

-(void)setType:(ShareAlertItemViewType)type{
    _type = type;
    switch (type) {
        case ShareAlertItemViewTypeQQ:
            {
                self.icon.image = [UIImage imageNamed:@"qq_friend"];
                self.titleLab.text = @"QQ";
            }
            break;
            
        case ShareAlertItemViewTypeQQSpace:
            {
                self.icon.image = [UIImage imageNamed:@"qq_space"];
                self.titleLab.text = @"QQ空间";
            }
            break;
            
        case ShareAlertItemViewTypeWX:
            {
                self.icon.image = [UIImage imageNamed:@"wx_friend"];
                self.titleLab.text = @"微信";
            }
            break;
        case ShareAlertItemViewTypeWXFriend:
            {
                self.icon.image = [UIImage imageNamed:@"wx_friends"];
                self.titleLab.text = @"朋友圈";
            }
            break;
            
        default:
            break;
    }
}

-(void)initViews{
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
    }];
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.icon.mas_bottom).offset(Adapt_Height(11));
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
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(14) textColorHex:kColor_999999];
    }
    return _titleLab;
}

@end
