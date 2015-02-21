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
    NSString *_state;
    ConversationToken *_token;
}
- (NSString *)text {
    return _token.text;
}

- (NSString *)semanticId {
    return _token.semanticId;
}

- (Persona *)persona {
    return _token.persona;
}

- (id)initWithToken:(ConversationToken *)token state:(NSString *)state {
    self = [super init];
    if (self != nil) {
        _token = token;
        _state = state;
    }
    return self;
}

+ (Statement *)create:(ConversationToken *)token state:(NSString *)inputAction {
    return [[Statement alloc] initWithToken:token state:inputAction];
}

- (NSString *)state {
    return _state;
}

- (Restaurant *)suggestedRestaurant {
    if ([_token isKindOfClass:[FHSuggestionBase class]]) {
        return ((FHSuggestion *) _token).restaurant;
    }
    else if ([_token isKindOfClass:[USuggestionFeedback class]]) {
        return ((USuggestionFeedback *) _token).restaurant;
    }
    return nil;
}

@end
