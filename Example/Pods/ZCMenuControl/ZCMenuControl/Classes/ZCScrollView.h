//
//  ZCScrollView.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCScrollView : UIScrollView  /**< 好用的ScrollView控件 */

@property (nonatomic, assign) BOOL isThrough;  /**< 穿透事件 */

@property (nonatomic, assign) BOOL isPriorityEditGestures;  /**< 优先识别子TableView编辑手势 */

- (ZCScrollView *)initWithFrame:(CGRect)frame isPaging:(BOOL)isPaging bouncesStyle:(int)bouncesStyle isThrough:(BOOL)isThrough;  /**< 0.不可bounces 1.水平 2.垂直 3.水平和垂直都能bounces */

@end

NS_ASSUME_NONNULL_END
