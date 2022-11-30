//
//  UIView+Extension.h
//  TestMenuControl
//
//  Created by cai on 2022/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)
/**
 * 控件x点坐标
 */
@property (nonatomic, assign) CGFloat x;
/**
 * 控件y点坐标
 */
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGPoint origin;
/**
 * 控件 距离 顶部值
 */
@property CGFloat top;
/**
 * 控件 距离 左边值
 */
@property (nonatomic, assign) CGFloat left;
/**
 * 控件 距离 右边值
 */
@property (nonatomic, assign) CGFloat right;
/**
 * 控件 距离 尾部值
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 * 控件 中心点 x坐标
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 * 控件 中心点 y坐标
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 * 控件 宽度
 */
@property (nonatomic, assign) CGFloat width;
/**
 * 控件 高度
 */
@property (nonatomic, assign) CGFloat height;
/**
 * 控件 大小
 */
@property (nonatomic, assign) CGSize size;

/// 生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
