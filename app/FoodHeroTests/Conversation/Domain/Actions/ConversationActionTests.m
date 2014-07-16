//
//  ConversationTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Conversation.h"
#import "ConversationAction.h"
#import "Personas.h"
#import "DesignByContractException.h"


@interface ConversationActionTests : XCTestCase

@end

@implementation ConversationActionTests {
}

- (void)setUp {
    [super setUp];
}

-(void)test_concat_ShouldConcatTwoActionsIntoOne
{
    id persona = [Personas foodHero];
    ConversationAction *a1 = [[ConversationAction alloc] init:persona responseId:@"R1" text:@"Text1"];
    ConversationAction *a2 = [[ConversationAction alloc] init:persona responseId:@"R2" text:@"Text2"];

    ConversationAction *concatedAction = [a1 concat:a2];
    assertThat(concatedAction, is(notNilValue()));
    assertThat(concatedAction.persona, is(equalTo(persona)));
    assertThat(concatedAction.responseId, is(equalTo(@"R1&R2")));
    assertThat(concatedAction.text, is(equalTo(@"Text1 Text2")));

}

-(void)test_concat_ShouldThrowException_WhenNotSamePersona{
    ConversationAction *a1 = [[ConversationAction alloc] init:[Personas foodHero] responseId:@"R1" text:@"Text1"];
    ConversationAction *a2 = [[ConversationAction alloc] init:[Personas user] responseId:@"R2" text:@"Text2"];
     @try {
        [a1 concat:a2];
        assertThatBool(false,is(equalToBool(true))); // Exception should be thrown
    }
    @catch(DesignByContractException * exception)
    {}
}


@end