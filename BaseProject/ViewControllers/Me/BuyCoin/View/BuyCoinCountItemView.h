//
//  BuyCoinCountItemView.h
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BuyCoinCountItemView : UIView
@property (nonatomic , assign) BOOL isSelect;
@property (nonatomic , strong) MemberItemDetailModel *model;
@end

NS_ASSUME_NONNULL_END
