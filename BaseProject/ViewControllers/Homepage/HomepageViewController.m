//
//  HomepageViewController.m
//  BaseProject
//
//  Created by super on 2019/9/25.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "HomepageViewController.h"
#import "HomepageNavigationView.h"
#import "HomepageTableViewCell.h"
#import "HomepageHintAlertView.h"
#import "HomepageViewModel.h"
#import "LoginViewModel.h"
@interface HomepageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) HomepageNavigationView *naviView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , assign) BOOL isRealPerson;//是否选中真人认证优先
@property (nonatomic , assign) BOOL isMale;//男女性别切换
@property (nonatomic , assign) BOOL isScreenPerson;//女神或大佬是否选中
@property (nonatomic , strong) HomepageViewModel *viewModel;
@property (nonatomic , assign) NSInteger currentPage;
@property (nonatomic , copy) NSString *city;
@property (nonatomic , assign) NSInteger gender;
@end

@implementation HomepageViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(YES)
                     };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self initViews];
    [self setupRefresh];
    [self listenEvents];
    //检测个人信息是否完善
    [self.viewModel checkUserInfo];
    //版本号检测
    [[LoginViewModel new] checkNewVersion];
    
    int isFirst = [[UserDefaults getDataWithKey:@"FirstComeInHomepage"] intValue];
    if (isFirst != 2) {//说明没有弹过
        [[HomepageHintAlertView new] showInCenter];
    }
    
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    if ([CommonTool isNull:userInfo.city]) {
        self.city = @"上海市_上海市_浦东新区";
    }else{
        self.city = userInfo.city;
    }
    
    if (userInfo.sex == 0) {
        self.isMale = NO;
    }else{
        self.isMale = userInfo.sex==2;
    }
    
    [SVProgressHUD show];
    [self.viewModel loadListDataWithCity:self.city gender:self.isMale?1:2 currentPage:self.currentPage];
}

-(void)initViews{
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(KNavigationBar_HEIGHT);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
}

#pragma mark - 集成刷新控件
- (void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self.viewModel loadListDataWithCity:self.city gender:self.isMale?1:2 currentPage:self.currentPage];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self.viewModel loadListDataWithCity:self.city gender:self.isMale?1:2 currentPage:self.currentPage];
    }];
}

-(void)listenEvents{
    Weakify(self);
    //性别筛选结果
    [self.naviView.sexSelectSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.isMale = [x boolValue];
        self.currentPage = 1;
        [SVProgressHUD show];
        [self.viewModel loadListDataWithCity:self.city gender:self.isMale?1:2 currentPage:self.currentPage];
    }];
    
    //常驻城市筛选结果
    [self.naviView.selectCitySignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.city = x;
        self.currentPage = 1;
        [SVProgressHUD show];
        [self.viewModel loadListDataWithCity:self.city gender:self.isMale?1:2 currentPage:self.currentPage];
    }];
    
    [self.viewModel.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        if (self.currentPage == 1) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if ([x intValue] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (self.viewModel.dataArr.count == 0) {
            [self showNoDataViewWithHintMessage:@"暂无数据" iconName:nil];
            [self.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.tableView);
            }];
        }else{
            [self.tableView reloadData];
            [self removeNoDataView];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomepageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepageTableViewCell" forIndexPath:indexPath];
    HomepageItemModel *model = self.viewModel.dataArr[indexPath.row];
    cell.model = model;
    cell.isMale = self.isMale;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomepageItemModel *model = self.viewModel.dataArr[indexPath.row];
    [MGJRouter openURL:kUserDetailViewController withUserInfo:@{@"id":model.id} completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

-(HomepageNavigationView *)naviView{
    if (!_naviView) {
        _naviView = [HomepageNavigationView new];
    }
    return _naviView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = Adapt_Height(111.5);
        [_tableView registerClass:[HomepageTableViewCell class] forCellReuseIdentifier:@"HomepageTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(HomepageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [HomepageViewModel new];
    }
    return _viewModel;
}
@end
