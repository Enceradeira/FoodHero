//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <XCTest/XCTest.h>
#import "RestaurantSearchTests.h"
#import "Restaurant.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "RestaurantSearch.h"
#import "DesignByContractException.h"


@implementation RestaurantSearchTests {
    NSMutableArray *_userFeedback;
}

- (void)setUp {
    [super setUp];

    _userFeedback = [NSMutableArray new];
}

- (RestaurantSearch *)search {
    @throw  [DesignByContractException createWithReason:@"method must be overriden by subclass"];
}

- (Restaurant *)findBest {
    __block Restaurant *restaurant;
    RACSignal *signal = [self.search findBest:_userFeedback];
    [signal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    return restaurant;
}

- (void)feedbackIs:(USuggestionFeedbackForNotLikingAtAll *)feedback {
    [_userFeedback addObject:feedback];
}
@end