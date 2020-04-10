//
//  QiniuUploadTool.h
//  BaseProject
//
//  Created by super on 2020/3/25.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 上传回调
typedef void(^uploadCallblock)(BOOL success, NSString* msg, NSArray<NSString *>* keys);

@interface QiniuUploadTool : NSObject
/// 删除文件
+(void)deleteFileWithObjectKeyArr:(NSArray *)objectKeyArr callback:(uploadCallblock)callback;

/// 上传图片（单张或多张）
+ (void)uploadImages:(NSArray *)images isAsync:(BOOL)isAsync callback:(uploadCallblock)callback;

//上传视频
+ (void)asyncUploadVideo:(NSData *)data callback:(uploadCallblock)callback;
@end

NS_ASSUME_NONNULL_END
