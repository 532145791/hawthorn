//
//  UserDetailViewController.m
//  BaseProject
//
//  Created by super on 2020/3/9.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserDetailHeaderView.h"
#import "HomepageViewModel.h"
#import "UserDetailFreeChanceAlertView.h"
#import "MyPhotoCollectionViewCell.h"
#import "PreviewBigImageTool.h"
@interface UserDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UserDetailHeaderView *headerView;
@property (nonatomic , strong) UIButton *videoBtn;
@property (nonatomic , strong) UIButton *albumBtn;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , assign) BOOL isVideo;
@property (nonatomic , strong) NSMutableArray *imgUrlArr;
@property (nonatomic , strong) NSMutableArray *videoUrlArr;

@property (nonatomic , strong) HomepageViewModel *viewModel;
@property (nonatomic , strong) MyInfoModel *model;
@property (nonatomic , strong) UserDetailFreeChanceAlertView *freeChanceAlertView;
@property (nonatomic , strong) UserDetailCheckWXModel *checkResultModel;
@end

@implementation UserDetailViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title: @"",
                     kNav_RightButtonTitle:@"举报",
                     kNav_LeftButton:@(NavBarItemTypeBack)
                     };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color(@"ffffff");
    [self initViews];
    [self listenEvents];
    [self.viewModel loadUserDetailWithUserId:self.params[@"id"]];
}

-(void)initViews{
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(Adapt_Height(317-64));
    }];
    
    [self.view addSubview:self.videoBtn];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(117));
        make.top.equalTo(self.headerView.mas_bottom).offset(Adapt_Height(10));
    }];
    
    [self.view addSubview:self.albumBtn];
    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(Adapt_Width(-117));
        make.centerY.equalTo(self.videoBtn);
    }];
    
    [self.view addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(24));
        make.height.mas_equalTo(3);
        make.top.equalTo(self.videoBtn.mas_bottom).offset(Adapt_Height(2));
        make.centerX.equalTo(self.videoBtn);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self.view);
        make.top.equalTo(self.line.mas_bottom).offset(Adapt_Height(7));
    }];
}

-(void)listenEvents{
    Weakify(self);
    //用户详情接口回调
    [self.viewModel.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.model = x;
        self.headerView.model = x;
        if (self.model.videoList.count > 0) {
            [self swithBtnWithType:1];
        }else{
            if (self.model.albumList.count > 0) {
                [self swithBtnWithType:2];
            }else{
                [self swithBtnWithType:1];
            }
        }
        
        UserInfoModel *userInfo = [UserInfoManager getUserInfo];
        if ([userInfo.uid isEqualToString:self.params[@"id"]]) {
            self.headerView.isShowWX = YES;
            self.headerView.userWeixin = userInfo.weixin;
        }
    }];
    
    //点击查看用户微信按钮
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kTapCheckWeixin object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        [self.viewModel getWeixinWithUserId:self.params[@"id"]];
    }];
    
    //查看微信接口结果
    [self.viewModel.checkResultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.checkResultModel = x;
        if (self.checkResultModel.times == 0) {//免费次数已用完或未开通会员或会员过期了
            self.freeChanceAlertView.isNoChance = YES;
            [self.freeChanceAlertView showInCenter];
        }else if (self.checkResultModel.times > 0 && self.checkResultModel.times < 999){//还有免费次数
            self.freeChanceAlertView.isNoChance = NO;
            self.freeChanceAlertView.chance = self.checkResultModel.times;
            [self.freeChanceAlertView showInCenter];
        }else{//是会员
            self.headerView.isShowWX = YES;
            self.headerView.userWeixin = self.checkResultModel.weixin;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.checkResultModel.weixin;
            [SVProgressHUD showMessageWithStatus:@"已复制，请前往粘贴" dismissAfter:2];
        }
    }];
    
    //还有免费次数，显示微信号
    [self.freeChanceAlertView.tapCheckSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.headerView.isShowWX = YES;
        self.headerView.userWeixin = self.checkResultModel.weixin;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.checkResultModel.weixin;
        [SVProgressHUD showMessageWithStatus:@"已复制，请前往粘贴" dismissAfter:2];
    }];
    
    [[self.videoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self swithBtnWithType:1];
    }];
    
    [[self.albumBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [self swithBtnWithType:2];
    }];
}

-(void)rightNavigationItemsDidClicked:(id)sender{
    [MGJRouter openURL:kReportViewController withUserInfo:@{@"id":self.params[@"id"]} completion:nil];
}

-(void)swithBtnWithType:(NSInteger)type{
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Adapt_Width(24));
        make.height.mas_equalTo(3);
        make.top.equalTo(self.videoBtn.mas_bottom).offset(Adapt_Height(2));
        make.centerX.equalTo(type==1?self.videoBtn:self.albumBtn);
    }];
    
    self.isVideo = type == 1;
    [self.videoBtn setTitleColor:type==1?Color(kColor_Theme):Color(kColor_333333) forState:UIControlStateNormal];
    [self.albumBtn setTitleColor:type==1?Color(kColor_333333):Color(kColor_Theme) forState:UIControlStateNormal];
}

-(void)setIsVideo:(BOOL)isVideo{
    _isVideo = isVideo;
    if (self.model) {
        if (isVideo) {
            if (self.model.videoList.count == 0) {
                [self showNoDataViewWithHintMessage:@"TA还没有上传视频哦" iconName:@"homepage_detail_video_noData"];
                [self.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.collectionView);
                }];
            }else{
                [self.collectionView reloadData];
                [self removeNoDataView];
                if (self.videoUrlArr.count > 0) {
                    [self.videoUrlArr removeAllObjects];
                }
                for (AlbumOrVideoModel *model in self.model.videoList) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:@(NO) forKey:@"GQIsImageURL"];
                    [dic setObject:model.path forKey:@"GQURLString"];
                    [self.videoUrlArr addObject:dic];
                }
            }
        }else{
            if (self.model.albumList.count == 0) {
                [self showNoDataViewWithHintMessage:@"TA还没有上传相片哦" iconName:@"homepage_detail_album_noData"];
                [self.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.collectionView);
                }];
            }else{
                [self.collectionView reloadData];
                [self removeNoDataView];
                
                if (self.imgUrlArr.count > 0) {
                    [self.imgUrlArr removeAllObjects];
                }
                for (AlbumOrVideoModel *model in self.model.albumList) {
                    [self.imgUrlArr addObject:model.path];
                }
            }
        }
    }
}

#pragma mark - UICollectionView delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isVideo?self.model.videoList.count:self.model.albumList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPhotoCollectionViewCell" forIndexPath:indexPath];
    AlbumOrVideoModel *model ;
    if (self.isVideo) {
        model = self.model.videoList[indexPath.row];
    }else{
        model = self.model.albumList[indexPath.row];
    }
    cell.isPhoto = !self.isVideo;
    cell.imgUrl = model.path;
    cell.isShowSelectIcon = NO;
    if (self.isVideo) {
        cell.imgUrl = [model.path stringByAppendingString:@"?vframe/jpg/offset/1"];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumOrVideoModel *model ;
    if (self.isVideo) {
        model = self.model.videoList[indexPath.row];
    }else{
        model = self.model.albumList[indexPath.row];
    }
    
    if (self.isVideo) {
        [PreviewBigImageTool showWithVideoUrlArr:self.videoUrlArr inView:self.view.window selectIndex:indexPath.row];
    }else{
        [PreviewBigImageTool showWithImageUrlArr:self.imgUrlArr inView:self.view.window selectIndex:indexPath.row];
    }
}

-(UserDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [UserDetailHeaderView new];
    }
    return _headerView;
}

-(HomepageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [HomepageViewModel new];
    }
    return _viewModel;
}

-(UserDetailFreeChanceAlertView *)freeChanceAlertView{
    if (!_freeChanceAlertView) {
        _freeChanceAlertView = [UserDetailFreeChanceAlertView new];
    }
    return _freeChanceAlertView;
}

-(UIButton *)videoBtn{
    if (!_videoBtn) {
        _videoBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_Theme backGroundColor:kColor_White];
        [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    }
    return _videoBtn;
}

-(UIButton *)albumBtn{
    if (!_albumBtn) {
        _albumBtn = [UIView getButtonWithFontSize:Font_Regular(15) textColorHex:kColor_333333 backGroundColor:kColor_White];
        [_albumBtn setTitle:@"相片" forState:UIControlStateNormal];
    }
    return _albumBtn;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView getViewWithBgColorHex:kColor_Theme];
    }
    return _line;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(Adapt_Width(335/3), Adapt_Width(335/3));
        layout.minimumLineSpacing = Adapt_Width(4);
        layout.minimumInteritemSpacing = Adapt_Width(4);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = Color(kColor_White);
        [_collectionView registerClass:[MyPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MyPhotoCollectionViewCell"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, Adapt_Width(16), 0, Adapt_Width(16));
    }
    return _collectionView;
}

-(NSMutableArray *)imgUrlArr{
    if (!_imgUrlArr) {
        _imgUrlArr = [NSMutableArray array];
    }
    return _imgUrlArr;
}

-(NSMutableArray *)videoUrlArr{
    if (!_videoUrlArr) {
        _videoUrlArr = [NSMutableArray array];
    }
    return _videoUrlArr;
}
@end
