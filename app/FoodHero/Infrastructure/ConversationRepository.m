//
//  ConcersationService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationRepository.h"
#import "ApplicationAssembly.h"

@implementation ConversationRepository {
    Conversation *_onlyConversation;
    id <ApplicationAssembly> _assembly;
}

- (instancetype)initWithAssembly:(id <ApplicationAssembly>)assembly {
    self = [super init];
    if (self != nil) {
        _assembly = assembly;
    }
    return self;
}

- (Conversation *)getForInput:(RACSignal *)input {
    if (_onlyConversation == nil) {

        _onlyConversation = [[Conversation alloc] initWithInput:input assembly:_assembly];
    }
    return _onlyConversation;
}
@end
