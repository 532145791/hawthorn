//
//  UserInfoManager.m
//  BaseProject
//
//  Created by 冷超 on 2017/6/30.
//  Copyright © 2017年 lengchao. All rights reserved.
//

#import "UserInfoManager.h"
#define kInfoPath @"/Documents/UserInfo"
@implementation UserInfoManager

+ (NSString *)getUserInfoPath {

  NSString *home = NSHomeDirectory();
  home = [home stringByAppendingString:kInfoPath];

  NSFileManager *manager = [NSFileManager defaultManager];
  BOOL exist = [manager fileExistsAtPath:home];

  if (!exist) {
    BOOL success = [manager createDirectoryAtPath:home
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:nil];

    NSLog(@"success=%d", success);
  }

  NSString *path = [home stringByAppendingPathComponent:@"/userInfo.info"];
  return path;
}

+ (void)setUserInfo:(UserInfoModel *)model {

  NSString *path = [self getUserInfoPath];
  [NSKeyedArchiver archiveRootObject:model toFile:path];
}

+ (UserInfoModel *)getUserInfo {

  NSString *path = [self getUserInfoPath];
  UserInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (model == nil) {
        model = [UserInfoModel new];
    }
  return model;
}

+ (void)deleteUserInfo {
  NSString *path = [self getUserInfoPath];
  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


@end
