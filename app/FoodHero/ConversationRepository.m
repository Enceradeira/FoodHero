//
//  ConcersationService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationRepository.h"
#import "TyphoonComponents.h"

@implementation ConversationRepository {
    Conversation *_onlyConversation;
}

- (Conversation *)get {
    if (_onlyConversation == nil) {

        _onlyConversation = [(id <ApplicationAssembly>) [TyphoonComponents factory] conversation];
    }
    return _onlyConversation;
}
@end
