//
//  ConcersationService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationRepository.h"

Conversation *_onlyConversation;

@implementation ConversationRepository
-(Conversation*)get
{
    if( _onlyConversation == nil )
    {
        _onlyConversation = [Conversation new];
    }
    return _onlyConversation;
}
@end
