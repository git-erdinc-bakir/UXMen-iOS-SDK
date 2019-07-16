//
//  UXMenGestureTrack.h
//  UXMenGestureTrackDisplayDemo
//
//  Created by Daniel on 31/05/2017.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "UXMenTrackGesture.h"

@interface UIWindow (tracking)

- (void)handshake;

- (void)startTracking;

- (NSMutableArray *)getTouchLocations;
- (NSMutableArray *)getTouchWeights;

- (void)endTracking;

- (void)resetTouchRecords;
@end
