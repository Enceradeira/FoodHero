//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "GooglePlace.h"


@implementation GooglePlace {

}
+ (instancetype)createWithPlaceId:(NSString *)placeId location:(CLLocation *)location cuisineRelevance:(double)cuisineRelevance {
    return [[GooglePlace alloc] initWithPlaceId:placeId location:location cuisineRelevance:cuisineRelevance];
}

- (instancetype)initWithPlaceId:(NSString *)placeId location:(CLLocation *)location cuisineRelevance:(double)cuisineRelevance {
    self = [super init];
    if (self != nil) {
        _placeId = placeId;
        _location = location;
        _cuisineRelevance = cuisineRelevance;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_placeId forKey:@"_placeId"];
    [coder encodeObject:_location forKey:@"_location"];
    [coder encodeDouble:_cuisineRelevance forKey:@"_cuisineRelevance"];
}

- (id)initWithCoder:(NSCoder *)coder {
    return [self initWithPlaceId:[coder decodeObjectForKey:@"_placeId"]
                        location:[coder decodeObjectForKey:@"_location"]
                cuisineRelevance:[coder decodeDoubleForKey:@"_cuisineRelevance"]];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToPlace:other];
}

- (BOOL)isEqualToPlace:(GooglePlace *)place {
    if (self == place)
        return YES;
    if (place == nil)
        return NO;
    if (self.placeId != place.placeId && ![self.placeId isEqualToString:place.placeId])
        return NO;
    if (self.location != place.location && [self.location distanceFromLocation:place.location] != 0)
        return NO;
    return self.cuisineRelevance == place.cuisineRelevance;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.placeId hash];
    hash = hash * 31u + [self.location hash];
    hash = hash * 31u + [@(self.cuisineRelevance) hash];
    return hash;
}


@end