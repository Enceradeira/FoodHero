//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Place : NSObject
@property(nonatomic, readonly) NSString *placeId;

- (instancetype)initWithPlaceId:(NSString *)placeId;

+ (instancetype)createWithPlaceId:(NSString *)placeId;

@end