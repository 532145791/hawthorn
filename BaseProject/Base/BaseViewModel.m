//
//  BaseViewModel.m
//  BaseProject
//
//  Created by super on 2019/10/18.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(RACSubject *)resultSignal{
    if (!_resultSignal) {
        _resultSignal = [RACSubject subject];
    }
    return _resultSignal;
}

@end
