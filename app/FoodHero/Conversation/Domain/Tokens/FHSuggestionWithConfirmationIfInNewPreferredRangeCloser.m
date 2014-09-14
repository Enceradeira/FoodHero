//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCloser.h"
#import "AskUserSuggestionFeedbackAction.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeCloser {

}
+ (ConversationToken *)create:(Restaurant *)restaurant {
    return [[FHSuggestionWithConfirmationIfInNewPreferredRangeCloser alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:SuggestionWithConfirmationIfInNewPreferredRangeCloser";
}

- (NSString *)getText {
    return @"The '%@' is closer";
}

- (id <ConversationAction>)createAction {
    return [AskUserSuggestionFeedbackAction new];
}
@end