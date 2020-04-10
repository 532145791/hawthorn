//
//  AppDelegate.m
//  BaseProject
//
//  Created by 冷超 on 2017/6/30.
//  Copyright © 2017年 lengchao. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "LoginViewModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CommonTool saveDeviceIdentifier];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUpHUDStyle];
        [self setUpNavigationBar];
        [self setUpIQKeyboardManager];
        [self setUpUMeng];
        [self setUpWX];
        [self setUpQQ];
        [self setUpBugly];
    });
    
//    BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//    self.window.rootViewController = nv;
    
    if ([UserDefaults getDataWithKey:@"Token"]) {
        self.window.rootViewController = self.tabbar;
    }else{
        BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        self.window.rootViewController = nv;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

-(TabBarViewController *)tabbar{
    return [[TabBarViewController alloc] init];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
