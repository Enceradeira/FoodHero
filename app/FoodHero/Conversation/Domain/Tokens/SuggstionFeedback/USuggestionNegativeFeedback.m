//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionNegativeFeedback.h"
#import "DesignByContractException.h"
#import "SearchAction.h"


@implementation USuggestionNegativeFeedback {
}

- (ConversationToken *)foodHeroConfirmationToken {
    @throw [DesignByContractException createWithReason:@"method must be overriden in subclass"];
}

- (ConversationToken *)getFoodHeroSuggestionWithCommentToken:(Restaurant *)restaurant {
    @throw [DesignByContractException createWithReason:@"method must be overriden in subclass"];
}

- (id <ConversationAction>)createAction {
    return [SearchAction new];
}

@end