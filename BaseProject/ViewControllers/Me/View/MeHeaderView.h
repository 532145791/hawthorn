//
//  MeHeaderView.h
//  BaseProject
//
//  Created by super on 2019/10/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MeHeaderView : UIView
@property (nonatomic , assign) BOOL isLogined;
@property (nonatomic , strong) MyInfoModel *model;
@end

NS_ASSUME_NONNULL_END
