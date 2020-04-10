//
//  UIView+Masonry.h
//  BaseProject
//
//  Created by super on 2018/4/3.
//  Copyright © 2018年 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Masonry)

/**
 *  实例化一个UIView，省去每次都要写很多重复的代码
 *
 *  @param colorHex  颜色
 *
 *  @return UILabel
 */
+(UIView *)getViewWithBgColorHex:(NSString *)colorHex;

/**
 *  获取一个button
 *
 *  @param font             title的font
 *  @param colorHex         title的色值
 *  @param color            背景色
 *
 *  @return UIButton
 */
+(UIButton *)getButtonWithFontSize:(UIFont *)font textColorHex:(NSString *)colorHex backGroundColor:(NSString *)color;

/**
 *  实例化一个UIImageView
 *
 *  @param imageName 图片名
 *
 *  @return UIImageView
 */
+(UIImageView *)getImageViewWithImageName:(NSString *)imageName;

/**
 *  实例化一个UILabel
 *
 *  @param font         fontsize
 *  @param colorHex     color
 *  @return UILabel
 */
+(UILabel *)getLabelWithFontSize:(UIFont *)font textColorHex:(NSString *)colorHex;


/**
 实例化一个UITextfield
 
 @param font 字体
 @param colorHex 字体颜色
 @param placeHolder 水印
 @return UITextfield
 */
+(UITextField *)getTextFieldWithFontSize:(UIFont *)font textColorHex:(NSString *)colorHex placeHolder:(NSString *)placeHolder;
@end
