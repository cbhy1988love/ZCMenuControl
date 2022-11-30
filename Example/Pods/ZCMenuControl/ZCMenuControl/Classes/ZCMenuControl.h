//
//  ZCMenuControl.h
//  ZCKit
//
//  Created by admin on 2018/10/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYButton.h"

///Authors:zjy
///Email：961627191@qq.com

NS_ASSUME_NONNULL_BEGIN

@interface ZCMenuControl : UIView  /**< 点击菜单控件，加载在自定义window上 */

@property (nonatomic, assign) BOOL isShowShadow;  /**< 是否显示阴影，默认NO */

@property (nonatomic, assign) BOOL isMaskHide;  /**< 点击背景是否隐藏，默认YES */

@property (nonatomic, assign) BOOL isMaskClear;  /**< 是否使用透明背景，默认YES，不用灰色 */

@property (nonatomic, strong) UIColor *fillColor;  /**<  背景填充颜色，默认白色 */

@property (nonatomic, assign) unsigned short maxLine;  /**< 最大多少行，默认7行 */

@property (nonatomic, assign) CGFloat rowHeight;  /**< 行高，默认 47.0 */

@property (nonatomic, assign) CGFloat topHeight;  /**< 头尾部高，默认 8.0 */

@property (nonatomic, assign) CGRect initArrowRect;  /**< 箭头位置，y为负数则是底部箭头 */

/**< 点击背景或者取消时，selectIndex = -1，vertex顶点坐标，set 回调可以设置一些属性 */
+ (void)display:(NSArray <NSString *>*)menus width:(CGFloat)width vertex:(CGPoint)vertex
            set:(nullable void(^)(ZCMenuControl *menuControl))set
         btnSet:(nullable void(^)(NSInteger index, TYButton *itemBtn, UIView * _Nullable line))btnSet
          click:(nullable void(^)(NSInteger selectIndex))click;

@end

NS_ASSUME_NONNULL_END
