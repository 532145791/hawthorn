//
//  VideoListCollectionViewCell.h
//  BaseProject
//
//  Created by super on 2020/3/5.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoListAgeView : UIView
@property (nonatomic , assign) BOOL isMale;
@property (nonatomic , copy) NSString *age;
@end

@interface VideoListCollectionViewCell : UICollectionViewCell
@property (nonatomic , strong) VideoItemModel *model;
@property (nonatomic , strong) UIImageView *videoThumbnailView;
@end

NS_ASSUME_NONNULL_END
