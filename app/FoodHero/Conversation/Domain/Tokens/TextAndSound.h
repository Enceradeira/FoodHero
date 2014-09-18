//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sound.h"


@interface TextAndSound : NSObject
@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) Sound *sound;

+ (instancetype)create:(NSString *)text;

+ (instancetype)create:(NSString *)text sound:(Sound *)sound;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToSound:(TextAndSound *)sound;

- (NSUInteger)hash;

@end