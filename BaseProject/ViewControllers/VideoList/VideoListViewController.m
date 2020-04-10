//
//  VideoListViewController.m
//  BaseProject
//
//  Created by super on 2020/1/19.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoListNavigationView.h"
#import "VideoViewModel.h"
#import "VideoListCollectionViewCell.h"
#import "VideoUploadAlertView.h"
#import "PreviewBigImageTool.h"
@interface VideoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) VideoListNavigationView *naviView;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) VideoViewModel *viewModel;
@property (nonatomic , strong) VideoUploadAlertView *uploadAlertView;
@property (nonatomic , assign) NSInteger currentPage;
@property (nonatomic , assign) BOOL isMale;//男女性别切换
@end

@implementation VideoListViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(YES)
                     };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self listenEvents];
    [self setupRefresh];
    
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    if (userInfo.sex == 0) {
        self.isMale = NO;
    }else{
        self.isMale = userInfo.sex==2;
    }
    
    [SVProgressHUD show];
    self.currentPage = 1;
    [self.viewModel loadListDataWithGender:self.isMale?1:2 currentPage:self.currentPage];
}

#pragma mark - 集成刷新控件
- (void)setupRefresh{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self.viewModel loadListDataWithGender:self.isMale?1:2 currentPage:self.currentPage];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self.viewModel loadListDataWithGender:self.isMale?1:2 currentPage:self.currentPage];
    }];
}

-(void)initViews{
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(KNavigationBar_HEIGHT);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

-(void)listenEvents{
    Weakify(self);
    //开始选择本地视频上传
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kSelectLocalVideo object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        [self.viewModel chooseVideo];
    }];
    
    //视频或照片上传成功的通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUploadFileSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        self.currentPage = 1;
        [SVProgressHUD show];
        [self.viewModel loadListDataWithGender:self.isMale?1:2 currentPage:self.currentPage];
    }];
    
    //性别筛选结果
    [self.naviView.sexSelectSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.isMale = [x boolValue];
        self.currentPage = 1;
        [SVProgressHUD show];
        [self.viewModel loadListDataWithGender:self.isMale?1:2 currentPage:self.currentPage];
    }];
    
    //加载列表数据回调
    [self.viewModel.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        if (self.currentPage == 1) {
            [self.collectionView.mj_header endRefreshing];
        }
        
        if ([x intValue] == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        
        if (self.viewModel.dataArr.count == 0) {
            [self showNoDataViewWithHintMessage:@"暂无数据" iconName:nil];
            [self.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.collectionView);
            }];
        }else{
            [self.collectionView reloadData];
            [self removeNoDataView];
        }
    }];
}

#pragma mark - UICollectionView delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoListCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.viewModel.dataArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoItemModel *model = self.viewModel.dataArr[indexPath.row];
    NSArray *arr = @[@{@"GQIsImageURL":@(NO),@"GQURLString":model.path}];
    [PreviewBigImageTool showWithVideoUrlArr:arr inView:self.view.window selectIndex:0];
}

-(VideoListNavigationView *)naviView{
    if (!_naviView) {
        _naviView = [VideoListNavigationView new];
    }
    return _naviView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(Adapt_Width(175.5), Adapt_Width(274));
        layout.minimumLineSpacing = Adapt_Width(8);
        layout.minimumInteritemSpacing = Adapt_Width(8);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = Color(kColor_White);
        [_collectionView registerClass:[VideoListCollectionViewCell class] forCellWithReuseIdentifier:@"VideoListCollectionViewCell"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, Adapt_Width(8), 0, Adapt_Width(8));
    }
    return _collectionView;
}

-(VideoViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [VideoViewModel new];
    }
    return _viewModel;
}

-(VideoUploadAlertView *)uploadAlertView{
    if (!_uploadAlertView) {
        _uploadAlertView = [VideoUploadAlertView new];
    }
    return _uploadAlertView;
}
@end
