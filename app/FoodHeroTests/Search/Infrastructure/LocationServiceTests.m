//
//  GoogleRestaurantSearchTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GoogleRestaurantSearch.h"
#import "LocationService.h"
#import "CLLocationManagerProxyStub.h"
#import "CLLocationManagerProxySpy.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"
#import "TyphoonComponents.h"
#import "AlwaysImmediateSchedulerFactory.h"


@interface LocationServiceTests : XCTestCase

@end

@implementation LocationServiceTests

- (LocationService *)service:(NSObject <CLLocationManagerProxy> *)clLocationManagerProxy {
    id <ISchedulerFactory> schedulerFactory = [AlwaysImmediateSchedulerFactory new];
    return [[LocationService alloc] initWithLocationManager:clLocationManagerProxy schedulerFactory:schedulerFactory];
}

- (LocationService *)serviceWithLocationManagerStub:(double)latitude longitude:(double)longitude {
    CLLocationManagerProxyStub *locationManagerProxy = [CLLocationManagerProxyStub new];
    LocationService *service = [self service:locationManagerProxy];

    [locationManagerProxy injectLatitude:latitude longitude:longitude];
    return service;
}

- (void)test_currentLocation_ShouldReturnLocation {
    LocationService *service = [self serviceWithLocationManagerStub:52.1234 longitude:1.298889];

    CLLocation * first = [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThatDouble(first.coordinate.latitude, is(equalToDouble(52.1234)));
    assertThatDouble(first.coordinate.longitude, is(equalToDouble(1.298889)));
}

- (void)test_currentLocation_ShouldWorkOnServeralCalls {
    LocationService *service = [self serviceWithLocationManagerStub:52.1234 longitude:1.298889];

    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];
    CLLocation *result = [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThat(result, is(notNilValue()));
}

- (void)test_currentLocation_ShouldOnlyReturnOneLocationAndComplete {
    LocationService *service = [self serviceWithLocationManagerStub:52.1234 longitude:1.298889];

    __block NSUInteger nrRetrievedValues = 0;
    RACSignal *signal = [service currentLocation];
    [signal subscribeNext:^(id next) {
        nrRetrievedValues++;
    }];
    __block BOOL hasCompleted = NO;
    [signal subscribeCompleted:^{
        hasCompleted = YES;
    }];

    assertThatUnsignedInt(nrRetrievedValues, is(equalToUnsignedInt(1)));
    assertThatBool(hasCompleted, is(@(YES)));
}

- (void)test_currentLocation_ShouldReturnNoLocationAndHaveError_WhenError {
    CLLocationManagerProxySpy *locationManagerProxy = [CLLocationManagerProxySpy new];
    LocationService *service = [self service:locationManagerProxy];

    [locationManagerProxy injectAuthorizationStatus:kCLAuthorizationStatusDenied];

    __block NSUInteger nrRetrievedValues = 0;
    RACSignal *signal = [service currentLocation];
    [signal subscribeNext:^(id next) {
        nrRetrievedValues++;
    }];
    __block BOOL hasCompleted = NO;
    [signal subscribeCompleted:^{
        hasCompleted = YES;
    }];
    __block BOOL hasError = NO;
    [signal subscribeError:^(NSError *error) {
        hasError = YES;
    }];

    assertThatUnsignedInt(nrRetrievedValues, is(equalToUnsignedInt(0)));
    assertThatBool(hasCompleted, is(@(NO)));
    assertThatBool(hasError, is(@(YES)));
}

- (void)test_currentLocation_ShouldStartAndStopLocationManager_WhenCompleted {
    CLLocationManagerProxySpy *locationManagerProxy = [CLLocationManagerProxySpy new];
    LocationService *service = [self service:locationManagerProxy];

    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThatUnsignedInt(locationManagerProxy.nrCallsForStartUpdatingLocation, is(equalToUnsignedInt(1)));
    assertThatUnsignedInt(locationManagerProxy.nrCallsForStopUpdatingLocation, is(equalToUnsignedInt(1)));

    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThatUnsignedInt(locationManagerProxy.nrCallsForStartUpdatingLocation, is(equalToUnsignedInt(2)));
    assertThatUnsignedInt(locationManagerProxy.nrCallsForStopUpdatingLocation, is(equalToUnsignedInt(2)));
}

- (void)test_currentLocation_ShouldStartAndStopLocationManager_WhenError {
    CLLocationManagerProxySpy *locationManagerProxy = [CLLocationManagerProxySpy new];
    LocationService *service = [self service:locationManagerProxy];

    [locationManagerProxy injectAuthorizationStatus:kCLAuthorizationStatusDenied];
    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThatUnsignedInt(locationManagerProxy.nrCallsForStartUpdatingLocation, is(equalToUnsignedInt(1)));
    assertThatUnsignedInt(locationManagerProxy.nrCallsForStopUpdatingLocation, is(equalToUnsignedInt(1)));
}

- (void)test_lastKnownLocation_ShouldReturnLastRetrievedLocation {
    CLLocationManagerProxyStub *locationManagerProxy = [CLLocationManagerProxyStub new];
    LocationService *service = [self service:locationManagerProxy];

    // retrieve location 1. time
    [locationManagerProxy injectLatitude:35.5 longitude:-60.2];
    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    CLLocation *lastKnownLocation = [service lastKnownLocation];
    assertThatDouble(lastKnownLocation.coordinate.latitude, is(equalTo(@(35.5))));
    assertThatDouble(lastKnownLocation.coordinate.longitude, is(equalTo(@(-60.2))));

    // retrieve location 2. time
    [locationManagerProxy injectLatitude:35.4 longitude:-61];
    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    lastKnownLocation = [service lastKnownLocation];
    assertThatDouble(lastKnownLocation.coordinate.latitude, is(equalTo(@(35.4))));
    assertThatDouble(lastKnownLocation.coordinate.longitude, is(equalTo(@(-61))));
}


- (void)test_lastKnownLocation_ShouldThrowException_WhenLocationHasNeverBeenDetermined {
    LocationService *service = [self service:[CLLocationManagerProxyStub new]];
    assertThat(^() {
        [service lastKnownLocation];
    }, throwsExceptionOfType([DesignByContractException class]));
}

@end
