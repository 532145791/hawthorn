//
//  ShareAlertView.h
//  BaseProject
//
//  Created by super on 2019/10/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , ShareAlertItemViewType) {
    ShareAlertItemViewTypeQQ = 0 ,
    ShareAlertItemViewTypeQQSpace ,
    ShareAlertItemViewTypeWX ,
    ShareAlertItemViewTypeWXFriend,
};

@interface ShareAlertItemView : UIView
@property (nonatomic , assign) ShareAlertItemViewType type;
@end

@interface ShareAlertView : BaseAlertView
@property (nonatomic , assign) NSInteger type;//1--图片 2--链接
@property (nonatomic , strong) UIImage *image;
@property (nonatomic , copy) NSString *downloadUrl;
@end

NS_ASSUME_NONNULL_END
