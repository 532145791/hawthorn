//
//  UITextView+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
- (void)insertAttributedText:(NSAttributedString *)text
{
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    // 拼接之前的文字（图片和普通文字）
    [attributedText appendAttributedString:self.attributedText];
    
    // 拼接其他文字
    NSUInteger loc = self.selectedRange.location;
//    [attributedText insertAttributedString:text atIndex:loc];
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    // 调用外面传进来的代码
    if (settingBlock) {
        settingBlock(attributedText);
    }
    
    self.attributedText = attributedText;
    
    // 移除光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}

+ (void)load {
    
    // 获取类方法 class_getClassMethod
    // 获取对象方法 class_getInstanceMethod
    
    Method setFontMethod = class_getInstanceMethod(self, @selector(setFont:));
    Method was_setFontMethod = class_getInstanceMethod(self, @selector(was_setFont:));
    
    // 交换方法的实现
    method_exchangeImplementations(setFontMethod, was_setFontMethod);
}

- (void)setPlaceholderWithText:(NSString *)text Color:(UIColor *)color{
    //设置占位label
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = self.font;
    label.textColor = color;
    label.numberOfLines = 0;
    
    [self addSubview:label];
    [self setValue:label forKey:@"_placeholderLabel"];
    
}

- (void)was_setFont:(UIFont *)font{
    //调用原方法 setFont:
    [self was_setFont:font];
    //设置占位字符串的font
    UILabel *label = [self valueForKey:@"_placeholderLabel"];
    label.font = font;
}
@end
