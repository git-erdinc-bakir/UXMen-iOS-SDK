//
// Created by E_BAKIR on 2019-04-25.
// Copyright (c) 2019 E_BAKIR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UXMenRequestHandshake;
@class UXMenResponseHandshake;
@class UXMenRequestStory;

/*
@protocol UXMenAPIDelegate <NSObject>

- (void)returnWithUXMenHandshake:(UXMenResponseHandshake *)handshakeResponse;

- (void)returnWithUXMenWireframe:(int)status;

- (void)returnWithUXMenActionBulk:(int)status;

- (void)returnWithUXMenApiError:(NSString *)apiCode;

@end
*/

@interface UXMenAPI : NSObject

// @property(nonatomic, strong) id <UXMenAPIDelegate> delegate;

- (void)configure;

- (NSMutableArray *)getViewComponents;

- (NSMutableArray *)getTouchLocations;

- (NSMutableArray *)getTouchWeights;

- (void)handshake:(UXMenRequestHandshake *)requestHandshake;

//- (void)sendWireframe:(UXMenRequestWireFrame *)requestWireFrame;
//
//- (void)sendActionBulk:(UXMenRequestActionStory *)requestActionBulk;

- (void)sendStory:(UXMenRequestStory *)requestStory;

@end