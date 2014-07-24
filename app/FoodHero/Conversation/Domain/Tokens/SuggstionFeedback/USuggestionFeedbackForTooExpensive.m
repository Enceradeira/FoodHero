//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooExpensive.h"
#import "FHConfirmationIfInNewPreferredRangeCheaper.h"


@implementation USuggestionFeedbackForTooExpensive {

}

+ (instancetype)create:(Restaurant *)restaurant {
    return [[USuggestionFeedbackForTooExpensive alloc] initWithRestaurant:restaurant parameter:@"It looks too expensive."];
}

- (ConversationToken *)foodHeroConfirmationToken {
    return [FHConfirmationIfInNewPreferredRangeCheaper create];
}

@end