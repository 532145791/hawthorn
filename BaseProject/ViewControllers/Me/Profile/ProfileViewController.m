//
//  ProfileViewController.m
//  BaseProject
//
//  Created by super on 2020/3/6.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCommonEditView.h"
#import "MeViewModel.h"
#import "QiniuUploadTool.h"
@interface ProfileViewController ()
@property (nonatomic , strong) ProfileCommonEditView *userIconView;//用户头像
@property (nonatomic , strong) ProfileCommonEditView *nicknameView;//昵称
@property (nonatomic , strong) ProfileCommonEditView *sexView;//性别
@property (nonatomic , strong) ProfileCommonEditView *cityView;//常驻城市
@property (nonatomic , strong) ProfileCommonEditView *birthdayView;//年龄
@property (nonatomic , strong) ProfileCommonEditView *hobbyView;//爱好
@property (nonatomic , strong) ProfileCommonEditView *occupationView;//职业
@property (nonatomic , strong) ProfileCommonEditView *wxView;//微信
@property (nonatomic , strong) ProfileCommonEditView *heightView;//身高
@property (nonatomic , strong) ProfileCommonEditView *weightView;//体重

@property (nonatomic , strong) UIImage *userIcon;
@property (nonatomic , copy) NSString *userIconPath;
@property (nonatomic , copy) NSString *nickName;
@property (nonatomic , copy) NSString *city;//市
@property (nonatomic , assign) int sex;
@property (nonatomic , copy) NSString *age;
@property (nonatomic , copy) NSString *hobby;
@property (nonatomic , copy) NSString *occupation;
@property (nonatomic , copy) NSString *wx;
@property (nonatomic , copy) NSString *height;
@property (nonatomic , copy) NSString *weight;
@property (nonatomic , strong) MeViewModel *viewModel;
@property (nonatomic , strong) MyInfoModel *myInfoModel;
@end

@implementation ProfileViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title: @"个人资料",
                     kNav_LeftButton: @(NavBarItemTypeBack),
                     kNav_RightButtonTitle: @"提交"
                    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Color(@"f7f7f7");
    self.scrollView.backgroundColor = Color(@"f7f7f7");
    [self initViews];
    [self listenEvents];
    
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    if (![CommonTool isNull:userInfo.nickname]) {//说明提交过资料
        [self loadData];
    }
}

-(void)loadData{
    [self.viewModel getMyInfoData];
}

-(void)listenEvents{
    Weakify(self);
    //获取个人信息成功
    [self.viewModel.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.myInfoModel = x;
        self.userIconView.userIconUrl = self.myInfoModel.headPath;
        self.nicknameView.content = self.myInfoModel.nickname;
        NSArray *cityArr = [self.myInfoModel.city componentsSeparatedByString:@"_"];
        self.cityView.province = cityArr[0];
        self.cityView.city = cityArr[1];
        self.cityView.area = cityArr[2];
        self.cityView.content = [NSString stringWithFormat:@"%@%@%@",self.cityView.province,self.cityView.city,self.cityView.area];
        self.birthdayView.content = self.myInfoModel.age;
        self.sexView.content = self.myInfoModel.gender==1?@"男":@"女";
        self.hobbyView.content = self.myInfoModel.likes;
        self.occupationView.content = self.myInfoModel.occupation;
        self.wxView.content = self.myInfoModel.weixin;
        self.heightView.content = [self.myInfoModel.height stringByAppendingString:@"CM"];
        self.weightView.content = [self.myInfoModel.weight stringByAppendingString:@"KG"];
        
        self.userIconPath = self.myInfoModel.headPath;
        self.nickName = self.myInfoModel.nickname;
        self.city = [NSString stringWithFormat:@"%@_%@_%@",self.cityView.province,self.cityView.city,self.cityView.area];
        self.age = self.myInfoModel.age;
        self.sex = self.myInfoModel.gender;
        self.hobby = self.myInfoModel.likes;
        self.occupation = self.myInfoModel.occupation;
        self.wx = self.myInfoModel.weixin;
        self.height = self.myInfoModel.height;
        self.weight = self.myInfoModel.weight;
    }];
    
    //选择完图片
    [self.userIconView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.userIcon = x;
        [QiniuUploadTool uploadImages:@[x] isAsync:YES callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
            [SVProgressHUD dismiss];
            self.userIconPath = keys[0];
        }];
    }];
    
    [self.nicknameView.textField.rac_textSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.nickName = x;
    }];
    
    [self.cityView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.city = [NSString stringWithFormat:@"%@_%@_%@",self.cityView.province,self.cityView.city,self.cityView.area];
    }];
    
    [self.birthdayView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.age = x;
    }];
    
    [self.sexView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.sex = [x isEqualToString:@"男"]?1:2;
    }];
    
    [self.hobbyView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.hobby = x;
    }];
    
    [self.occupationView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.occupation = x;
    }];
    
    [self.wxView.textField.rac_textSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.wx = x;
    }];
    
    [self.heightView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.height = x;
    }];
    
    [self.weightView.resultSignal subscribeNext:^(id  _Nullable x) {
        Strongify(self);
        self.weight = x;
    }];
}

-(void)rightNavigationItemsDidClicked:(id)sender{
    if ([CommonTool isNull:self.userIconPath]||[CommonTool isNull:self.nickName]||[CommonTool isNull:self.city]||[CommonTool isNull:self.age]||[CommonTool isNull:self.hobby]||[CommonTool isNull:self.occupation]||[CommonTool isNull:self.wx]||[CommonTool isNull:self.height]||[CommonTool isNull:self.weight]||self.sex==0) {
        [SVProgressHUD showMessageWithStatus:@"请完善信息"];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.userIconPath forKey:@"headPath"];
        [params setValue:self.nickName forKey:@"nickname"];
        [params setValue:@(self.sex) forKey:@"gender"];
        [params setValue:self.city forKey:@"city"];
        [params setValue:self.age forKey:@"age"];
        [params setValue:self.hobby forKey:@"likes"];
        [params setValue:self.occupation forKey:@"occupation"];
        [params setValue:self.wx forKey:@"weixin"];
        [params setValue:self.height forKey:@"height"];
        [params setValue:self.weight forKey:@"weight"];
        [[MeViewModel new] commitMyInfoWithParams:params];
    }
}

-(void)initViews{
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView addSubview:self.userIconView];
    [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(10));
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(79));
    }];
    
    [self.containerView addSubview:self.nicknameView];
    [self.nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIconView.mas_bottom).offset(Adapt_Height(10));
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.sexView];
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.cityView];
    [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.birthdayView];
    [self.birthdayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.hobbyView];
    [self.hobbyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.birthdayView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.occupationView];
    [self.occupationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hobbyView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.wxView];
    [self.wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.occupationView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.heightView];
    [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wxView.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
    
    [self.containerView addSubview:self.weightView];
    [self.weightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heightView.mas_bottom);
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(Adapt_Height(44));
    }];
}

-(ProfileCommonEditView *)userIconView{
    if (!_userIconView) {
        _userIconView = [ProfileCommonEditView new];
        _userIconView.title = @"头像";
        _userIconView.type = EditCommonViewTypeImage;
        _userIconView.isHiddenLine = YES;
    }
    return _userIconView;
}

-(ProfileCommonEditView *)nicknameView{
    if (!_nicknameView) {
        _nicknameView = [ProfileCommonEditView new];
        _nicknameView.title = @"昵称";
        _nicknameView.type = EditCommonViewTypeInput;
        _nicknameView.placeholder = @"请输入您的昵称";
    }
    return _nicknameView;
}

-(ProfileCommonEditView *)sexView{
    if (!_sexView) {
        _sexView = [ProfileCommonEditView new];
        _sexView.title = @"性别";
        _sexView.type = EditCommonViewTypeSelect;
        _sexView.placeholder = @"请选择您的性别";
    }
    return _sexView;
}

-(ProfileCommonEditView *)cityView{
    if (!_cityView) {
        _cityView = [ProfileCommonEditView new];
        _cityView.title = @"常驻城市";
        _cityView.type = EditCommonViewTypeSelect;
        _cityView.placeholder = @"请选择您的常驻城市";
    }
    return _cityView;
}

-(ProfileCommonEditView *)birthdayView{
    if (!_birthdayView) {
        _birthdayView = [ProfileCommonEditView new];
        _birthdayView.title = @"年龄";
        _birthdayView.type = EditCommonViewTypeSelect;
        _birthdayView.placeholder = @"请选择您的真实年龄";
    }
    return _birthdayView;
}

-(ProfileCommonEditView *)hobbyView{
    if (!_hobbyView) {
        _hobbyView = [ProfileCommonEditView new];
        _hobbyView.title = @"爱好";
        _hobbyView.type = EditCommonViewTypeSelect;
        _hobbyView.placeholder = @"请选择您的爱好";
    }
    return _hobbyView;
}

-(ProfileCommonEditView *)occupationView{
    if (!_occupationView) {
        _occupationView = [ProfileCommonEditView new];
        _occupationView.title = @"职业";
        _occupationView.type = EditCommonViewTypeSelect;
        _occupationView.placeholder = @"请选择您的职业";
    }
    return _occupationView;
}

-(ProfileCommonEditView *)wxView{
    if (!_wxView) {
        _wxView = [ProfileCommonEditView new];
        _wxView.title = @"微信";
        _wxView.type = EditCommonViewTypeInput;
        _wxView.placeholder = @"请输入您的微信号";
    }
    return _wxView;
}

-(ProfileCommonEditView *)heightView{
    if (!_heightView) {
        _heightView = [ProfileCommonEditView new];
        _heightView.title = @"身高";
        _heightView.type = EditCommonViewTypeSelect;
        _heightView.placeholder = @"请选择您的身高";
    }
    return _heightView;
}

-(ProfileCommonEditView *)weightView{
    if (!_weightView) {
        _weightView = [ProfileCommonEditView new];
        _weightView.title = @"体重";
        _weightView.type = EditCommonViewTypeSelect;
        _weightView.isHiddenLine = YES;
        _weightView.placeholder = @"请选择您的体重";
    }
    return _weightView;
}

-(MeViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [MeViewModel new];
    }
    return _viewModel;
}

@end
