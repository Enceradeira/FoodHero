//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <XCTest/XCTest.h>
#import "RestaurantSearchTests.h"
#import "DesignByContractException.h"
#import "ConversationSourceStub.h"


@implementation RestaurantSearchTests {
    ConversationSourceStub *_conversation;
}

- (void)setUp {
    [super setUp];

    _conversation = [ConversationSourceStub new];
}

- (RestaurantSearch *)search {
    @throw  [DesignByContractException createWithReason:@"method must be overriden by subclass"];
}

- (Restaurant *)findBest {
    __block Restaurant *restaurant;
    RACSignal *signal = [self.search findBest:_conversation];
    [signal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    return restaurant;
}

- (void)conversationHasCuisine:(NSString *)cuisine {
    [_conversation injectCuisine:cuisine];
}

- (void)conversationHasPriceRange:(PriceLevelRange *)range {
    [_conversation injectPriceRange:range];
}


- (void)conversationHasNegativeUserFeedback:(USuggestionNegativeFeedback *)feedback {
    [_conversation injectNegativeUserFeedback:feedback];
}
@end