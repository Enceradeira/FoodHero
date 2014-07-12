//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "LocationService.h"
#import "LocationServicesNotAvailableException.h"

@interface LocationService ()
@property(atomic, readwrite) CLLocationCoordinate2D currentLocationHolder;
@end

@implementation LocationService {
    NSObject <CLLocationManagerProxy> *_locationManager;
    CLLocationCoordinate2D _emptyCoordinate;
}

- (id)initWithLocationManager:(NSObject <CLLocationManagerProxy> *)locationManager {
    self = [super init];
    if (self != nil) {
        _locationManager = locationManager;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;

        _emptyCoordinate.latitude = 0;
        _emptyCoordinate.longitude = 0;
    }
    return self;
}

- (void)doIfNotAuthorized:(void (^)())action {
    CLAuthorizationStatus status = [_locationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
            action();
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:(locations.count - 1)];
    self.currentLocationHolder = location.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self wakeUpCurrentLocationObserver];
}

- (void)wakeUpCurrentLocationObserver {
    [self doIfNotAuthorized:^(){
        self.currentLocationHolder = _emptyCoordinate;
    }];
}

- (RACSignal *)currentLocation {
    [self throwExceptionIfNotAuthorized];

    [_locationManager startUpdatingLocation];

    RACSignal *allCoordinates = [RACObserve(self, currentLocationHolder) filter:^(id next) {
        [self throwExceptionIfNotAuthorized];
        CLLocationCoordinate2D value;
        [(NSValue *) next getValue:&value];
        BOOL hasBeenInitialized = !(floor(value.longitude) == 0.0 && floor(value.latitude) == 0.0);
        return hasBeenInitialized;
    }];

    RACSignal *oneCoordinate = [allCoordinates take:1];
    [oneCoordinate subscribeCompleted:^{
        [_locationManager stopUpdatingLocation];
    }];
    return oneCoordinate;
}

- (void)throwExceptionIfNotAuthorized {
    [self doIfNotAuthorized:^(){
        @throw [LocationServicesNotAvailableException new];
    }];
}

@end