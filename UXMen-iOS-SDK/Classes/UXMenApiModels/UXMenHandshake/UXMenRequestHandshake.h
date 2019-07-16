//
// Created by E_BAKIR on 2019-04-25.
// Copyright (c) 2019 E_BAKIR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UXMenRequestHandshake : NSObject

@property(nonatomic) double ratio;

@property(nonatomic) double resolutionW;
@property(nonatomic) double resolutionH;

@property(nonatomic) double frameW;
@property(nonatomic) double frameH;

@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *device_name;

@end