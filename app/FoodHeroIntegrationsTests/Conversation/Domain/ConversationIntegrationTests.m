//
//  ConversationIntegrationTests.m
//  FoodHero
//
//  Created by Jorg on 18/09/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TyphoonComponents.h"
#import "TextRepository.h"
#import "RandomizerStub.h"
#import "IntegrationAssembly.h"

@interface ConversationIntegrationTests : XCTestCase

@end

@implementation ConversationIntegrationTests {
    RandomizerStub *_randomizer;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[IntegrationAssembly new]];

    _randomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] randomizer];
}

/*
- (Conversation *)createConversation {
    return [[Conversation alloc] initWithInput:_input];
} */

@end
