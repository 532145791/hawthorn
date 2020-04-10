//
//  HomepageNavigationView.h
//  BaseProject
//
//  Created by super on 2020/3/4.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomepageNavigationView : UIView
@property (nonatomic , strong) RACSubject *sexSelectSignal;
@property (nonatomic , strong) RACSubject *selectCitySignal;//选择城市
@property (nonatomic , copy) NSString *province;//省
@property (nonatomic , copy) NSString *city;//市
@property (nonatomic , copy) NSString *area;//区
@end

NS_ASSUME_NONNULL_END
