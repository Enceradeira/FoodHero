//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <RACEXTScope.h>
#import "LocationService.h"
#import "LocationServiceAuthorizationStatusDeniedError.h"
#import "LocationServiceAuthorizationStatusRestrictedError.h"
#import "DesignByContractException.h"

@interface LocationService ()
@property(atomic, readwrite) CLLocationCoordinate2D currentLocationHolder;
@end

@implementation LocationService {
    NSObject <CLLocationManagerProxy> *_locationManager;
    CLLocationCoordinate2D _emptyCoordinate;
    CLLocation *_lastKnownLocation;
}

- (id)initWithLocationManager:(NSObject <CLLocationManagerProxy> *)locationManager {
    self = [super init];
    if (self != nil) {
        _locationManager = locationManager;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;

        _emptyCoordinate.latitude = 0;
        _emptyCoordinate.longitude = 0;
        _lastKnownLocation = nil;
    }
    return self;
}

- (NSError *)authorizationError {
    CLAuthorizationStatus status = [_locationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusRestricted:
            return [LocationServiceAuthorizationStatusRestrictedError new];
        case kCLAuthorizationStatusDenied:
            return [LocationServiceAuthorizationStatusDeniedError new];
        default:
            break;
    }
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:(locations.count - 1)];
    self.currentLocationHolder = location.coordinate;
    _lastKnownLocation = location;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self wakeUpCurrentLocationObserverIfNotAuthorized];
}

- (void)wakeUpCurrentLocationObserverIfNotAuthorized {
    if (self.authorizationError != nil) {
        self.currentLocationHolder = _emptyCoordinate;
    }
}

- (RACSignal *)currentLocation {
    @weakify(self);
    [_locationManager startUpdatingLocation];

    RACSignal *values = RACObserve(self, currentLocationHolder);

    RACSignal *valuesWithAuthorizationError = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        RACSerialDisposable *serialDisposable = [RACSerialDisposable new];
        RACDisposable *sourceDisposable = [values subscribeNext:^(id next){
            @strongify(self);
            NSError *error = self.authorizationError;
            if (error != nil) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:next];
            }

        }   error:^(NSError *error) {
            [subscriber sendError:error];
        }   completed:^{
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
    [oneNoneEmptyValue subscribeError:^(NSError* error){
        [_locationManager stopUpdatingLocation];
    }];
    return oneNoneEmptyValue;
}

- (CLLocation *)lastKnownLocation {
    if( _lastKnownLocation == nil){
        @throw [DesignByContractException createWithReason:@"lastKnownLocation is unkonwn. Location has never been determined"];
    }
    return _lastKnownLocation;
}


-(void)dealloc{
    _locationManager.delegate = nil;
}

@end