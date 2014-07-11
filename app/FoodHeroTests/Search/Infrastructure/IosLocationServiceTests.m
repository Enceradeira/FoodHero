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
#import "IosLocationService.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "CLLocationManagerProxyStub.h"


@interface IosLocationServiceTests : XCTestCase

@end

@implementation IosLocationServiceTests {
    IosLocationService *_service;
    CLLocationManagerProxyStub *_locationManagerStub;
}

- (void)setUp
{
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];

    _locationManagerStub =  [CLLocationManagerProxyStub new];
    _service = [[IosLocationService alloc] initWithLocationManager:_locationManagerStub];
}

- (void)injectLatitude:(double)latitude longitude:(double)longitude {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;

    CLLocation *location = [[CLLocation new] initWithCoordinate:coordinate altitude:50 horizontalAccuracy:50 verticalAccuracy:50 course:0 speed:0 timestamp:[NSDate date]];
    [_locationManagerStub injectLocations:[NSArray arrayWithObject:location]];
}

-(void)test_currentLocation_ShouldReturnLocation
{
    [self injectLatitude:52.1234 longitude:1.298889];

    id first = [[_service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    CLLocationCoordinate2D value;
    [((NSValue*)first)getValue:&value];

    assertThatDouble(value.latitude, is(equalToDouble(52.1234)));
    assertThatDouble(value.longitude, is(equalToDouble(1.298889)));
}
-(void)test_currentLocation_ShouldWorkOnServeralCalls
{
    [self injectLatitude:52.1234 longitude:1.298889];

    [[_service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];
    id result = [[_service currentLocation] asynchronousFirstOrDefault:nil success:nil error:nil];

    assertThat(result, is(notNilValue()));
}

-(void)test_currentLocation_ShouldOnlyReturnOneLocationAndComplete{
    [self injectLatitude:52.1234 longitude:1.298889];

    __block NSUInteger nrRetrievedValues = 0;
    RACSignal *signal = [_service currentLocation];
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




@end
