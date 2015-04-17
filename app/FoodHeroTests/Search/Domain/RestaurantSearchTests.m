//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <XCTest/XCTest.h>
#import "RestaurantSearchTests.h"
#import "DesignByContractException.h"
#import "RestaurantRepository.h"
#import "CLLocationManagerProxyStub.h"
#import "GoogleRestaurantSearch.h"
#import "DistanceRange.h"
#import "ConversationSourceStub.h"
#import "RestaurantSearchResult.h"


@implementation RestaurantSearchTests {
}

- (void)setUp {
    [super setUp];

    _conversation = [ConversationSourceStub new];
}

- (RestaurantSearch *)search {
    @throw  [DesignByContractException createWithReason:@"method must be overriden by subclass"];
}

- (RestaurantSearchResult *)findBest {
    __block RestaurantSearchResult *result;
    RACSignal *signal = [self.search findBest:_conversation];
    [signal subscribeNext:^(RestaurantSearchResult *r) {
        result = r;
    }];
    [signal asynchronouslyWaitUntilCompleted:nil];
    return result;
}

- (void)conversationHasCuisine:(NSString *)cuisine {
    [_conversation injectCuisine:cuisine];
}

- (void)conversationHasPriceRange:(PriceRange *)range {
    [_conversation injectPriceRange:range];
}


- (void)conversationHasNegativeUserFeedback:(USuggestionFeedbackParameters *)feedback {
    [_conversation injectNegativeUserFeedback:feedback];
}

@end
