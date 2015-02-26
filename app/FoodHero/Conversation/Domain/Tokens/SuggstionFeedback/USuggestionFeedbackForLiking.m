//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForLiking.h"
#import "AddTokenAction.h"
#import "FHWhatToDoNextCommentAfterSuccess.h"
#import "FoodHero-Swift.h"

@implementation USuggestionFeedbackForLiking {
}

+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text {
    return [[USuggestionFeedbackForLiking alloc] initWithRestaurant:restaurant text:text type:@"Like"];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHWhatToDoNextCommentAfterSuccess new]];
}

+ (TalkerUtterance*)createUtterance:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location text:(NSString *)text  {
    USuggestionFeedbackParameters *parameters = [[USuggestionFeedbackParameters alloc] initWithSemanticId:@"U:SuggestionFeedback=Like" restaurant:restaurant currentUserLocation:location];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end