//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "SearchProfile.h"


@interface RestaurantSearchResult : NSObject <NSCoding>
@property (nonatomic, readonly) Restaurant* restaurant;
@property (nonatomic, readonly) SearchProfile* searchParams;

-(instancetype)initWithRestaurant:(Restaurant*)restaurant searchParams:(SearchProfile*)searchParams;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToResult:(RestaurantSearchResult *)result;

- (NSUInteger)hash;

@end