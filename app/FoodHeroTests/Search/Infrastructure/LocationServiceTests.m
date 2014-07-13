//
//  GoogleRestaurantSearchTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <ReactiveCocoa.h>
#import "XCTestCase+AsyncTesting.h"
#import "GoogleRestaurantSearch.h"
#import "LocationService.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "CLLocationManagerProxyStub.h"
#import "CLLocationManagerProxySpy.h"


@interface LocationServiceTests : XCTestCase

@end

@implementation LocationServiceTests {
}

- (void)setUp
{
    [super setUp];

    [self service:[CLLocationManagerProxyStub new]];
}

- (LocationService *)service:(NSObject<CLLocationManagerProxy>*)clLocationManagerProxy {
    return  [[LocationService alloc] initWithLocationManager:clLocationManagerProxy];
}

- (LocationService *)serviceWithLocationManagerStub:(double)latitude longitude:(double)longitude{
    CLLocationManagerProxyStub *locationManagerProxy = [CLLocationManagerProxyStub new];
    LocationService *service = [self service:locationManagerProxy];

    [locationManagerProxy injectLatitude:latitude longitude:longitude];
    return service;
}

-(void)test_currentLocation_ShouldReturnLocation
{
    LocationService *service = [self serviceWithLocationManagerStub:52.1234 longitude:1.298889];

    id first = [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    CLLocationCoordinate2D value;
    [((NSValue*)first)getValue:&value];

    assertThatDouble(value.latitude, is(equalToDouble(52.1234)));
    assertThatDouble(value.longitude, is(equalToDouble(1.298889)));
}
-(void)test_currentLocation_ShouldWorkOnServeralCalls
{
    LocationService *service = [self serviceWithLocationManagerStub:52.1234 longitude:1.298889];

    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];
    id result = [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThat(result, is(notNilValue()));
}

-(void)test_currentLocation_ShouldOnlyReturnOneLocationAndComplete{
     LocationService *service = [self serviceWithLocationManagerStub:52.1234 longitude:1.298889];

    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    __block NSUInteger nrRetrievedValues = 0;
    RACSignal *signal = [service currentLocation];
    [signal subscribeNext:^(id next){
         nrRetrievedValues++;
    }];
    __block BOOL hasCompleted = NO;
    [signal subscribeCompleted:^{
        hasCompleted = YES;
    }];

    assertThatUnsignedInt(nrRetrievedValues, is(equalToUnsignedInt(1)));
    assertThatBool(hasCompleted, is(equalToBool(YES)));
}

-(void)test_currentLocation_ShouldStartAndStopLocationManager{
    CLLocationManagerProxySpy *locationManagerProxy = [CLLocationManagerProxySpy new];
    LocationService *service = [self service:locationManagerProxy];

    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThatUnsignedInt(locationManagerProxy.nrCallsForStartUpdatingLocation, is(equalToUnsignedInt(1)));
    assertThatUnsignedInt(locationManagerProxy.nrCallsForStopUpdatingLocation, is(equalToUnsignedInt(1)));

    [[service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThatUnsignedInt(locationManagerProxy.nrCallsForStartUpdatingLocation, is(equalToUnsignedInt(2)));
    assertThatUnsignedInt(locationManagerProxy.nrCallsForStopUpdatingLocation, is(equalToUnsignedInt(2)));
}



@end
