//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationSourceStub.h"


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
        _maxDistance = nil;
    }

    return self;
}

- (NSArray *)negativeUserFeedback {
    return _negativeUserFeedback;
}

- (SearchProfile *)currentSearchPreference:(double)maxDistancePlaces currUserLocation:(CLLocation *)location {
    return [SearchProfile createWithCuisine:_cuisine priceRange:_range maxDistance:_maxDistance occasion:[Occasions lunch]];
}

- (ConversationParameters *)lastSuggestionWarning {
    return nil;
}

- (NSString *)cuisine {
    return _cuisine;
}

- (PriceRange *)priceRange {
    return _range;
}


- (void)injectNegativeUserFeedback:(USuggestionFeedbackParameters *)feedback {
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