//
//  ConcersationService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationRepository.h"

@implementation ConversationRepository {
    Conversation *_onlyConversation;
}

- (Conversation *)getForInput:(RACSignal *)input {
    if (_onlyConversation == nil) {

        _onlyConversation = [[Conversation alloc] initWithInput:input];
    }
    return _onlyConversation;
}
@end
