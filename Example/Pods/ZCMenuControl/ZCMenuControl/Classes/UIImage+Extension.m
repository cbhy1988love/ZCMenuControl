//
//  UIImage+Extension.m
//  TestMenuControl
//
//  Created by cai on 2022/11/29.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)verticalGradient:(NSArray <UIColor *>*)colors rect:(CGRect)rect {
    if (!colors.count) return [[UIImage alloc] init];
    CAGradientLayer *layer = [CAGradientLayer layer];
    NSMutableArray *CGColors = [NSMutableArray array];
    for (UIColor *color in colors) {[CGColors addObject:(__bridge id)[color CGColor]];}
    layer.frame = rect;
    layer.colors = CGColors.copy;
    layer.startPoint = CGPointMake(0.5, 0.0);
    layer.endPoint = CGPointMake(0.5, 1.0);
    NSMutableArray *locs = [NSMutableArray array];
    if (CGColors.count == 1) {
        [locs addObject:[NSNumber numberWithFloat:1.0]];
    } else {
        for (int i = 0; i < CGColors.count; i ++) {
            [locs addObject:[NSNumber numberWithFloat:i * (1.0 / (CGColors.count - 1))]];
        }
    }
    layer.locations = locs.copy;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image ? image : [[UIImage alloc] init];
}
@end
