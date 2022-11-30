//
//  ZCScrollView.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCScrollView.h"
#define LINE_HEIGHT    1.0/[[UIScreen mainScreen] scale]

@interface UIScrollView ()

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end



@interface ZCScrollView ()

@end

@implementation ZCScrollView

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.contentOffset.y != 0) {
        self.contentOffset = CGPointMake(self.contentOffset.x, 0);
    }
}

- (ZCScrollView *)initWithFrame:(CGRect)frame isPaging:(BOOL)isPaging bouncesStyle:(int)bouncesStyle isThrough:(BOOL)isThrough {
    if (self = [self initWithFrame:frame]) {
        self.isThrough = isThrough;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = UIColor.clearColor;
        self.directionalLockEnabled = YES;
        self.pagingEnabled = isPaging;
        self.bounces = bouncesStyle > 0;
        self.alwaysBounceVertical = bouncesStyle & 2;
        self.alwaysBounceHorizontal = bouncesStyle & 1;
        self.contentSize = CGSizeMake(frame.size.width + ((bouncesStyle & 1) ? LINE_HEIGHT : 0), frame.size.height + ((bouncesStyle & 2) ? LINE_HEIGHT : 0));
    } return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isThrough) {
        [[self nextResponder] touchesBegan:touches withEvent:event];
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isThrough) {
        [[self nextResponder] touchesMoved:touches withEvent:event];
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isThrough) {
        [[self nextResponder] touchesEnded:touches withEvent:event];
        [super touchesEnded:touches withEvent:event];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.isPriorityEditGestures && touch.view && [NSStringFromClass(touch.view.class) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([super respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)]) {
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    } return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self isCanPanBack:gestureRecognizer]) {
        return NO;
    }
    if ([super respondsToSelector:@selector(gestureRecognizerShouldBegin:)]) {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    } return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self isCanPanBack:gestureRecognizer]) {
        return YES;
    }
    if ([super respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    } return NO;
}

- (BOOL)isCanPanBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view && gestureRecognizer == self.panGestureRecognizer && [gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIGestureRecognizerState state = gestureRecognizer.state;
        CGFloat screen_width = UIScreen.mainScreen.bounds.size.width;
        if ((self.frame.size.width >= screen_width - 60) && (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible)) {
            CGPoint verocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
            CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
            CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
            if (self.contentOffset.x <= 0 && point.x > 0 && location.x <= 40 && (fabs(verocity.x) - fabs(verocity.y)) > 0 && verocity.x > 0) {
                //if (![self isHasShowBox]) { return YES; }
                return YES;
            }
        }
    } return NO;
}

//- (BOOL)isHasShowBox {
//    BOOL isHas = NO;
//    UIViewController *vc = self.currentViewController;
//    if (!isHas && vc.view) {
//        isHas = [self isHasBoxView:vc.view.subviews isFinal:NO];
//    }
//    if (!isHas && vc.navigationController.view) {
//        isHas = [self isHasBoxView:vc.navigationController.view.subviews isFinal:NO];
//    }
//    if (!isHas && vc.tabBarController.view) {
//        isHas = [self isHasBoxView:vc.tabBarController.view.subviews isFinal:NO];
//    }
//    return isHas;
//}
//
//- (BOOL)isHasBoxView:(NSArray <UIView *>*)subviews isFinal:(BOOL)isFinal {
//    BOOL isHasBox = NO;
//    if (subviews && subviews.count) {
//        for (UIView *itemView in subviews) {
//            if ([itemView isKindOfClass:NSClassFromString(@"TYBoxView")]) {
//                isHasBox = YES; break;
//            }
//            if (!isFinal && [itemView isKindOfClass:UIView.class] && [self isHasBoxView:itemView.subviews isFinal:YES]) {
//                isHasBox = YES; break;
//            }
//        }
//    } return isHasBox;
//}

@end
