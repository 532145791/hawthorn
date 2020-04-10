//
//  BaseViewModel.h
//  BaseProject
//
//  Created by super on 2019/10/18.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel : NSObject
@property (nonatomic , strong) NSMutableArray *dataArr;
@property (nonatomic , strong) RACSubject *resultSignal;
@end

NS_ASSUME_NONNULL_END
