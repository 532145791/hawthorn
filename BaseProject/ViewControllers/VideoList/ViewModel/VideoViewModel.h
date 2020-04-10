//
//  VideoViewModel.h
//  BaseProject
//
//  Created by super on 2020/1/19.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "BaseViewModel.h"
#import "VideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoViewModel : BaseViewModel

// 选择本地视频
- (void)chooseVideo;

// 选择本地照片
- (void)chooseLocalPhoto;

/// 加载视频列表数据
/// @param gender 性别
/// @param currentPage 当前页码
-(void)loadListDataWithGender:(NSInteger)gender currentPage:(NSInteger)currentPage;
@end

NS_ASSUME_NONNULL_END
