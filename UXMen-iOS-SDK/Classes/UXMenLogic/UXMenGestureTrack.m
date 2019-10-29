//
//  UXMenGestureTrack.m
//  UXMenGestureTrackDisplayDemo
//
//  Created by Daniel on 31/05/2017.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "UXMenGestureTrack.h"

#import <objc/runtime.h>

#pragma mark - UXMenTrackGesture Category

@interface UXMenTrackGesture (Private)

+ (UXMenTrackGesture *)sharedInstace;

@end

#pragma mark -  UXMenGestureTrack

@interface UXMenGestureTrack : UIView <UXMenGestureDelegate>

@property(nonatomic, strong) UIColor *dotColor;

@property(nonatomic, assign) CGFloat dotWidth;

@property(nonatomic, strong) NSMutableArray *arrayTouches;

@end

@implementation UXMenGestureTrack {
    UXMenTrackGesture *touchGesture;
    NSMutableDictionary *dots;

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        [self finishInit];
    }
    return self;
}

- (void)finishInit {
    NSLog(@"finishInit");

    NSLog(@"TRACKER OTURUM BAŞLATILDI");
    _arrayTouches = [NSMutableArray new];

    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    touchGesture = [UXMenTrackGesture sharedInstace];
    [touchGesture setTouchDelegate:self];
    dots = [NSMutableDictionary dictionary];

    self.dotWidth = 44;
    self.dotColor = [UIColor lightGrayColor];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
}

- (void)setDotColor:(UIColor *)dotColor {
    NSLog(@"setDotColor");

    if (!dotColor) {
        dotColor = [UIColor lightGrayColor];
    }
    _dotColor = dotColor;
}

- (void)updateTouch:(UITouch *)t {
    NSLog(@"updateTouch");

    NSMutableSet *seenKeys = [NSMutableSet set];
    CGPoint loc = [t locationInView:self];

    UXMenTouchUpdateModel *modelTouch = [UXMenTouchUpdateModel new];
    modelTouch.weight = @1;

    NSDate *currentDate = [NSDate date];
    double timestamp = [currentDate timeIntervalSince1970];
    modelTouch.timestamp = timestamp;

    modelTouch.touchLocation = [NSValue valueWithCGPoint:CGPointMake(loc.x, loc.y)];

    UIViewController *topViewController = [UIViewController new];
    topViewController.view = [UIView new];

    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        //        NSLog(@"getViewComponents UINavigationController class");
        UINavigationController *controller = (UINavigationController *) self.window.rootViewController;
        topViewController = [[controller viewControllers] lastObject];

    } else if ([self.window.rootViewController isKindOfClass:[UIViewController class]]) {
        //        NSLog(@"getViewComponents UIViewController class");
        topViewController = self.window.rootViewController;

    } else {
        NSLog(@"getViewComponents class");
        NSLog(@"%@", [NSString stringWithFormat:@"%@", [self.window.rootViewController class]]);

    }
    modelTouch.pageName = NSStringFromClass([topViewController class]);

    [_arrayTouches addObject:modelTouch];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UXMenTouchNotification" object:self];

    // NSValue *val = modelTouch.touchLocation;
    // CGPoint p = [val CGPointValue];
    // NSLog(@"TIKLANAN KOORDİNAT X:%f Y:%f", p.x, p.y);

    NSNumber *key = @(t.hash);
    [seenKeys addObject:key];

    UIView *dot = dots[key];

    if (!dot) {
        dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dotWidth, _dotWidth)];
        dot.backgroundColor = _dotColor;
        dot.layer.cornerRadius = _dotWidth / 2;
        dot.tag = key.unsignedIntegerValue;
        [self addSubview:dot];
        dots[key] = dot;

        UIView *anim = [[UIView alloc] initWithFrame:dot.frame];
        anim.opaque = NO;
        anim.backgroundColor = [UIColor clearColor];
        anim.layer.cornerRadius = _dotWidth / 2;
        anim.layer.borderColor = _dotColor.CGColor;
        anim.layer.borderWidth = 3;
        anim.center = loc;
        anim.tag = NSUIntegerMax;
        [self addSubview:anim];
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            anim.transform = CGAffineTransformMakeScale(1.5, 1.5);
            anim.alpha = 0;
        }                completion:^(BOOL finished) {
            [anim removeFromSuperview];
        }];
    }
    dot.center = loc;
}

- (void)removeViewFor:(UITouch *)t {
    NSLog(@"removeViewFor");

    NSNumber *key = @(t.hash);
    UIView *dot = dots[key];
    [dot removeFromSuperview];
    [dots removeObjectForKey:key];
}

- (void)didMoveToSuperview {
    NSLog(@"didMoveToSuperview");

    [touchGesture.view removeGestureRecognizer:touchGesture];
    [self.superview addGestureRecognizer:touchGesture];
}

- (void)forTouchesBegan:(NSSet *)touches {
    NSLog(@"forTouchesBegan");

    NSArray *siblings = self.superview.subviews;
    if ([siblings indexOfObject:self] != [siblings count] - 1) {
        // ensure we are the top most view
        [self.superview addSubview:self];
    }
    for (UITouch *t in touches) {
        [self updateTouch:t];
    }
}

- (void)forTouchesMoved:(NSSet *)touches {
    NSLog(@"forTouchesMoved");

    for (UITouch *t in touches) {
        [self updateTouch:t];
    }
}

- (void)forTouchesEnded:(NSSet *)touches {
    NSLog(@"forTouchesEnded");

    for (UITouch *t in touches) {
        [self removeViewFor:t];
    }
}

- (void)forTouchesCancelled:(NSSet *)touches {
    NSLog(@"forTouchesCancelled");

    for (UITouch *t in touches) {
        [self removeViewFor:t];
    }
}

#pragma mark - Ignore Touches

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest");

    return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"pointInside");

    return NO;
}

@end


const static char *UXMenGestureTrackView = "UXMenGestureTrackView";

@implementation UIWindow (tracking)

- (void)startTracking {
    NSLog(@"startTracking");

    self.for_track = [[UXMenGestureTrack alloc] initWithFrame:self.bounds];
    self.for_track.layer.zPosition = CGFLOAT_MAX;

    [self addSubview:self.for_track];

}

- (NSMutableArray *)getTouchLocations {
    return self.for_track.arrayTouches;
}

- (void)removeFirstTouchRecord {
    [self.for_track.arrayTouches removeObjectAtIndex:0];
}

- (void)resetTouchRecords {
    [self.for_track.arrayTouches removeAllObjects];
}

- (void)endTracking {
    NSLog(@"endTracking");

    if (self.for_track) {
        [self.for_track removeFromSuperview];
        self.for_track = nil;
    }
}

- (void)setFor_track:(UXMenGestureTrack *)for_track {
    NSLog(@"setFor_track");

    objc_setAssociatedObject(self, UXMenGestureTrackView, for_track, OBJC_ASSOCIATION_RETAIN);
}

- (UXMenGestureTrack *)for_track {
    id obj = objc_getAssociatedObject(self, UXMenGestureTrackView);
    if ([obj isKindOfClass:[UXMenGestureTrack class]]) {
        return (UXMenGestureTrack *) obj;
    }
    return nil;
}

@end


