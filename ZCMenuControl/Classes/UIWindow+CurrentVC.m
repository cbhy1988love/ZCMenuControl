//
//  UIWindow+CurrentVC.m
//  TestMenuControl
//
//  Created by cai on 2022/11/29.
//

#import "UIWindow+CurrentVC.h"

@implementation UIWindow (CurrentVC)
- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    
    ///优先判断 presentedViewController
    if(vc.presentedViewController){
        return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        return vc;
    }
}
@end
