//
//  UserInfoModel.m
//  BaseProject
//
//  Created by 冷超 on 2017/6/30.
//  Copyright © 2017年 lengchao. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self != nil) {
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.sex = [aDecoder decodeIntForKey:@"sex"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.countryCode = [aDecoder decodeObjectForKey:@"countryCode"];
        self.isLogined = [aDecoder decodeBoolForKey:@"isLogined"];
        self.ifPartner = [aDecoder decodeBoolForKey:@"ifPartner"];
        self.memberStatus = [aDecoder decodeIntForKey:@"memberStatus"];
        self.memberLevel = [aDecoder decodeObjectForKey:@"memberLevel"];
        self.memberStartDate = [aDecoder decodeObjectForKey:@"memberStartDate"];
        self.memberEndDate = [aDecoder decodeObjectForKey:@"memberEndDate"];
        self.qq = [aDecoder decodeObjectForKey:@"qq"];
        self.alipayNumber = [aDecoder decodeObjectForKey:@"alipayNumber"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.coinCount = [aDecoder decodeIntForKey:@"coinCount"];
        self.albumCount = [aDecoder decodeIntegerForKey:@"albumCount"];
        self.videoCount = [aDecoder decodeIntegerForKey:@"videoCount"];
        self.weixin = [aDecoder decodeObjectForKey:@"weixin"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeInt:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.countryCode forKey:@"countryCode"];
    [aCoder encodeBool:self.isLogined forKey:@"isLogined"];
    [aCoder encodeBool:self.ifPartner forKey:@"ifPartner"];
    [aCoder encodeInt:self.memberStatus forKey:@"memberStatus"];
    [aCoder encodeObject:self.memberLevel forKey:@"memberLevel"];
    [aCoder encodeObject:self.memberStartDate forKey:@"memberStartDate"];
    [aCoder encodeObject:self.memberEndDate forKey:@"memberEndDate"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.alipayNumber forKey:@"alipayNumber"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeInt:self.coinCount forKey:@"coinCount"];
    [aCoder encodeInteger:self.albumCount forKey:@"albumCount"];
    [aCoder encodeInteger:self.videoCount forKey:@"videoCount"];
    [aCoder encodeObject:self.weixin forKey:@"weixin"];
}

@end
