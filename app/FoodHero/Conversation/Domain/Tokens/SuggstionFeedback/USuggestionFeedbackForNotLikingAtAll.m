//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForNotLikingAtAll.h"


@implementation USuggestionFeedbackForNotLikingAtAll {

}

+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text {
    return [[USuggestionFeedbackForNotLikingAtAll alloc] initWithRestaurant:restaurant text:text type:@"Dislike"];
}

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant {
    return nil; // no FH:SuggestionWithComment is displayed when user just didn't like restaurant
}

- (ConversationToken *)foodHeroConfirmationToken {
    return nil; // no FH:Confirmation is displayed when user just didn't like the restaurant
}


@end