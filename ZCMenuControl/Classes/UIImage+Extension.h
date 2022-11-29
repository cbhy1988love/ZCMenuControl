//
//  UIImage+Extension.h
//  TestMenuControl
//
//  Created by cai on 2022/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)
+ (UIImage *)verticalGradient:(NSArray <UIColor *>*)colors rect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
