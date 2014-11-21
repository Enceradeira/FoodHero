//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedback.h"
#import "DesignByContractException.h"


@implementation USuggestionFeedback {
}
- (instancetype)initWithRestaurant:(Restaurant *)restaurant text:(NSString *)text type:(NSString *)type{
    NSString *semanticId = [NSString stringWithFormat:@"U:SuggestionFeedback=%@", type];
    self = [super initWithSemanticId:semanticId text:text];
    if (self != nil) {
        _restaurant = restaurant;
    }
    return self;
}

- (id <ConversationAction>)createAction {
    @throw [DesignByContractException createWithReason:@"method must be overriden in base class"];
}
@end