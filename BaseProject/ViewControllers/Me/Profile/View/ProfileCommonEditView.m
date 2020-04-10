//
//  ProfileCommonEditView.m
//  BaseProject
//
//  Created by super on 2020/3/6.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "ProfileCommonEditView.h"
#import <BRAddressPickerView.h>
#import <BRStringPickerView.h>
@interface ProfileCommonEditView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIImageView *userIcon;
@property (nonatomic , strong) UIView *line;
@end

@implementation ProfileCommonEditView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = Color(kColor_White);
        [self initViews];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.userIcon.image = image;
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.textField.text = content;
}

-(void)setUserIconUrl:(NSString *)userIconUrl{
    _userIconUrl = userIconUrl;
    [self.userIcon setImageWithURL:[NSURL URLWithString:userIconUrl] placeholder:[UIImage imageNamed:@"user_default_icon"]];
}

-(void)setIsHiddenLine:(BOOL)isHiddenLine{
    _isHiddenLine = isHiddenLine;
    self.line.hidden = isHiddenLine;
}

-(void)setType:(EditCommonViewType)type{
    _type = type;
    switch (type) {
        case EditCommonViewTypeInput:
        {
            [self addSubview:self.textField];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapt_Width(130));
                make.centerY.height.equalTo(self);
                make.right.mas_equalTo(Adapt_Width(-10));
            }];
        }
            break;
        case EditCommonViewTypeImage:
        {
            [self addSubview:self.userIcon];
            [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(Adapt_Width(-29));
                make.centerY.equalTo(self);
                make.width.height.mas_equalTo(Adapt_Width(40));
            }];
            
            WS(weakSelf)
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                [weakSelf tapAddPicture];
            }];
            [self addGestureRecognizer:tap];
        }
            break;
        case EditCommonViewTypeSelect:
        {
            [self addSubview:self.textField];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Adapt_Width(130));
                make.centerY.height.equalTo(self);
                make.right.mas_equalTo(Adapt_Width(-10));
            }];
            self.textField.userInteractionEnabled = NO;
            
            WS(weakSelf)
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                [[IQKeyboardManager sharedManager] resignFirstResponder];
                if ([weakSelf.title isEqualToString:@"常驻城市"]) {
                    [weakSelf showAddressPicker];
                }else if ([weakSelf.title isEqualToString:@"爱好"]) {
                    [weakSelf showHobbyPicker];
                }else if ([weakSelf.title isEqualToString:@"职业"]) {
                    [weakSelf showOccupationPicker];
                }else if ([weakSelf.title isEqualToString:@"年龄"]) {
                    [weakSelf showAgePicker];
                }else if ([weakSelf.title isEqualToString:@"身高"]) {
                    [weakSelf showHeightPicker];
                }else if ([weakSelf.title isEqualToString:@"体重"]) {
                    [weakSelf showWeightPicker];
                }else if ([weakSelf.title isEqualToString:@"性别"]) {
                    [weakSelf showSexPicker];
                }
            }];
            [self addGestureRecognizer:tap];
        }
            break;
        default:
            break;
    }
}

-(void)initViews{
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(22));
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Adapt_Width(17));
        make.bottom.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

//选择常驻城市
-(void)showAddressPicker{
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    if (userInfo.city) {
        NSArray *arr = [userInfo.city componentsSeparatedByString:@"_"];
        self.province = arr[0];
        self.city = arr[1];
        self.area = arr[2];
    }else{
        self.province = @"上海市";
        self.city = @"上海市";
        self.area = @"浦东新区";
    }
    
    BRAddressPickerView *addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeArea];
    addressPicker.title = @"选择常驻城市";
    addressPicker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    addressPicker.defaultSelectedArr = @[self.province,self.city,self.area];
    addressPicker.isAutoSelect = YES;
    [addressPicker show];
    WS(weakSelf);
    addressPicker.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        weakSelf.province = province.name;
        weakSelf.city = city.name;
        weakSelf.area = area.name;
        weakSelf.textField.text = [NSString stringWithFormat:@"%@%@%@",weakSelf.province,weakSelf.city,weakSelf.area];
        [weakSelf.resultSignal sendNext:@(1)];
    };
}

//选择爱好
-(void)showHobbyPicker{
    BRStringPickerView *picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    picker.title = @"选择爱好";
    picker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    picker.dataSourceArr = @[@"唱歌",@"看电影",@"吃美食",@"逛街",@"旅游",@"做饭",@"玩游戏",@"其他"];
    picker.selectValue = @"唱歌";
    [picker show];
    WS(weakSelf)
    picker.resultModelBlock = ^(BRResultModel *resultModel) {
        weakSelf.textField.text = resultModel.selectValue;
        [weakSelf.resultSignal sendNext:resultModel.selectValue];
    };
}

//选择职业
-(void)showOccupationPicker{
    BRStringPickerView *picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    picker.title = @"选择职业";
    picker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    picker.dataSourceArr = @[@"上班族",@"自由职业者",@"个体经营",@"老板",@"学生",@"其他"];
    picker.selectValue = @"上班族";
    [picker show];
    WS(weakSelf)
    picker.resultModelBlock = ^(BRResultModel *resultModel) {
        weakSelf.textField.text = resultModel.selectValue;
        [weakSelf.resultSignal sendNext:resultModel.selectValue];
    };
}

//选择性别
-(void)showSexPicker{
    BRStringPickerView *picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    picker.title = @"选择性别";
    picker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    picker.dataSourceArr = @[@"男",@"女"];
    picker.selectValue = @"男";
    [picker show];
    WS(weakSelf)
    picker.resultModelBlock = ^(BRResultModel *resultModel) {
        weakSelf.textField.text = resultModel.selectValue;
        [weakSelf.resultSignal sendNext:resultModel.selectValue];
    };
}

//选择年龄
-(void)showAgePicker{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 18; i <= 50; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    BRStringPickerView *picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    picker.title = @"选择年龄";
    picker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    picker.dataSourceArr = arr;
    picker.selectValue = arr.firstObject;
    [picker show];
    WS(weakSelf)
    picker.resultModelBlock = ^(BRResultModel *resultModel) {
        weakSelf.textField.text = resultModel.selectValue;
        [weakSelf.resultSignal sendNext:resultModel.selectValue];
    };
}

//选择身高
-(void)showHeightPicker{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 140; i <= 220; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    BRStringPickerView *picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    picker.title = @"选择身高(CM)";
    picker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    picker.dataSourceArr = arr;
    picker.selectValue = arr.firstObject;
    [picker show];
    WS(weakSelf)
    picker.resultModelBlock = ^(BRResultModel *resultModel) {
        weakSelf.textField.text = [resultModel.selectValue stringByAppendingString:@"CM"];
        [weakSelf.resultSignal sendNext:resultModel.selectValue];
    };
}

//选择体重
-(void)showWeightPicker{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 35; i <= 100; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    BRStringPickerView *picker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    picker.title = @"选择体重(KG)";
    picker.pickerStyle = [BRPickerStyle pickerStyleWithThemeColor:Color(kColor_Theme)];
    picker.dataSourceArr = arr;
    picker.selectValue = arr.firstObject;
    [picker show];
    WS(weakSelf)
    picker.resultModelBlock = ^(BRResultModel *resultModel) {
        weakSelf.textField.text = [resultModel.selectValue stringByAppendingString:@"KG"];
        [weakSelf.resultSignal sendNext:resultModel.selectValue];
    };
}

-(void)tapAddPicture{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self tapCemara];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self tapPhoto];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [[CommonTool currentViewController] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 拍照
-(void)tapCemara{
    UIImagePickerController *photoPicker = [UIImagePickerController new];
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    photoPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[CommonTool currentViewController] presentViewController:photoPicker animated:YES completion:nil];
}

#pragma mark - 从相册中选择
-(void)tapPhoto{
    UIImagePickerController *photoPicker = [UIImagePickerController new];
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[CommonTool currentViewController] presentViewController:photoPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.userIcon.image = image;
    [self.resultSignal sendNext:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UIView getLabelWithFontSize:Font_Regular(15) textColorHex:kColor_333333];
    }
    return _titleLab;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [UIView getTextFieldWithFontSize:Font_Regular(15) textColorHex:kColor_999999 placeHolder:@"未填写"];
        _textField.textAlignment = NSTextAlignmentLeft;
    }
    return _textField;
}

-(UIImageView *)userIcon{
    if (!_userIcon) {
        _userIcon = [UIView getImageViewWithImageName:@"user_default_icon"];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userIcon;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView getViewWithBgColorHex:kColor_eeeeee];
    }
    return _line;
}

-(RACSubject *)resultSignal{
    if (!_resultSignal) {
        _resultSignal = [RACSubject subject];
    }
    return _resultSignal;
}

@end
