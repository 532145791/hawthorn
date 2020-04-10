//
//  QiniuUploadTool.m
//  BaseProject
//
//  Created by super on 2020/3/25.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "QiniuUploadTool.h"
#import <QiniuSDK.h>
@implementation QiniuUploadTool
/// 删除文件
+(void)deleteFileWithObjectKeyArr:(NSArray *)objectKeyArr callback:(uploadCallblock)callback{
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/delete"] paras:@{@"idList":objectKeyArr} success:^(ResultModel *result) {
        if (callback) {
            callback( YES, @"删除成功" , @[]);
        }
    } failure:^(NSError *error) {
        
    }];
}

/// 上传图片
+ (void)uploadImages:(NSArray *)images isAsync:(BOOL)isAsync callback:(uploadCallblock)callback{
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/qiniu/user/queryQiniuUploadAuthen"] paras:[NSDictionary dictionary] success:^(ResultModel *result) {
        NSString *token = result.data[@"token"];
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.useHttps = YES;
        }];
        QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
            [SVProgressHUD showProgress:percent status:@"上传中"];
        }];
        
        if (images.count == 1) {
            UIImage *image = images.firstObject;
            UserInfoModel *userInfo = [UserInfoManager getUserInfo];
            NSString *fileName = [NSString stringWithFormat:@"%@-%@.png",userInfo.uid,[CommonTool randomStringWithLength:6]];
            [upManager putData:UIImageJPEGRepresentation(image, 0.9) key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (callback) {
                    callback( YES, @"全部上传完成" , @[[kQiniuHost stringByAppendingString:key]]);
                }
            } option:uploadOption];
        }else{
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            queue.maxConcurrentOperationCount = images.count;
            NSMutableArray *callBackNames = [NSMutableArray array];
            for (UIImage *image in images) {
                if (image) {
                    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                        UserInfoModel *userInfo = [UserInfoManager getUserInfo];
                        NSString *fileName = [NSString stringWithFormat:@"%@-%@.png",userInfo.uid,[CommonTool randomStringWithLength:6]];
                        [upManager putData:UIImageJPEGRepresentation(image, 0.9) key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                            [callBackNames addObject:[kQiniuHost stringByAppendingString:key]];
                            if (image == images.lastObject) {
                                NSLog(@"upload object finished!");
                                if (callback) {
                                    callback( YES, @"全部上传完成" , [callBackNames copy]);
                                }
                            }
                        } option:uploadOption];
                    }];
                    if (queue.operations.count != 0) {
                        [operation addDependency:queue.operations.lastObject];
                    }
                    [queue addOperation:operation];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//上传视频
+ (void)asyncUploadVideo:(NSData *)data callback:(uploadCallblock)callback{
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/qiniu/user/queryQiniuUploadAuthen"] paras:[NSDictionary dictionary] success:^(ResultModel *result) {
        NSString *token = result.data[@"token"];
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.useHttps = YES;
        }];
        QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
            [SVProgressHUD showProgress:percent status:@"上传中"];
        }];
        
        UserInfoModel *userInfo = [UserInfoManager getUserInfo];
        NSString *fileName = [NSString stringWithFormat:@"%@-%@.mp4",userInfo.uid,[CommonTool randomStringWithLength:6]];
        [upManager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (callback) {
                callback( YES, @"上传完成" , @[[kQiniuHost stringByAppendingString:key]]);
            }
        } option:uploadOption];
    } failure:^(NSError *error) {
        
    }];
}
@end
