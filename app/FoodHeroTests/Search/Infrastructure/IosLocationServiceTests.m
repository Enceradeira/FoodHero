//
//  GoogleRestaurantSearchTests.m
//  FoodHero
//
//  Created by Jorg on 08/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <ReactiveCocoa.h>
#import "GoogleRestaurantSearch.h"
#import "IosLocationService.h"

@interface IosLocationServiceTests : XCTestCase

@end

@implementation IosLocationServiceTests {
    IosLocationService *_service;
    NSString *_username;
}

- (void)setUp
{
    [super setUp];
    
    _service = [IosLocationService new];
}

-(void)test_currentLocation_ShouldReturnSignalForLocation
{
    RACSignal *signal = [_service currentLocation];

    [signal subscribeNext:^(id next){
          NSLog(@"Fund now");
    }]   ;

    // assertThatDouble(floor(location.longitude), isNot(equalToFloat(0)));
    //assertThatDouble(floor(location.latitude), isNot(equalToFloat(0)));
}



@end
