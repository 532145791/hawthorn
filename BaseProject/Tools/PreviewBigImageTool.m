//
//  PreviewBigImageTool.m
//  BaseProject
//
//  Created by super on 2020/3/26.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import "PreviewBigImageTool.h"
#import "GQImageVideoViewer.h"
@implementation PreviewBigImageTool
+(void)showWithImageUrlArr:(NSArray *)imageUrlArr inView:(UIView *)view selectIndex:(NSInteger)selectIndex{
    [GQImageVideoViewer sharedInstance].backgroundColor = [UIColor blackColor];
    [GQImageVideoViewer sharedInstance].alpha = 1;
    [GQImageVideoViewer sharedInstance]
    .dataArrayChain(imageUrlArr)
    .usePageControlChain(NO)
    .selectIndexChain(selectIndex)
    .achieveSelectIndexChain(^(NSInteger selectIndex){
        NSLog(@"%ld",selectIndex);
    })
    .launchDirectionChain(GQLaunchDirectionBottom)
    .showViewChain(view);
}

+(void)showWithVideoUrlArr:(NSArray *)videoUrlArr inView:(UIView *)view selectIndex:(NSInteger)selectIndex{
    [GQImageVideoViewer sharedInstance]
    .dataArrayChain(videoUrlArr)
    .usePageControlChain(NO)
    .selectIndexChain(selectIndex)
    .achieveSelectIndexChain(^(NSInteger selectIndex){
        NSLog(@"%ld",(long)selectIndex);
    })
    .launchDirectionChain(GQLaunchDirectionBottom)
    .showViewChain(view);
}
@end
