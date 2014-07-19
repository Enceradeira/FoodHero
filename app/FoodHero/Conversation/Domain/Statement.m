//
//  Statement.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Conversation.h"
#import "Statement.h"
#import "ConversationToken.h"

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
@end
