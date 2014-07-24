//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooCheap.h"
#import "FHConfirmationIfInNewPreferredRangeMoreExpensive.h"


@implementation USuggestionFeedbackForTooCheap {

}

+ (instancetype)create:(Restaurant *)restaurant {
    return [[USuggestionFeedbackForTooCheap alloc] initWithRestaurant:restaurant parameter:@"It looks to cheap."];
}

- (ConversationToken *)foodHeroConfirmationToken {
    return [FHConfirmationIfInNewPreferredRangeMoreExpensive create];
}


@end