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

+ (TalkerUtterance*)createUtterance:(NSString *)parameter text:(NSString *)text {
    UserParameters *parameters = [[UserParameters alloc] initWithSemanticId:@"U:SuggestionFeedback=Like" parameter:parameter];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end