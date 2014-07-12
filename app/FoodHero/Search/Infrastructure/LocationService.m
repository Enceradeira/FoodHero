//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "LocationService.h"

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

- (BOOL)isNotAuthorized {
    CLAuthorizationStatus status = [_locationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
            return YES;
        default:
            break;
    }
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:(locations.count - 1)];
    self.currentLocationHolder = location.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self wakeUpCurrentLocationObserverIfNotAuthorized];
}

- (void)wakeUpCurrentLocationObserverIfNotAuthorized {
    if (self.isNotAuthorized) {
        self.currentLocationHolder = _emptyCoordinate;
    }
}

- (RACSignal *)currentLocation {
    [_locationManager startUpdatingLocation];

    RACSignal *values = RACObserve(self, currentLocationHolder);

    RACSignal *valuesWithAuthorizationError = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        RACSerialDisposable *serialDisposable = [[RACSerialDisposable alloc] init];
        RACDisposable *sourceDisposable = [values subscribeNext:^(id next){
            if (self.isNotAuthorized) {
                NSError *error = [NSError new];
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:next];
            }

        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];

        serialDisposable.disposable = sourceDisposable;
        return serialDisposable;
    }];

    RACSignal *noneEmptyValues = [valuesWithAuthorizationError filter:^(id next) {
        CLLocationCoordinate2D value;
        [(NSValue *) next getValue:&value];
        BOOL hasBeenInitialized = !(floor(value.longitude) == 0.0 && floor(value.latitude) == 0.0);
        return hasBeenInitialized;
    }];

    RACSignal *oneNoneEmptyValue = [noneEmptyValues take:1];
    [oneNoneEmptyValue subscribeCompleted:^{
        [_locationManager stopUpdatingLocation];
    }];
    return oneNoneEmptyValue;
}

@end