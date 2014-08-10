//
//  ConversationTokenTests.m
//  FoodHero
//
//  Created by Jorg on 16/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "Conversation.h"
#import "ConversationAction.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "HCIsExceptionOfType.h"
#import "ConversationToken.h"


@interface ConversationTokenTests : XCTestCase

@end

@implementation ConversationTokenTests {
}

- (void)setUp {
    [super setUp];
}

-(void)test_concat_ShouldConcatTwoActionsIntoOne
{
    id persona = [Personas foodHero];
    ConversationToken *a1 = [[ConversationToken alloc] initWithSemanticId:@"FH:R1" text:@"Text1"];
    ConversationToken *a2 = [[ConversationToken alloc] initWithSemanticId:@"FH:R2" text:@"Text2"];

    ConversationToken *token = [a1 concat:a2];
    assertThat(token, is(notNilValue()));
    assertThat(token.persona, is(equalTo(persona)));
    assertThat(token.semanticId, is(equalTo(@"FH:R1&FH:R2")));
    assertThat(token.parameter, is(equalTo(@"Text1 Text2")));

}

-(void)test_concat_ShouldThrowException_WhenNotSamePersona{
    ConversationToken *a1 = [[ConversationToken alloc] initWithSemanticId:@"FH:R1" text:@"Text1"];
    ConversationToken *a2 = [[ConversationToken alloc] initWithSemanticId:@"U:R2" text:@"Text2"];

    assertThat(^(){ [a1 concat:a2];}, throwsExceptionOfType([DesignByContractException class]) );
}


@end