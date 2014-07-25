//
//  Statement.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Conversation.h"
#import "FHSuggestion.h"
#import "USuggestionNegativeFeedback.h"

@implementation Statement {
    id <UAction> _inputAction;
    ConversationToken *_token;
}
- (NSString *)text {
    return _token.parameter;
}

- (NSString *)semanticId {
    return _token.semanticId;
}

- (Persona *)persona {
    return _token.persona;
}

- (id)initWithToken:(ConversationToken *)token inputAction:(id <UAction>)inputAction {
    self = [super init];
    if (self != nil) {
        _token = token;
        _inputAction = inputAction;
    }
    return self;
}

+ (Statement *)create:(ConversationToken *)token inputAction:(id <UAction>)inputAction {
    return [[Statement alloc] initWithToken:token inputAction:inputAction];
}

- (id <UAction>)inputAction {
    return _inputAction;
}

- (Restaurant *)suggestedRestaurant {
    if ([_token isKindOfClass:[FHSuggestion class]]) {
        return ((FHSuggestion *) _token).restaurant;
    }
    else if ([_token isKindOfClass:[USuggestionFeedback class]]) {
        return ((USuggestionFeedback *) _token).restaurant;
    }
    return nil;
}

@end
