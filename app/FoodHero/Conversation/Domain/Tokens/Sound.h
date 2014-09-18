//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Sound : NSObject
@property(nonatomic, readonly) NSString *file;
@property(nonatomic, readonly) NSString *type;
@property(nonatomic, readonly) float length;

+ (instancetype)create:(NSString *)file type:(NSString *)type length:(float)length;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToSound:(Sound *)sound;

- (NSUInteger)hash;

@end