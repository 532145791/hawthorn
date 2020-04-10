//
//  VideoPlayView.h
//  BaseProject
//
//  Created by super on 2020/3/10.
//  Copyright © 2020 lengchao. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayView : UIView
@property (nonatomic , strong) NSURL *videoUrl;
/**
 内容区域在屏幕中间
 */
-(void)show;
/**
 消失
 */
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
