//
//  MyPhotoCollectionViewCell.h
//  BaseProject
//
//  Created by super on 2020/3/7.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic , assign) BOOL isPhoto;//yes-照片类型的  no-视频类型的
@property (nonatomic , copy) NSString *imgUrl;
@property (nonatomic , assign) BOOL isShowSelectIcon;//是否显示选中icon
@end

NS_ASSUME_NONNULL_END
