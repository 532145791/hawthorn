//
//  PreviewBigImageTool.h
//  BaseProject
//
//  Created by super on 2020/3/26.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewBigImageTool : NSObject
+(void)showWithImageUrlArr:(NSArray *)imageUrlArr inView:(UIView *)view selectIndex:(NSInteger)selectIndex;

+(void)showWithVideoUrlArr:(NSArray *)videoUrlArr inView:(UIView *)view selectIndex:(NSInteger)selectIndex;
@end

NS_ASSUME_NONNULL_END
