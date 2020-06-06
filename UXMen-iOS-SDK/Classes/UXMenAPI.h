//
// Created by E_BAKIR on 2019-04-25.
// Copyright (c) 2019 E_BAKIR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXMenGestureTrack.h"

@class UXMenRequestHandshake;
@class UXMenResponseHandshake;
@class UXMenRequestStory;
@class AppDelegate;

@protocol UXMenAPIDelegate <NSObject>
/*
- (void)returnWithUXMenHandshake:(UXMenResponseHandshake *)handshakeResponse;

- (void)returnWithUXMenWireframe:(int)status;

- (void)returnWithUXMenActionBulk:(int)status;

- (void)returnWithUXMenApiError:(NSString *)apiCode;
*/
@end

@interface UXMenAPI : NSObject

// @property(nonatomic, strong) id <UXMenAPIDelegate> delegate;

+ (UXMenAPI *)shared;

- (void)startTracking:(UIWindow *)window;

- (void)configure:(NSString *)uxmenAppId andSecretKey:(NSString *)uxmenSecretKey;

- (void)handShakeWithToken:(NSString *)token;

- (void)sendStory:(UXMenRequestStory *)requestStory;

- (NSMutableArray *)getViewComponents;

- (NSMutableArray *)getTouchLocations;

@end
