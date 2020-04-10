//
//  VideoViewModel.m
//  BaseProject
//
//  Created by super on 2020/1/19.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "VideoViewModel.h"
#import "WPhotoViewController.h"
#import "QiniuUploadTool.h"

static NSInteger maxCount = 30;
@interface VideoViewModel ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation VideoViewModel
/// 加载视频列表数据
/// @param gender 性别
/// @param currentPage 当前页码
-(void)loadListDataWithGender:(NSInteger)gender currentPage:(NSInteger)currentPage{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(gender) forKey:@"gender"];
    [dic setObject:@(currentPage) forKey:@"currentPage"];
    [dic setObject:@(10) forKey:@"pageSize"];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/getVideoList"] paras:dic success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        VideoListModel *model = [VideoListModel modelWithJSON:result.data];
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

// 选择本地视频
- (void)chooseVideo {
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    if (userInfo.videoCount >= 20) {
        [SVProgressHUD showMessageWithStatus:@"每个用户最多上传20个视频"];
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    imagePicker.delegate = self;
    [[CommonTool currentViewController] presentViewController:imagePicker animated:YES completion:nil];
}

// 选择本地照片
- (void)chooseLocalPhoto {
    UserInfoModel *userInfo = [UserInfoManager getUserInfo];
    if (userInfo.albumCount >= maxCount) {
        [SVProgressHUD showMessageWithStatus:[NSString stringWithFormat:@"每个用户最多上传%ld张照片",(long)maxCount]];
        return;
    }
    
    WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    WphotoVC.selectPhotoOfMax = maxCount - userInfo.albumCount;
    __block NSMutableArray *urlArr = [NSMutableArray array];
    WS(weakSelf)
    [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        NSLog(@"phostsArr=%@",phostsArr);
        [SVProgressHUD show];
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 0; i < phostsArr.count; i ++) {
            [images addObject:phostsArr[i][@"image"]];
        }
        [QiniuUploadTool uploadImages:images isAsync:YES callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
            if (success) {
                for (NSString *key in keys) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:key forKey:@"path"];
                    [urlArr addObject:dic];
                }
                [weakSelf uploadToServerWithList:urlArr type:2];
            }
        }];
    }];
    WphotoVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[CommonTool currentViewController] presentViewController:WphotoVC animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>
// 完成视频录制，并压缩后显示大小、时长
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 拿到视频地址
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    CGFloat videoSize = [CommonTool getFileSize:[sourceURL path]];
    int videoTime = [CommonTool getVideoLength:sourceURL];
    if (videoTime > 30) {//视频时长大于30s
        [SVProgressHUD showMessageWithStatus:@"视频时长不要超过30秒"];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self chooseVideo];
        }];
        return;
    }
    NSLog(@"视频地址：%@",[sourceURL path]);
    __block NSMutableArray *urlArr = [NSMutableArray array];
    WS(weakSelf)
    [QiniuUploadTool asyncUploadVideo:[NSData dataWithContentsOfFile:[sourceURL path]] callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
        if (success) {
            for (NSString *key in keys) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:key forKey:@"path"];
                [urlArr addObject:dic];
            }
            [weakSelf uploadToServerWithList:urlArr type:1];
        }
    }];
    
    NSLog(@"压缩处理之前的视频 时长：%@",[NSString stringWithFormat:@"%d s", [CommonTool getVideoLength:sourceURL]]);
    NSLog(@"压缩处理之前的视频大小：%@", [NSString stringWithFormat:@"%.2f MB", videoSize]);

    [picker dismissViewControllerAnimated:YES completion:nil];
}

//上传图片或视频链接到服务器
-(void)uploadToServerWithList:(NSArray *)list type:(NSInteger)type{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:list forKey:@"list"];
    [params setObject:@(type) forKey:@"type"];
    [HttpTool postWithUrl:[BaseUrl stringByAppendingFormat:@"/users/addUp"] paras:params success:^(ResultModel *result) {
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUploadFileSuccess object:nil];
    } failure:^(NSError *error) {
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
