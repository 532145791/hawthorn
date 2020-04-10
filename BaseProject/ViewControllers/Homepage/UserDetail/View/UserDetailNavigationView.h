//
//  UserDetailNavigationView.h
//  BaseProject
//
//  Created by super on 2020/3/9.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailNavigationView : UIView
@property (nonatomic , assign) BOOL isShowWhiteIcon;
@property (nonatomic , strong) RACSubject *reportSignal;
@property (nonatomic , copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
