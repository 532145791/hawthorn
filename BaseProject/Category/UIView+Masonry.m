//
//  UIView+Masonry.m
//  BaseProject
//
//  Created by super on 2018/4/3.
//  Copyright © 2018年 lengchao. All rights reserved.
//

#import "UIView+Masonry.h"

@implementation UIView (Masonry)

+(UIView *)getViewWithBgColorHex:(NSString *)colorHex{
    UIView *view = [[UIView alloc] init];
    if (colorHex) {
        view.backgroundColor = [UIColor colorWithHexString:colorHex];
    }
    return view;
}

+(UIButton *)getButtonWithFontSize:(UIFont *)font textColorHex:(NSString *)colorHex backGroundColor:(NSString *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (font) {
        btn.titleLabel.font = font;
    }
    
    if (colorHex) {
        [btn setTitleColor:[UIColor colorWithHexString:colorHex] forState:UIControlStateNormal];
    }
    
    if (color) {
        [btn setBackgroundColor:[UIColor colorWithHexString:color]];
    }
    
    return btn;
}

+(UIImageView *)getImageViewWithImageName:(NSString *)imageName
{
    UIImageView *imageView;
    if (!imageName || [imageName isEqualToString:@""]) {
        imageView = [[UIImageView alloc] init];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    return imageView;
}

+(UILabel *)getLabelWithFontSize:(UIFont *)font textColorHex:(NSString *)colorHex{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = [UIColor colorWithHexString:colorHex];
    return label;
}

+(UITextField *)getTextFieldWithFontSize:(UIFont *)font textColorHex:(NSString *)colorHex placeHolder:(NSString *)placeHolder{
    UITextField *textfield = [[UITextField alloc] init];
    textfield.font = font;
    textfield.textColor = [UIColor colorWithHexString:colorHex];
    textfield.placeholder = placeHolder;
    if (placeHolder) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:placeHolder];
        [attri addAttribute:NSForegroundColorAttributeName value:Color(@"bbbbbb") range:NSMakeRange(0, placeHolder.length)];
        [attri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, placeHolder.length)];
        textfield.attributedPlaceholder = attri;
    }
    return textfield;
}
@end
