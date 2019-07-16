//
// Created by E_BAKIR on 2019-04-25.
// Copyright (c) 2019 E_BAKIR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UXMenRequestStory : NSObject

@property(nonatomic) double timestamp;

@property(nonatomic, copy) NSString *session_id;
@property(nonatomic, copy) NSString *page;

@property(nonatomic, strong) NSMutableArray *wireframes;

@property(nonatomic, strong) NSMutableArray *actions;

@end
