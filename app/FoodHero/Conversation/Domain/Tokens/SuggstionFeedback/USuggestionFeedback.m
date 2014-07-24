//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedback.h"
#import "DesignByContractException.h"


@implementation USuggestionFeedback {
}

- (instancetype)initWithRestaurant:(Restaurant *)restaurant parameter:(NSString *)parameter {
    self = [super initWithParameter:@"U:SuggestionFeedback" parameter:parameter];
    if (self != nil) {
        _restaurant = restaurant;
    }
    return self;
}

- (ConversationToken *)foodHeroConfirmationToken {
    @throw [DesignByContractException createWithReason:@"method must be override in subclass"];
}
@end