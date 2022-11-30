//
//  UIWindow+CurrentVC.h
//  TestMenuControl
//
//  Created by cai on 2022/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (CurrentVC)
- (UIViewController *) visibleViewController;
@end

NS_ASSUME_NONNULL_END
