//
//  TYButton.h
//  TYKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYButton : UIButton  /**< 拓展布局和响应范围 */

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, assign) BOOL isUseGrayImage;  /**< 使用灰度图片，默认NO */

@property (nonatomic, assign) CGSize fixSize;  /**< 自适应size大小，需实现sizeThatFits，默认sizeZero，即无效设置 */

@property (nonatomic, assign) CGSize imageViewSize;  /**< 居中对齐，自定义图片的size，默认zero */

@property (nonatomic, assign) CGFloat centerAlignmentSpace;  /**< 居中对齐，图片和文字间的间距，默认0 */

@property (nonatomic, assign) BOOL isVerticalCenterAlignment;  /**< 图片和标题是否是竖直居中中心对齐，默认NO */

@property (nullable, nonatomic, copy) void(^touchAction)(TYButton *sender);  /**< 添加TouchUpInset回调，默认nil */

@property (nonatomic, assign) UIEdgeInsets responseAreaExtend;  /**< 延伸响应区域，默认zero */

@property (nonatomic, assign) NSTimeInterval delayResponseTime;  /**< 延迟响应时间，默认0 */

@property (nonatomic, assign) NSTimeInterval responseTouchInterval;  /**< 最小响应时间间隔，默认0.3秒 */

@property (nullable, nonatomic, copy) NSString *ignoreConstraintSelector;  /**< 忽略上面设置的延迟时间、响应间隔的方法，默认nil */

/** 初始化一个SystemButton，可是设置title和image*/
+ (instancetype)customTitle:(nullable NSString *)title font:(nullable UIFont *)font color:(nullable UIColor *)color image:(nullable NSString *)image target:(nullable id)target action:(nullable SEL)action;

+ (instancetype)customText:(NSString *)text font:(UIFont *)font color:(UIColor *)color image:(NSString *)image bgColor:(nullable UIColor *)bgColor;

+ (instancetype)customBGColor:(nullable UIColor *)bgColor target:(nullable id)target action:(nullable SEL)action;

+ (instancetype)customImage:(nullable NSString *)image target:(nullable id)target action:(nullable SEL)action;

+ (instancetype)customFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action;

- (void)resetInitProperty;  /**< 重设到初始化属性值 */



- (void)setEasterPurpleGradientIsActivate:(BOOL)isActivate title:(nullable NSString *)title;

- (void)setEasterCyanGradientIsActivate:(BOOL)isActivate title:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END

