//
//  BaseNavigationViewController.m
//  BaseProject
//
//  Created by NeverMore on 2017/12/6.
//  Copyright © 2017年 lengchao. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "BaseViewController.h"
@interface BaseNavigationViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    BaseNavigationViewController* nvc = [super initWithRootViewController:rootViewController];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.interactivePopGestureRecognizer.enabled = [self.viewControllers count] > 1 ;
}
@end
