//
// Created by Jorg on 10/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <ReactiveCocoa.h>
#import "LocationDataManager.h"

@interface LocationDataManager ()
@property(atomic, readwrite) CLLocationCoordinate2D currentLocationHolder;
@end

@implementation LocationDataManager {
    CLLocationManager *_locationManager;
}

- (id)init {
    self = [super init];
    if (self != nil) {

        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
    }
    return self;
}

- (void)dealloc {
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:(locations.count - 1)];
    self.currentLocationHolder = location.coordinate;
}

- (RACSignal *)currentLocation {
    RACSignal *racSignal = [RACObserve(self, currentLocationHolder) filter:^(id next) {
        CLLocationCoordinate2D value;
        [(NSValue *) next getValue:&value];
        BOOL hasBeenInitialized = !(floor(value.longitude) == 0.0 && floor(value.latitude) == 0.0);
        return hasBeenInitialized;
    }];
    return racSignal;
}

@end