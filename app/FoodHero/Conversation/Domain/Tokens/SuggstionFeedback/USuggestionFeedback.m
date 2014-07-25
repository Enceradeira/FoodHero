//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedback.h"
#import "Restaurant.h"
#import "ConversationSource.h"
#import "ConversationAction.h"
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

- (id <ConversationAction>)createAction:(id <ConversationSource>)source {
    @throw [DesignByContractException createWithReason:@"method must be overriden in base class"];
}
@end