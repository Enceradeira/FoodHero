//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationSourceStub.h"
#import "USuggestionNegativeFeedback.h"


@implementation ConversationSourceStub {

    NSMutableArray *_negativeUserFeedback;
    NSString *_cuisine;
    PriceLevelRange *_range;
}

- (id)init {
    self = [super init];
    if (self) {
        _negativeUserFeedback = [NSMutableArray new];
        _range = [PriceLevelRange createFullRange];
    }

    return self;
}

- (void)addToken:(ConversationToken *)token {

}

- (NSArray *)negativeUserFeedback {
    return _negativeUserFeedback;
}

- (NSString *)cuisine {
    return _cuisine;
}

- (PriceLevelRange *)priceRange {
    return _range;
}


- (void)injectNegativeUserFeedback:(USuggestionNegativeFeedback *)feedback {
    [_negativeUserFeedback addObject:feedback];
}

- (void)injectCuisine:(NSString *)cuisine {
    _cuisine = cuisine;
}

- (void)injectPriceRange:(PriceLevelRange *)range {
    _range = range;
}
@end