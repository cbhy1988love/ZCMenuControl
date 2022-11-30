//
//  TYButton.m
//  TYKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "TYButton.h"
#import "UIImage+Extension.h"
#import "UIColor+Extension.h"
#import "TYDefineConst.h"

@interface TYButton ()

@property (nonatomic, assign) BOOL isIgnoreTouch;

@property (nonatomic, assign) BOOL isManualSize;

@property (nonatomic, assign) CGSize titleRectSize;

@property (nonatomic, assign) CGFloat imageRectSpace;

@property (nonatomic, assign) SEL ignoreFlagSelector; //只能设置一个sel

@end

@implementation TYButton

+ (instancetype)customTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color image:(NSString *)image target:(id)target action:(SEL)action {
    TYButton *cusBtn = [TYButton buttonWithType:UIButtonTypeCustom];
    cusBtn.backgroundColor = [UIColor clearColor];
    cusBtn.adjustsImageWhenHighlighted = NO;
    if (font) cusBtn.titleLabel.font = font;
    if (title) {
        [cusBtn setTitle:title forState:UIControlStateNormal];
        cusBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        cusBtn.titleLabel.minimumScaleFactor = 0.6;
    }
    if (color) [cusBtn setTitleColor:color forState:UIControlStateNormal];
    UIImage *im = image.length ? [UIImage imageNamed:image] : nil;
    if (im) [cusBtn setImage:im forState:UIControlStateNormal];
    if (target && action && [target respondsToSelector:action]) {
        [cusBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return cusBtn;
}

+ (instancetype)customText:(NSString *)text font:(UIFont *)font color:(UIColor *)color image:(NSString *)image bgColor:(UIColor *)bgColor {
    TYButton *cusBtn = [TYButton buttonWithType:UIButtonTypeCustom];
    cusBtn.backgroundColor = bgColor ? bgColor : UIColor.clearColor;
    cusBtn.adjustsImageWhenHighlighted = NO;
    if (font) cusBtn.titleLabel.font = font;
    if (text) {
        [cusBtn setTitle:text forState:UIControlStateNormal];
        cusBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        cusBtn.titleLabel.minimumScaleFactor = 0.6;
    }
    if (color) [cusBtn setTitleColor:color forState:UIControlStateNormal];
    UIImage *im = image ? [UIImage imageNamed:image] : nil;
    if (im) [cusBtn setImage:im forState:UIControlStateNormal];
    return cusBtn;
}

+ (instancetype)customBGColor:(UIColor *)bgColor target:(id)target action:(SEL)action {
    TYButton *cusBtn = [TYButton buttonWithType:UIButtonTypeCustom];
    cusBtn.backgroundColor = bgColor ? bgColor : UIColor.clearColor;
    cusBtn.adjustsImageWhenHighlighted = NO;
    if (target && action && [target respondsToSelector:action]) {
        [cusBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    } return cusBtn;
}

+ (instancetype)customImage:(NSString *)image target:(id)target action:(SEL)action {
    return [self customTitle:nil font:nil color:nil image:image target:target action:action];
}

+ (instancetype)customFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action {
    TYButton *btn = [self customTitle:nil font:nil color:nil image:nil target:target action:action];
    btn.frame = frame; return btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isManualSize = NO;
        _centerAlignmentSpace = 0;
        _imageViewSize = CGSizeZero;
        _isVerticalCenterAlignment = NO;
        _responseAreaExtend = UIEdgeInsetsZero;
        _responseTouchInterval = 0.3;
        _fixSize = CGSizeZero;
    }
    return self;
}

- (void)resetInitProperty {
    _isUseGrayImage = NO;
    _isManualSize = NO;
    _fixSize = CGSizeZero;
    _imageViewSize = CGSizeZero;
    _centerAlignmentSpace = 0;
    _isVerticalCenterAlignment = NO;
    _responseAreaExtend = UIEdgeInsetsZero;
    _ignoreConstraintSelector = nil;
    _responseTouchInterval = 0.3;
    _delayResponseTime = 0;
    _ignoreFlagSelector = nil;
    self.touchAction = nil;
    [self layoutSubviews];
}
- (UIImage *)imageToGray:(UIImage*)image {
    int bitmapInfo = kCGImageAlphaNone;
    int width = image.size.width;
    int height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) return image;
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(context);
    CGImageRelease(imageRef);
    return (grayImage ? grayImage : image);
}
    

#pragma mark - Override
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (self.isUseGrayImage && image) image = [self imageToGray:image];
    [super setImage:image forState:state];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(_responseAreaExtend, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }
    if (self.hidden || self.alpha < 0.01 || !self.enabled || !self.userInteractionEnabled) {
        return NO;
    }
    CGRect hit = CGRectMake(self.bounds.origin.x - _responseAreaExtend.left,
                            self.bounds.origin.y - _responseAreaExtend.top,
                            self.bounds.size.width + _responseAreaExtend.left + _responseAreaExtend.right,
                            self.bounds.size.height + _responseAreaExtend.top + _responseAreaExtend.bottom);
    return CGRectContainsPoint(hit, point);
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (_ignoreConstraintSelector && _ignoreConstraintSelector.length && action) {
        if ([_ignoreConstraintSelector isEqualToString:NSStringFromSelector(action)]) {
            [super sendAction:action to:target forEvent:event];
        }
    }
    if (_ignoreFlagSelector && action && _ignoreFlagSelector == action) {
        [super sendAction:action to:target forEvent:event];
    }
    if (_isIgnoreTouch) return;
    if (_responseTouchInterval <= 0) {
        if (_delayResponseTime > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delayResponseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super sendAction:action to:target forEvent:event];
            });
        } else {
            [super sendAction:action to:target forEvent:event];
        }
    } else {
        [self performSelector:@selector(resetNotIgnoreTouch) withObject:nil afterDelay:_responseTouchInterval];
        _isIgnoreTouch = YES;
        if (_delayResponseTime > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delayResponseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super sendAction:action to:target forEvent:event];
            });
        } else {
            [super sendAction:action to:target forEvent:event];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

#pragma mark - Set
- (void)setImageViewSize:(CGSize)imageViewSize {
    _imageViewSize = imageViewSize;
    _isManualSize = !(CGSizeEqualToSize(_imageViewSize, CGSizeZero));
    [self layoutSubviews];
}

- (void)setCenterAlignmentSpace:(CGFloat)centerAlignmentSpace {
    _centerAlignmentSpace = centerAlignmentSpace;
    [self layoutSubviews];
}

- (void)setIsVerticalCenterAlignment:(BOOL)isVerticalCenterAlignment {
    _isVerticalCenterAlignment = isVerticalCenterAlignment;
    [self layoutSubviews];
}

- (void)setTouchAction:(void (^)(TYButton * _Nonnull))touchAction {
    _touchAction = touchAction;
    if ([self.allTargets containsObject:self] && (self.allControlEvents & UIControlEventTouchUpInside)) {
        if ([[self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(@selector(onTouchAction:))]) {
            [self removeTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (touchAction) {
        [self addTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setEasterPurpleGradientIsActivate:(BOOL)isActivate title:(NSString *)title {
    if (isActivate) {
        static UIImage *kCGActivatePImage = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kCGActivatePImage = [UIImage verticalGradient:@[kColor(@"#B585FF"),kColor(@"#8828FF")] rect:CGRectMake(0, 0, 50, 20)];
        });
        self.userInteractionEnabled = YES;
        [self setBackgroundImage:kCGActivatePImage forState:UIControlStateNormal];
        [self setTitleColor:kColor(@"#FFFFFF") forState:UIControlStateNormal];
        if (self.layer.borderWidth > 0) {self.layer.borderColor = kColor(@"#FDE0B5").CGColor;}
        if (title) [self setTitle:title forState:UIControlStateNormal];
    } else {
        static UIImage *kCGUnActivateImage = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kCGUnActivateImage = [UIImage verticalGradient:@[kColor(@"#C1CCD5"),kColor(@"#C0CAD2")] rect:CGRectMake(0, 0, 50, 50)];
        });
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:kCGUnActivateImage forState:UIControlStateNormal];
        [self setTitleColor:kColor(@"#FFFFFF") forState:UIControlStateNormal];
        if (self.layer.borderWidth > 0) {self.layer.borderColor = kColor(@"#FDE0B5").CGColor;}
        if (title) [self setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setEasterCyanGradientIsActivate:(BOOL)isActivate title:(NSString *)title {
    if (isActivate) {
        static UIImage *kCGActivateCImage = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kCGActivateCImage = [UIImage verticalGradient:@[kColor(@"#00C7C5"),kColor(@"#1C95C9")] rect:CGRectMake(0, 0, 50, 50)];
        });
        self.userInteractionEnabled = YES;
        [self setBackgroundImage:kCGActivateCImage forState:UIControlStateNormal];
        [self setTitleColor:kColor(@"#FFFFFF") forState:UIControlStateNormal];
        if (self.layer.borderWidth > 0) {self.layer.borderColor = kColor(@"#FDE0B5").CGColor;}
        if (title) [self setTitle:title forState:UIControlStateNormal];
    } else {
        static UIImage *kCGUnActivateImage = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kCGUnActivateImage = [UIImage verticalGradient:@[kColor(@"#C1CCD5"),kColor(@"#C0CAD2")] rect:CGRectMake(0, 0, 50, 50)];
        });
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:kCGUnActivateImage forState:UIControlStateNormal];
        [self setTitleColor:kColor(@"#FFFFFF") forState:UIControlStateNormal];
        if (self.layer.borderWidth > 0) {self.layer.borderColor = kColor(@"#FDE0B5").CGColor;}
        if (title) [self setTitle:title forState:UIControlStateNormal];
    }
}


#pragma mark - Private
- (void)onTouchAction:(id)sender {
    if (_touchAction) _touchAction(self);
}

- (void)resetNotIgnoreTouch {
    _isIgnoreTouch = NO;
}

#pragma mark - Override
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super imageRectForContentRect:contentRect];
    if (!self.isManualSize) {
        if (self.centerAlignmentSpace || self.isVerticalCenterAlignment) {
            _imageViewSize = [self imageForState:UIControlStateNormal].size;
        } else {
            _imageViewSize = CGSizeZero;
        }
    }
    if (CGSizeEqualToSize(self.imageViewSize, CGSizeZero)) return rect;
    if ([self titleForState:UIControlStateNormal].length) {
        CGFloat left = 0, space = 0;
        if (self.isVerticalCenterAlignment) {
            CGFloat restHei = contentRect.size.height - self.imageViewSize.height - self.centerAlignmentSpace;
            CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentRect.size.width, restHei)];
            left = (contentRect.size.width - self.imageViewSize.width) / 2.0;
            space = (contentRect.size.height - self.imageViewSize.height - self.centerAlignmentSpace - titleSize.height) / 2.0;
            self.titleRectSize = titleSize;
            self.imageRectSpace = space;
        } else {
            CGFloat restWid = contentRect.size.width - self.imageViewSize.width - self.centerAlignmentSpace;
            CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(restWid, contentRect.size.height)];
            space = (contentRect.size.height - self.imageViewSize.height) / 2.0;
            left = (contentRect.size.width - self.imageViewSize.width - self.centerAlignmentSpace - titleSize.width) / 2.0;
            self.titleRectSize = titleSize;
            self.imageRectSpace = left;
        }
        return CGRectMake(left + contentRect.origin.x, space + contentRect.origin.y, self.imageViewSize.width, self.imageViewSize.height);
    } else {
        CGFloat top = rect.origin.y - (self.imageViewSize.height - rect.size.height) / 2.0;
        CGFloat left = rect.origin.x - (self.imageViewSize.width - rect.size.width) / 2.0;
        return CGRectMake(left, top, self.imageViewSize.width, self.imageViewSize.height);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super titleRectForContentRect:contentRect];
    if (CGSizeEqualToSize(self.imageViewSize, CGSizeZero)) return rect;
    if ([self titleForState:UIControlStateNormal].length) {
        CGFloat left = 0, space = 0;
        if (self.isVerticalCenterAlignment) {
            left = (contentRect.size.width - self.titleRectSize.width) / 2.0;
            space = contentRect.size.height - self.imageRectSpace - self.titleRectSize.height;
        } else {
            space = (contentRect.size.height - self.titleRectSize.height) / 2.0;
            left = contentRect.size.width - self.imageRectSpace - self.titleRectSize.width;
        }
        return CGRectMake(left + contentRect.origin.x, space + contentRect.origin.y, self.titleRectSize.width, self.titleRectSize.height);
    } else {
        return CGRectZero;
    }
}

@end
