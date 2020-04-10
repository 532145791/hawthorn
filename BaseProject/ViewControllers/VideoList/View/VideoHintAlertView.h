//
//  VideoHintAlertView.h
//  BaseProject
//
//  Created by super on 2020/3/8.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoHintAlertView : BaseAlertView
@property (nonatomic , strong) RACSubject *selectSignal;
@end

NS_ASSUME_NONNULL_END
