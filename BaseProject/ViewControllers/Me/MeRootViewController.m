//
//  MeRootViewController.m
//  BaseProject
//
//  Created by super on 2019/10/16.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "MeRootViewController.h"
#import "MeHeaderView.h"
#import "MeTableViewCell.h"
#import "MeViewModel.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MeRootViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , strong) MeHeaderView *headerView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , assign) BOOL isLogin;
@property (nonatomic , strong) MeViewModel *viewModel;
@property (nonatomic , strong) MyInfoModel *model;
@end

@implementation MeRootViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title: @"我的"
                    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self listenEvents];
}

-(void)listenEvents{
    Weakify(self);
    [self.viewModel.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.model = x;
        self.headerView.model = self.model;
        [self.tableView reloadData];
    }];
}

-(void)loadData{
    [self.viewModel getMyData];
}

-(void)initViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.frame = CGRectMake(0, 0, Adapt_Width(375), Adapt_Height(114));
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Adapt_Height(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Adapt_Height(10);
    }
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTableViewCell" forIndexPath:indexPath];
    if (indexPath.section == 1){
        if (indexPath.row == 0) {//我的相册
            cell.iconName = @"me_myPhoto_icon";
            cell.title = @"我的相册";
            if (self.model.album == 0) {
                cell.subtitle = @"您还未上传";
            }else{
                cell.subtitle = [NSString stringWithFormat:@"%lu个",(unsigned long)self.model.album];
            }
        }else if (indexPath.row == 1){//我的视频
            cell.iconName = @"me_myVideo_icon";
            cell.title = @"我的视频";
            if (self.model.video == 0) {
                cell.subtitle = @"您还未上传";
            }else{
                cell.subtitle = [NSString stringWithFormat:@"%lu个",(unsigned long)self.model.video];
            }
        }
    }else if (indexPath.section == 0){//会员
        cell.iconName = @"me_detail_icon";
        cell.title = @"会员";
        cell.subtitle = self.model.merberStatus;
    }
    else if (indexPath.section == 2){//分享给好友
        cell.iconName = @"me_share_icon";
        cell.title = @"分享给好友";
        cell.subtitle = @"";
    }else if (indexPath.section == 3){//我的邀请码
        cell.iconName = @"me_inviteCode_icon";
        cell.title = @"我的邀请码";
        cell.subtitle = self.model.inviteCode;
        cell.isHiddenArrowIcon = YES;
    }else if (indexPath.section == 4){//设置
        cell.iconName = @"me_setting_icon";
        cell.title = @"设置";
        cell.subtitle = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        if (indexPath.row == 0) {//我的相册
            [MGJRouter openURL:kMyPhotoViewController withUserInfo:@{@"isPhoto":@(YES)} completion:nil];
        }else if (indexPath.row == 1){//我的视频
            [MGJRouter openURL:kMyPhotoViewController withUserInfo:@{@"isPhoto":@(NO)} completion:nil];
        }
    }else if (indexPath.section == 0){//会员
        [MGJRouter openURL:kBuyCoinViewController];
    }else if (indexPath.section == 2){//分享给好友
        ShareAlertView *alertView = [ShareAlertView new];
        alertView.type = 2;
        alertView.downloadUrl = kDownloadUrl;
        [alertView showInBottom];
    }else if (indexPath.section == 4){//设置
        [MGJRouter openURL:kSettingViewController];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = Adapt_Height(44);
        [_tableView registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Color(@"F7F7F7");
        [_tableView setContentInset:UIEdgeInsetsMake(Adapt_Height(-32), 0, 0, 0)];
    }
    return _tableView;
}

-(MeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [MeHeaderView new];
    }
    return _headerView;
}

-(MeViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [MeViewModel new];
    }
    return _viewModel;
}
@end
