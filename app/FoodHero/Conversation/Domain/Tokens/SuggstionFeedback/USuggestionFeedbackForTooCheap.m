//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooCheap.h"
#import "FHConfirmationIfInNewPreferredRangeMoreExpensive.h"
#import "FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive.h"


@implementation USuggestionFeedbackForTooCheap {

}

+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text {
    return [[USuggestionFeedbackForTooCheap alloc] initWithRestaurant:restaurant text:text type:@"tooCheap"];
}

- (ConversationToken *)foodHeroConfirmationToken {
    return [FHConfirmationIfInNewPreferredRangeMoreExpensive create];
}

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant {
    return [FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive create:restaurant];
}

+ (TalkerUtterance*)createUtterance:(NSString *)parameter text:(NSString *)text {
    UserParameters *parameters = [[UserParameters alloc] initWithSemanticId:@"U:SuggestionFeedback=tooCheap" parameter:parameter];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end