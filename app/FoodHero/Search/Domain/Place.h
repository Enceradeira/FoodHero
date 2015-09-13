//
// Created by Jorg on 20/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlace.h"


@interface Place : GooglePlace
@property(nonatomic, readonly) NSUInteger priceLevel;

- (instancetype)initWithPlaceId:(NSString *)placeId location:(CLLocation *)location priceLevel:(NSUInteger)priceLevel cuisineRelevance:(double)cuisineRelevance;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToPlace1:(Place *)place;

- (NSUInteger)hash;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

+ (instancetype)create:(NSString *)placeId location:(CLLocation *)location priceLevel:(NSUInteger)priceLevel cuisineRelevance:(double)cuisineRelevance;
@end