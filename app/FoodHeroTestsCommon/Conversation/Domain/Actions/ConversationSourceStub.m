//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationSourceStub.h"
#import "USuggestionNegativeFeedback.h"
#import "SearchProfile.h"
#import "DistanceRange.h"


@implementation ConversationSourceStub {

    NSMutableArray *_negativeUserFeedback;
    NSString *_cuisine;
    PriceRange *_range;
    DistanceRange *_maxDistance;
}

- (id)init {
    self = [super init];
    if (self) {
        _negativeUserFeedback = [NSMutableArray new];
        _range = [PriceRange priceRangeWithoutRestriction];
        _maxDistance = [DistanceRange distanceRangeWithoutRestriction];
    }

    return self;
}

- (void)addFHToken:(ConversationToken *)token {

}

- (NSArray *)negativeUserFeedback {
    return _negativeUserFeedback;
}

- (SearchProfile *)currentSearchPreference {
    return [SearchProfile createWithCuisine:_cuisine priceRange:_range maxDistance:_maxDistance];
}

- (ConversationToken *)lastSuggestionWarning {
    return nil;
}

- (NSString *)cuisine {
    return _cuisine;
}

- (PriceRange *)priceRange {
    return _range;
}


- (void)injectNegativeUserFeedback:(USuggestionNegativeFeedback *)feedback {
    [_negativeUserFeedback addObject:feedback];
}

- (void)injectCuisine:(NSString *)cuisine {
    _cuisine = cuisine;
}

- (void)injectPriceRange:(PriceRange *)range {
    _range = range;
}

- (void)injectMaxDistance:(DistanceRange *)maxDistance {
    _maxDistance = maxDistance;
}
@end