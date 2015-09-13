//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPhoto.h"


@interface GooglePhoto : NSObject <IPhoto, NSCoding>
- (id)initWithReference:(NSString *)reference height:(NSUInteger)height width:(NSUInteger)width loadEagerly:(BOOL)loadEagerly;

+ (instancetype)create:(NSString *)photoReference height:(NSUInteger)height width:(NSUInteger)width loadEagerly:(BOOL)loadEagerly;

- (RACSignal *)image;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToPhoto:(GooglePhoto *)photo;

- (NSUInteger)hash;
@end
