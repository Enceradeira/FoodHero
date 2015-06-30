//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import "CuisineAndOccasion.h"


@implementation CuisineAndOccasion {

}
- (instancetype)initWithOccasion:(NSString *)occasion cuisine:(NSString *)cuisine location:(CLLocation *)location {
    self = [super init];
    if (self != nil) {
        _occasion = occasion;
        _cuisine = cuisine;
        _location = location;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object class] == self.class) {
        CuisineAndOccasion *cusineAndOccasion = (CuisineAndOccasion *) object;

        CLLocationCoordinate2D otherCoordinate = cusineAndOccasion.location.coordinate;
        CLLocationCoordinate2D thisCoordinate = _location.coordinate;
        return ([cusineAndOccasion.occasion isEqualToString:_occasion] || (cusineAndOccasion.occasion == nil && _occasion == nil))
                && ([cusineAndOccasion.cuisine isEqualToString:_cuisine] || (cusineAndOccasion.cuisine == nil && _cuisine == nil))
                && (thisCoordinate.latitude == otherCoordinate.latitude && thisCoordinate.longitude == otherCoordinate.longitude);

    }
    return false;
}

@end