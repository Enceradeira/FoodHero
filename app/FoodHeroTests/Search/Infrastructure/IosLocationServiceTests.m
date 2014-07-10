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


@interface IosLocationServiceTests : XCTestCase

@end

@implementation IosLocationServiceTests {
    IosLocationService *_service;
}

- (void)setUp
{
    [super setUp];
    
    _service = [IosLocationService new];
}

-(void)test_currentLocation_ShouldReturnLocation
{
    [[_service currentLocation] subscribeNext:^(id next){
        CLLocationCoordinate2D value;
        [((NSValue*)next)getValue:&value];

        assertThatDouble(value.latitude, isNot(equalTo(0)));
        assertThatDouble(value.longitude, isNot(equalTo(0)));

        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1.0];
}

-(void)test_currentLocation_ShouldWorkOnServeralCalls
{
    for(int i=0; i<2; i++) {
        [[_service currentLocation] subscribeNext:^(id next){
            [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
        }];
        [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1.0];
        [self XCA_notify:XCTAsyncTestCaseStatusUnknown];
    }
}

-(void)test_currentLocation_ShouldOnlyReturnOneLocation{
    __block NSUInteger nrRetrievedValues = 0;
    RACSignal *signal = [_service currentLocation];
     [signal subscribeNext:^(id next){
         nrRetrievedValues++;
    }];
    [signal subscribeCompleted:^(){
        assertThatUnsignedInt(nrRetrievedValues, is(equalToUnsignedInt(1)));
       [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1.0];
}




@end
