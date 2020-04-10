//
//  BuyCoinBottomView.h
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , BuyCoinBottomTypeViewType) {
    BuyCoinBottomTypeViewTypeWX = 0 , //微信
    BuyCoinBottomTypeViewTypeZFB , //支付宝
};

@interface BuyCoinBottomTypeView : UIView
@property (nonatomic , assign) BuyCoinBottomTypeViewType type;
@property (nonatomic , assign) BOOL isSelectWX;
@end

@interface BuyCoinBottomPayView : UIView
@property (nonatomic , copy) NSString *money;
@end

@interface BuyCoinBottomView : UIView
@property (nonatomic , assign) BOOL isSelectWX;
@property (nonatomic , strong) RACSubject *selectResultSignal;
@property (nonatomic , copy) NSString *money;
@end

NS_ASSUME_NONNULL_END
