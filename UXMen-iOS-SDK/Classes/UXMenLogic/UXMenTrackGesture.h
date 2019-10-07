//
//  UXMenTrackGesture.h
//  UXMenGestureTrackDisplayDemo
//
//  Created by Daniel on 31/05/2017.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UXMenGestureDelegate <NSObject>

- (void)forTouchesBegan:(NSSet *)touches;

- (void)forTouchesMoved:(NSSet *)touches;

- (void)forTouchesEnded:(NSSet *)touches;

- (void)forTouchesCancelled:(NSSet *)touches;

@end

@interface UXMenTrackGesture : UIGestureRecognizer <UIGestureRecognizerDelegate>

@property (readonly) NSSet *activeTouches;

@property (nonatomic, weak) NSObject<UXMenGestureDelegate>* touchDelegate;

- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithTarget:(id)target action:(SEL)action NS_UNAVAILABLE;

@end
