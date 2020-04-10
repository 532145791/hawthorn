//
//  MyPhotoViewController.m
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "MyPhotoViewController.h"
#import "MyPhotoCollectionViewCell.h"
#import "VideoPlayView.h"
#import "VideoViewModel.h"
#import "MyPhotoModel.h"
#import "MeViewModel.h"
#import "QiniuUploadTool.h"
#import "PreviewBigImageTool.h"
#import "GQImageVideoViewer.h"
@interface MyPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIButton *uploadBtn;
@property (nonatomic , assign) BOOL isEditting;
@property (nonatomic , assign) BOOL isPhoto;//yes-照片类型的  no-视频类型的
@property (nonatomic , strong) NSMutableArray *deleteArr;//要删除的数据
@property (nonatomic , strong) NSMutableArray *dataArr;
@property (nonatomic , strong) VideoViewModel *videoViewModel;
@property (nonatomic , strong) MeViewModel *meViewModel;
@property (nonatomic , strong) NSMutableArray *imgUrlArr;
@property (nonatomic , strong) NSMutableArray *videoUrlArr;
@end

@implementation MyPhotoViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title: @"我的相册",
                     kNav_LeftButton: @(NavBarItemTypeBack),
                     kNav_RightButtonTitle: @"删除"
                     };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color(kColor_White);
    [self initViews];
    [self listenEvents];
    self.isPhoto = [self.params[@"isPhoto"] boolValue];
    [self loadData];
}

-(void)initViews{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(Adapt_Height(-54));
    }];
    
    [self.view addSubview:self.uploadBtn];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(Adapt_Height(-10));
        make.width.mas_equalTo(Adapt_Width(335));
        make.height.mas_equalTo(Adapt_Height(44));
    }];
}

-(void)listenEvents{
    Weakify(self);
    //点击立即上传
    [[self.uploadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        if (self.isPhoto) {//上传照片
            [self.videoViewModel chooseLocalPhoto];
        }else{//上传视频
            [self.videoViewModel chooseVideo];
        }
    }];
    
    //视频或照片上传成功的通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUploadFileSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Strongify(self);
        [self.meViewModel getVideoOrAlbumWithType:self.isPhoto?2:1];
    }];
    
    [self.meViewModel.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        if (self.meViewModel.dataArr.count == 0) {
            [self showNoDataViewWithHintMessage:@"暂无数据" iconName:nil];
            [self.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.collectionView);
            }];
        }else{
            [self.collectionView reloadData];
            [self removeNoDataView];
        }
        
        if (self.isPhoto) {
            if (self.imgUrlArr.count > 0) {
                [self.imgUrlArr removeAllObjects];
            }
            for (MyVideoOrAlbumItemModel *model in self.meViewModel.dataArr) {
                [self.imgUrlArr addObject:model.path];
            }
        }else{
            if (self.videoUrlArr.count > 0) {
                [self.videoUrlArr removeAllObjects];
            }
            for (MyVideoOrAlbumItemModel *model in self.meViewModel.dataArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:@(NO) forKey:@"GQIsImageURL"];
                [dic setObject:model.path forKey:@"GQURLString"];
                [self.videoUrlArr addObject:dic];
            }
        }
    }];
}

//加载数据
-(void)loadData{
    [self.meViewModel getVideoOrAlbumWithType:self.isPhoto?2:1];
}

-(void)setIsPhoto:(BOOL)isPhoto{
    _isPhoto = isPhoto;
    [self resetNavigationTitle:isPhoto?@"我的相册":@"我的视频"];
}

-(void)rightNavigationItemsDidClicked:(id)sender{
    if (self.isEditting) {
        //在这里调用删除接口
        if (self.deleteArr.count > 0) {
            NSMutableArray *urlArr = [NSMutableArray array];
            for (MyVideoOrAlbumItemModel *model in self.deleteArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:model.id forKey:@"id"];
                [urlArr addObject:dic];
            }
            WS(weakSelf);
            [QiniuUploadTool deleteFileWithObjectKeyArr:urlArr callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
                [weakSelf.meViewModel.dataArr removeObjectsInArray:weakSelf.deleteArr];
                [weakSelf.collectionView reloadData];
                [weakSelf.deleteArr removeAllObjects];
                if (weakSelf.meViewModel.dataArr.count == 0) {
                    [weakSelf showNoDataViewWithHintMessage:@"暂无数据" iconName:nil];
                    [weakSelf.noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(weakSelf.collectionView);
                    }];
                }else{
                    [weakSelf removeNoDataView];
                }
            }];
        }else{
            [SVProgressHUD showMessageWithStatus:@"请选择您要删除的照片或视频"];
        }
    }else{
        //开始选择要删除的内容
        [self.deleteArr removeAllObjects];
    }
    
    self.isEditting = !self.isEditting;
}

-(void)setIsEditting:(BOOL)isEditting{
    _isEditting = isEditting;
    [self resetNavigationItemWithRightTitle:isEditting?@"完成":@"删除" font:Font_Regular(13) titleColor:Color(@"313131")];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView delegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.meViewModel.dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.isPhoto = self.isPhoto;
    MyVideoOrAlbumItemModel *model = self.meViewModel.dataArr[indexPath.row];
    cell.imgUrl = model.path;
    if (!self.isPhoto) {
        cell.imgUrl = [model.path stringByAppendingString:@"?vframe/jpg/offset/1"];
    }
    
    if (self.isEditting) {
        cell.isShowSelectIcon = [self.deleteArr containsObject:model];
    }else{
        cell.isShowSelectIcon = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MyVideoOrAlbumItemModel *model = self.meViewModel.dataArr[indexPath.row];
    if (self.isEditting) {
        if ([self.deleteArr containsObject:model]) {
            [self.deleteArr removeObject:model];
        }else{
            [self.deleteArr addObject:model];
        }
        [self.collectionView reloadData];
    }else{
        if (!self.isPhoto) {
            [PreviewBigImageTool showWithVideoUrlArr:self.videoUrlArr inView:self.view.window selectIndex:indexPath.row];
        }else{
            [PreviewBigImageTool showWithImageUrlArr:self.imgUrlArr inView:self.view.window selectIndex:indexPath.row];
        }
    }
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(Adapt_Width(357/3), Adapt_Width(357/3));
        layout.minimumLineSpacing = Adapt_Width(4);
        layout.minimumInteritemSpacing = Adapt_Width(4);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = Color(kColor_White);
        [_collectionView registerClass:[MyPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MyPhotoCollectionViewCell"];
        _collectionView.contentInset = UIEdgeInsetsMake(Adapt_Height(7), Adapt_Width(5), 0, Adapt_Width(5));
    }
    return _collectionView;
}

-(UIButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = [UIView getButtonWithFontSize:Font_Medium(17) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_uploadBtn setTitle:@"立即上传" forState:UIControlStateNormal];
        _uploadBtn.layer.masksToBounds = YES;
        _uploadBtn.layer.cornerRadius = Adapt_Height(22);
    }
    return _uploadBtn;
}

-(VideoViewModel *)videoViewModel{
    if (!_videoViewModel) {
        _videoViewModel = [VideoViewModel new];
    }
    return _videoViewModel;
}

-(NSMutableArray *)deleteArr{
    if (!_deleteArr) {
        _deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(MeViewModel *)meViewModel{
    if (!_meViewModel) {
        _meViewModel = [MeViewModel new];
    }
    return _meViewModel;
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
