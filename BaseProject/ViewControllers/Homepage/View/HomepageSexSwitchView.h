//
//  HomepageSexSwitchView.h
//  BaseProject
//
//  Created by super on 2020/3/2.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomepageSexSwitchView : UIView
@property (nonatomic , assign) BOOL isMale;
@property (nonatomic , strong) RACSubject *selectSignal;
@end

NS_ASSUME_NONNULL_END
