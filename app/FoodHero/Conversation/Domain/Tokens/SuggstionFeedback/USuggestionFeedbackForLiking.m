//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForLiking.h"
#import "AddTokenAction.h"
#import "FHWhatToDoNextAfterSuccess.h"

@implementation USuggestionFeedbackForLiking {
}

+ (instancetype)create:(Restaurant *)restaurant {
    NSString *text = @"I like it";
    return [[USuggestionFeedbackForLiking alloc] initWithRestaurant:restaurant text:text];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHWhatToDoNextAfterSuccess new]];
}

@end