//
//  TabBarViewController.m
//  Daixiong(Buyer)
//
//  Created by 冷超 on 2017/4/17.
//  Copyright © 2017年 冷超. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomepageViewController.h"
#import "VideoListViewController.h"
#import "MeRootViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabbarView];
    [self setUpChildViewController];
}

#pragma mark - 设置tabbar
-(void)setTabbarView{
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setTranslucent:NO];
//    [[UITabBar appearance] setBackgroundColor:Color(kColor_White)];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    // 设置 TabBarItemTestAttributes 的颜色。
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : Font_Regular(10),
                                                        NSForegroundColorAttributeName : Color(@"BCB8C4")
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : Font_Regular(10),
                                                        NSForegroundColorAttributeName : Color(kColor_Theme)
                                                        } forState:UIControlStateSelected];
}

#pragma mark - 创建控制器
- (void)setUpChildViewController{
    BaseNavigationViewController *firstVC = [[BaseNavigationViewController alloc] initWithRootViewController:[[HomepageViewController alloc] init]];
    BaseNavigationViewController *secondVC = [[BaseNavigationViewController alloc] initWithRootViewController:[[VideoListViewController alloc] init]];
    BaseNavigationViewController *fourthVC = [[BaseNavigationViewController alloc] initWithRootViewController:[[MeRootViewController alloc] init]];
    
    [self addOneChildViewController:firstVC
                          WithTitle:@"首页"
                          imageName:@"first-normal"
                  selectedImageName:@"first-selected"];
    
    [self addOneChildViewController:secondVC
                          WithTitle:@"个人秀"
                          imageName:@"second-normal"
                  selectedImageName:@"second-selected"];
    
    [self addOneChildViewController:fourthVC
            WithTitle:@"我的"
            imageName:@"fourth-normal"
    selectedImageName:@"fourth-selected"];
}

#pragma mark - 添加一个子控制器
- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItemL = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    viewController.tabBarItem = tabBarItemL;
    viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    
    [self addChildViewController:viewController];
}

@end
