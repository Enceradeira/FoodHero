//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooFarAway.h"
#import "FHConfirmationIfInNewPreferredRangeCloser.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCloser.h"


@implementation USuggestionFeedbackForTooFarAway {

}

+ (instancetype)create:(Restaurant *)restaurant {
    return [[USuggestionFeedbackForTooFarAway alloc] initWithRestaurant:restaurant text:@"It's too far away"];
}

- (ConversationToken *)foodHeroConfirmationToken {
    return [FHConfirmationIfInNewPreferredRangeCloser create];
}

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant {
    return [FHSuggestionWithConfirmationIfInNewPreferredRangeCloser create:restaurant];
}

@end