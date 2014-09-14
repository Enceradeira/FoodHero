//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionAsFollowUp.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation FHSuggestionAsFollowUp {

}
+ (instancetype)create:(Restaurant *)restaurant {
    return [[FHSuggestionAsFollowUp alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:SuggestionAsFollowUp";
}

- (NSString *)getText {
    return @"What about '%@' then?";
}

- (id <ConversationAction>)createAction {
    return [AskUserSuggestionFeedbackAction new];
}

@end