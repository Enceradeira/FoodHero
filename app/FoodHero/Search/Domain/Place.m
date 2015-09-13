//
// Created by Jorg on 20/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Place.h"


@implementation Place {

}
- (instancetype)initWithPlaceId:(NSString *)placeId location:(CLLocation *)location priceLevel:(NSUInteger)priceLevel cuisineRelevance:(double)cuisineRelevance {
    self = [super initWithPlaceId:placeId location:location cuisineRelevance:cuisineRelevance];
    if (self) {
        _priceLevel = priceLevel;
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToPlace1:other];
}

- (BOOL)isEqualToPlace1:(Place *)place {
    if (self == place)
        return YES;
    if (place == nil)
        return NO;
    if (![super isEqual:place])
        return NO;
    return self.priceLevel == place.priceLevel;
}

- (NSUInteger)hash {
    NSUInteger hash = [super hash];
    hash = hash * 31u + self.priceLevel;
    return hash;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _priceLevel = [coder decodeInt64ForKey:@"_priceLevel"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInt64:self.priceLevel forKey:@"_priceLevel"];
}


+ (instancetype)create:(NSString *)placeId location:(CLLocation *)location priceLevel:(NSUInteger)priceLevel cuisineRelevance:(double)cuisineRelevance {
    return [[Place alloc] initWithPlaceId:placeId location:location priceLevel:priceLevel cuisineRelevance:cuisineRelevance];
}



@end