//
// Created by E_BAKIR on 2019-04-25.
// Copyright (c) 2019 E_BAKIR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UXMenRequestElementData : NSObject

@property(nonatomic) double posX;
@property(nonatomic) double posY;

@property(nonatomic) double objWidth;
@property(nonatomic) double objHeight;

// FOR LIST AND SCROLLS
@property(nonatomic) double contentOffsetY;

@property(nonatomic, copy) NSString *parent;
@property(nonatomic, copy) NSString *viewIdentifier;

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *btnAction;

@end
