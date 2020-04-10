//
//  ReportViewController.m
//  BaseProject
//
//  Created by super on 2020/3/3.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "ReportViewController.h"
#import "HomepageViewModel.h"
@interface ReportViewController ()<UITextViewDelegate>
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) UILabel *hintLab;
@property (nonatomic , strong) UIButton *submitBtn;
@end

@implementation ReportViewController

-(void)initData{
    self.confDic = @{kNav_Hidden: @(NO),
                     kNav_Title: @"举报",
                     kNav_LeftButton: @(NavBarItemTypeBack)
                     };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self listenEvents];
}

-(void)listenEvents{
    Weakify(self);
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        Strongify(self);
        [[HomepageViewModel new] reportWithUserId:self.params[@"id"] content:self.textView.text];
    }];
}

-(void)initViews{
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Adapt_Height(15));
        make.width.mas_equalTo(Adapt_Width(343));
        make.height.mas_equalTo(Adapt_Height(198));
        make.centerX.equalTo(self.view);
    }];
    
    [self.bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(Adapt_Height(158));
    }];
    
    [self.bgView addSubview:self.hintLab];
    [self.hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(Adapt_Width(15));
        make.right.mas_equalTo(Adapt_Width(-12));
        make.height.mas_equalTo(Adapt_Height(40));
    }];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(Adapt_Height(-10));
        make.width.mas_equalTo(Adapt_Width(335));
        make.height.mas_equalTo(Adapt_Height(44));
        make.centerX.equalTo(self.view);
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        // 禁止系统表情的输入
        NSString *text = [CommonTool disable_EmojiString:[textView text]];
        if (![text isEqualToString:textView.text]) {
            NSRange textRange = [textView selectedRange];
            textView.text = text;
            [textView setSelectedRange:textRange];
        }
    }
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView getViewWithBgColorHex:@"efefef"];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = Color(@"e1e1e1").CGColor;
        _bgView.layer.borderWidth = 1;
    }
    return _bgView;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.textColor = [UIColor colorWithHexString:kColor_333333];
        _textView.font = Font_Regular(15);
        _textView.textAlignment = NSTextAlignmentLeft;
        [_textView setPlaceholderWithText:@"请在此处描述举报内容" Color:[UIColor colorWithHexString:@"a6a6a6"]];
        _textView.delegate = self;
        _textView.backgroundColor = Color(kColor_White);
    }
    return _textView;
}

-(UILabel *)hintLab{
    if (!_hintLab) {
        _hintLab = [UIView getLabelWithFontSize:Font_Regular(10) textColorHex:kColor_999999];
        _hintLab.numberOfLines = 2;
        _hintLab.text = @"请不要恶意举报，否则将做封号处理\n我们将会在72小时内处理您的举报内容";
        _hintLab.textAlignment = NSTextAlignmentLeft;
    }
    return _hintLab;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIView getButtonWithFontSize:Font_Medium(20) textColorHex:kColor_White backGroundColor:kColor_Theme];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 22;
    }
    return _submitBtn;
}
@end
