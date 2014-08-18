//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooFarAway.h"
#import "FHConfirmationIfInNewPreferredRangeCloser.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCloser.h"


@implementation USuggestionFeedbackForTooFarAway {

}

+ (instancetype)create:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location {
    return [[USuggestionFeedbackForTooFarAway alloc] initWithRestaurant:restaurant text:@"It's too far away" currentUserLocation:location];
}

- (id)initWithRestaurant:(Restaurant *)restaurant text:(NSString *)text currentUserLocation:(CLLocation *)location {
    self = [super initWithRestaurant:restaurant text:text];
    if (self != nil) {
        _currentUserLocation = location;
    }
    return self;
}

- (ConversationToken *)foodHeroConfirmationToken {
    return [FHConfirmationIfInNewPreferredRangeCloser create];
}

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant {
    return [FHSuggestionWithConfirmationIfInNewPreferredRangeCloser create:restaurant];
}

@end