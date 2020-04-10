//
//  BindCardView.h
//  BaseProject
//
//  Created by super on 2020/3/12.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BindCardView : UIView
@property (nonatomic , assign) BOOL isHiddenLine;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *placeholder;
@property (nonatomic , copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
