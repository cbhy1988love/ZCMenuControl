//
//  TYMaskView.m
//  TYKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "TYMaskView.h"
#import "UIColor+Extension.h"
#import "TYDefineConst.h"
#import "UIWindow+CurrentVC.h"

#pragma mark - ~ TYFocusView ~
@implementation TYFocusView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BOOL responder = YES;
    if (self.isCanResponse) {
        CGPoint focus = [[touches anyObject] locationInView:self];
        responder = self.isCanResponse(focus);
    }
    if (responder) {
        if (self.responseAction) self.responseAction();
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

@end


#pragma mark - ~ TYMaskView ~
@interface TYMaskView ()

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL isAnimate;

@property (nonatomic, assign) BOOL isAutoHide;

@property (nonatomic, assign) BOOL isGreyMask;

@property (nonatomic, assign) float maskAlpha;

@property (nonatomic, copy) void(^hideAction)(void);

@property (nonatomic, copy) void (^showAnimate)(UIView *displayView);

@property (nonatomic, copy) void (^hideAnimate)(UIView *displayView);

@property (nonatomic, weak) UIView *displayView;

@property (nonatomic, assign) NSTimeInterval animateTime;

@end

@implementation TYMaskView

+ (instancetype)sharedView {
    static TYMaskView *mask = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mask = [[TYMaskView alloc] initWithFrame:CGRectZero];
        mask.animateTime = 0.25;
        mask.maskAlpha = 0.6;
    });
    return mask;
}

+ (void)display:(UIView *)subview hideAction:(void (^)(void))hideAction {
    [self display:subview autoHide:YES clearMask:NO hideAction:hideAction];
}

+ (void)display:(UIView *)subview autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask hideAction:(void (^)(void))hideAction {
    [self display:subview autoHide:autoHide clearMask:clearMask showAnimate:nil hideAnimate:nil hideAction:hideAction];
}

+ (void)display:(UIView *)subview autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask hideLastFinish:(BOOL (^)(void))hideLastFinish hideAction:(void (^)(void))hideAction {
    [self display:subview autoHide:autoHide clearMask:clearMask hideLastFinish:hideLastFinish showAnimate:nil hideAnimate:nil hideAction:hideAction];
}

+ (void)display:(UIView *)displayView autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask showAnimate:(void (^)(UIView * _Nonnull))showAnimate
    hideAnimate:(void (^)(UIView * _Nonnull))hideAnimate hideAction:(void (^)(void))hideAction {
    [self display:displayView autoHide:autoHide clearMask:clearMask hideLastFinish:nil showAnimate:showAnimate hideAnimate:hideAnimate hideAction:hideAction];
}

+ (void)display:(UIView *)displayView autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask hideLastFinish:(BOOL (^)(void))hideLastFinish showAnimate:(void (^)(UIView * _Nonnull))showAnimate
    hideAnimate:(void (^)(UIView * _Nonnull))hideAnimate hideAction:(void (^)(void))hideAction {
    if (!displayView || ![UIApplication sharedApplication].delegate.window) return;
    TYMaskView *mask = [TYMaskView sharedView];
    __weak typeof(mask) weakMask = mask;
    if (mask.isAnimate) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((mask.animateTime * 1.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [mask hide:^{
                BOOL isCanAllow = YES;
                if (hideLastFinish) { isCanAllow = hideLastFinish(); }
                if (!isCanAllow) return;
                weakMask.isAutoHide = autoHide;
                weakMask.isGreyMask = !clearMask;
                weakMask.hideAction = hideAction;
                weakMask.showAnimate = showAnimate;
                weakMask.hideAnimate = hideAnimate;
                weakMask.displayView = displayView;
                weakMask.frame = [UIScreen mainScreen].bounds;
                UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [[UIApplication sharedApplication].delegate.window addSubview:maskView];
                [maskView addSubview:weakMask];
                [weakMask addSubview:displayView];
                [weakMask show];
            }];
        });
    } else {
        [mask hide:^{
            weakMask.isAutoHide = autoHide;
            weakMask.isGreyMask = !clearMask;
            weakMask.hideAction = hideAction;
            weakMask.showAnimate = showAnimate;
            weakMask.hideAnimate = hideAnimate;
            weakMask.displayView = displayView;
            weakMask.frame = [UIScreen mainScreen].bounds;
            UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [[UIApplication sharedApplication].delegate.window addSubview:maskView];
            [maskView addSubview:weakMask];
            [weakMask addSubview:displayView];
            [weakMask show];
        }];
    }
}

+ (void)dismissSubview {
    TYMaskView *mask = [TYMaskView sharedView];
    if (mask.hideAction) {
        mask.hideAction();
        mask.hideAction = nil;
    }
    [mask hide:nil];
}

+ (NSTimeInterval)animateDuration {
    TYMaskView *mask = [TYMaskView sharedView];
    return mask.animateTime;
}

- (void)show {
    self.isShow = YES;
    self.isAnimate = YES;
    self.alpha = self.showAnimate ? 1 : 0;
    self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:self.animateTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.showAnimate) {
            self.showAnimate(self.displayView);
        } else {
            self.alpha = 1;
        }
        self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.isGreyMask ? self.maskAlpha : 0];
    } completion:^(BOOL finished) {
        self.isAnimate = NO;
    }];
}

- (void)hide:(void(^)(void))finish {
    if (self.isShow) {
        self.isAnimate = YES;
        [UIView animateWithDuration:self.animateTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (self.hideAnimate) {
                self.hideAnimate(self.displayView);
            } else {
                self.alpha = 0;
            }
            self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self hideFinish];
            if (finish) finish();
        }];
    } else {
        [self hideFinish];
        if (finish) finish();
    }
}

- (void)hideFinish {
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.hideAction) self.hideAction = nil;
    if (self.showAnimate) self.showAnimate = nil;
    if (self.hideAnimate) self.hideAnimate = nil;
    if (self.displayView) self.displayView = nil;
    self.isShow = NO;
    self.isAnimate = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isAutoHide && self.isAnimate == NO) {
        if (self.subviews.firstObject) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self];
            CGRect rect = self.subviews.firstObject.frame;
            if (CGRectContainsPoint(rect, point) == NO) [TYMaskView dismissSubview];
        } else {
            [TYMaskView dismissSubview];
        }
    }
}

@end



#pragma mark - ~ ZCMaskViewController ~
@interface ZCMaskViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIWindow *maskWindow;

@property (nonatomic, strong) TYFocusView *maskView;

@property (nonatomic, strong) UIVisualEffectView *visualView;

@property (nonatomic, assign) NSTimeInterval animationTime;

@end

@implementation ZCMaskViewController

+ (instancetype)sharedController {
    static ZCMaskViewController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZCMaskViewController alloc] init];
    });
    return instance;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [kAppWindow.visibleViewController preferredStatusBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationTime = 0;
    self.view.backgroundColor = UIColor.clearColor;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = UIColor.clearColor;
    self.maskView = [[TYFocusView alloc] initWithFrame:CGRectZero];
    self.maskView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.visualView];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.maskView];
}

- (void)dealloc {
    self.maskWindow.rootViewController = nil;
    self.maskWindow.hidden = YES;
    self.maskWindow = nil;
}

- (UIWindow *)maskWindow {
    if (!_maskWindow) {
        _maskWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _maskWindow.windowLevel = UIWindowLevelAlert + 1.0;
        _maskWindow.rootViewController = self;
    }
    return _maskWindow;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.visualView.frame = self.view.bounds;
    self.contentView.frame = self.view.bounds;
    self.maskView.frame = self.view.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)removeSubviews {
    self.animationTime = 0;
    self.maskView.alpha = 0;
    self.maskView.isCanResponse = nil;
    self.maskView.responseAction = nil;
    for (UIView *subview in self.contentView.subviews) { if (subview != self.maskView) [subview removeFromSuperview]; }
    self.visualView.hidden = YES;
    self.visualView.alpha = 0;
    self.maskWindow.hidden = YES;
}

- (void)visibleSubview:(UIView *)view time:(NSTimeInterval)time blur:(BOOL)blur clear:(BOOL)clear action:(void (^)(void))action {
    [self removeSubviews];
    if (!view) return;
    self.maskWindow.hidden = NO;
    self.animationTime = time;
    self.visualView.hidden = !blur;
    self.maskView.backgroundColor = clear ? UIColor.clearColor : kColor(@"#000000");
    self.maskView.isCanResponse = ^BOOL(CGPoint focus) { return !CGRectContainsPoint(view.frame, focus); };
    self.maskView.responseAction = action;
    [self.contentView addSubview:view];
    [self.view setNeedsLayout];
    self.visualView.alpha = 0;
    self.maskView.alpha = 0;
    [UIView animateWithDuration:self.animationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.visualView.alpha = 1;
        self.maskView.alpha = TYMaskView.sharedView.maskAlpha;
    } completion:nil];
}

- (void)dismissSubview {
    [UIView animateWithDuration:self.animationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.visualView.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeSubviews];
    }];
}

@end


#pragma mark - ~ ZCWindowView ~
@implementation ZCWindowView

+ (void)display:(UIView *)subview time:(NSTimeInterval)time blur:(BOOL)blur clear:(BOOL)clear action:(void (^)(void))action {
    [[ZCMaskViewController sharedController] visibleSubview:subview time:time blur:blur clear:clear action:action];
}

+ (void)dismissSubview {
    [[ZCMaskViewController sharedController] dismissSubview];
}

@end

