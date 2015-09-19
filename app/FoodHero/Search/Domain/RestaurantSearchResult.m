//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import "RestaurantSearchResult.h"


@implementation RestaurantSearchResult {

}

- (instancetype)initWithRestaurant:(Restaurant *)restaurant searchParams:(SearchProfile *)searchParams {
    self = [super init];
    if (self != nil) {
        _restaurant = restaurant;
        _searchParams = searchParams;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
       _restaurant = [coder decodeObjectForKey:@"_restaurant"];
        _searchParams = [coder decodeObjectForKey:@"_searchParams"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.restaurant forKey:@"_restaurant"];
    [coder encodeObject:self.searchParams forKey:@"_searchParams"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToResult:other];
}

- (BOOL)isEqualToResult:(RestaurantSearchResult *)result {
    if (self == result)
        return YES;
    if (result == nil)
        return NO;
    if (self.restaurant != result.restaurant && ![self.restaurant isEqualToRestaurant:result.restaurant])
        return NO;
    if (self.searchParams != result.searchParams && ![self.searchParams isEqual:result.searchParams])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.restaurant hash];
    hash = hash * 31u + [self.searchParams hash];
    return hash;
}


@end