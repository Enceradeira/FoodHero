//
//  ConversationRepositoryTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#pragma clang diagnostic push
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import <Typhoon.h>
#import "DefaultAssembly.h"
#import "TyphoonComponents.h"
#import "ConversationRepository.h"

@interface ConversationRepositoryTests : XCTestCase

@end

@implementation ConversationRepositoryTests
{
    ConversationRepository *_repository;
}
#pragma clang diagnostic push
#pragma ide diagnostic ignored "objc_incompatible_pointers"
- (void)setUp
{
    [super setUp];

    [TyphoonComponents configure:[DefaultAssembly new]];
    _repository =  [(DefaultAssembly *)[TyphoonComponents factory] conversationRepository ];
}
#pragma clang diagnostic pop

- (void)test_get_shouldAlwaysReturnSameConversation
{
    Conversation *conversation = [_repository get];
    assertThat(conversation, is(notNilValue()));
    
    Conversation *conversation2 = [_repository get];
    assertThat(conversation, is(sameInstance(conversation2)));
}

@end