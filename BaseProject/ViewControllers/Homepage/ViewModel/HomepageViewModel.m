//
//  HomepageViewModel.m
//  BaseProject
//
//  Created by super on 2019/10/9.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "HomepageViewModel.h"

@implementation HomepageViewModel

/// 检测个人信息是否完善
-(void)checkUserInfo{
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/check"] paras:[NSDictionary dictionary] success:^(ResultModel *result) {
        CheckUserInfoModel *model = [CheckUserInfoModel modelWithJSON:result.data];
        if (model) {
            if (model.status == 2) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的个人资料未完善，别人无法查看你" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"立即填写" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [MGJRouter openURL:kProfileViewController withUserInfo:@{@"isFinishProfile":@(NO)} completion:nil];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不填写" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:cameraAction];
                [alert addAction:cancelAction];
                
                [[CommonTool currentViewController] presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 首页列表
/// @param city 常驻城市
/// @param gender 性别：1-男，2-女
/// @param currentPage 当前页码
-(void)loadListDataWithCity:(NSString *)city gender:(NSInteger)gender currentPage:(NSInteger)currentPage{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:city forKey:@"city"];
    [dic setObject:@(gender) forKey:@"gender"];
    [dic setObject:@(currentPage) forKey:@"currentPage"];
    [dic setObject:@(20) forKey:@"pageSize"];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/getList"] paras:dic success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        HomepageListModel *model = [HomepageListModel modelWithJSON:result.data];
        if (model) {
            if (currentPage == 1) {
                if (self.dataArr.count > 0) {
                    [self.dataArr removeAllObjects];
                }
            }
            
            if (model.list.count == 0) {
               [self.resultSignal sendNext:@0];
            }else{
                [self.dataArr addObjectsFromArray:model.list];
                if (model.pagination.currentPage == 1) {
                    if (model.pagination.total <= model.pagination.pageSize) {
                        [self.resultSignal sendNext:@0];
                    }else{
                        [self.resultSignal sendNext:@1];
                    }
                }else{
                    if (model.list.count < model.pagination.pageSize) {
                        [self.resultSignal sendNext:@0];
                    }else{
                        [self.resultSignal sendNext:@1];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 获取用户信息
/// @param userId 用户id
-(void)loadUserDetailWithUserId:(NSString *)userId{
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/getDetails"] paras:@{@"userIdTo":userId} success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        MyInfoModel *model = [MyInfoModel modelWithJSON:result.data];
        if (model) {
            [self.resultSignal sendNext:model];
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 查看微信号
/// @param userId 用户id
-(void)getWeixinWithUserId:(NSString *)userId{
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/getWeixin"] paras:@{@"userIdTo":userId} success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        UserDetailCheckWXModel *model = [UserDetailCheckWXModel modelWithJSON:result.data];
        if (model) {
            [self.checkResultSignal sendNext:model];
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 举报
/// @param userId 用户id
/// @param content 举报内容
-(void)reportWithUserId:(NSString *)userId content:(NSString *)content{
    if ([CommonTool isNull:content]) {
        [SVProgressHUD showMessageWithStatus:@"请输入举报内容"];
        return;
    }
    [SVProgressHUD show];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/report"] paras:@{@"userIdTo":userId,@"content":content} success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        [[CommonTool currentViewController].navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

-(RACSubject *)checkResultSignal{
    if (!_checkResultSignal) {
        _checkResultSignal = [RACSubject subject];
    }
    return _checkResultSignal;
}
@end
