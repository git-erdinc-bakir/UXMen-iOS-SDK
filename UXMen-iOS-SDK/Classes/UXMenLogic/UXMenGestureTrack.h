//
//  UXMenGestureTrack.h
//  UXMenGestureTrackDisplayDemo
//
//  Created by Daniel on 31/05/2017.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "UXMenTrackGesture.h"
#import "UXMenTouchUpdateModel.h"

@interface UIWindow (tracking)

- (void)startTracking;

- (NSMutableArray *)getTouchLocations;

- (void)endTracking;

- (void)removeFirstTouchRecord;

- (void)resetTouchRecords;

@end
