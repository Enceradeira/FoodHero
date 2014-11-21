//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooExpensive.h"
#import "FHConfirmationIfInNewPreferredRangeCheaper.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper.h"


@implementation USuggestionFeedbackForTooExpensive {

}

+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text {
    return [[USuggestionFeedbackForTooExpensive alloc] initWithRestaurant:restaurant text:text type:@"tooExpensive"];
}

- (ConversationToken *)foodHeroConfirmationToken {
    return [FHConfirmationIfInNewPreferredRangeCheaper create];
}

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant {
    return [FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper create:restaurant];
}

@end