//
//  ConversationTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "DesignByContractException.h"
#import "UserCuisinePreference.h"
#import "UserSuggestionFeedback.h"
#import "ConversationEngine.h"
#import "FHGreeting.h"
#import "FHGreetingAction.h"
#import "FHOpeningQuestion.h"
#import "FHOpeningQuestionAction.h"

@interface ConversationEngineTests : XCTestCase

@end

@implementation ConversationEngineTests
{
    ConversationEngine *_engine;
}

- (void)setUp {
    [super setUp];

    _engine = [ConversationEngine new];
}

-(void)test_consume_ShouldThrowException_WhenSuggestionFeedbackIsAddedAsFirstFeedback
{
     @try {
        // user suggestion feedback cannot be consumed in initial state
        [_engine consume:[UserSuggestionFeedback create:@""]];
        assertThatBool(false, is(equalToBool(true)));
    }
    @catch(DesignByContractException * exception)
    {}
}

-(void)test_FHGreeting_ShouldReturnFHGreetingAction{
    ConversationAction *action = [_engine consume:[FHGreeting new]];
    assertThat(action, is(notNilValue()));
    assertThat(action.class, is(equalTo(FHGreetingAction.class)));
}

-(void)test_FHOpeningQuestion_ShouldReturnFHOpeningAction{
    [_engine consume:[FHGreeting new]];
    ConversationAction *action = [_engine consume:[FHOpeningQuestion new]];
    assertThat(action, is(notNilValue()));
    assertThat(action.class, is(equalTo(FHOpeningQuestionAction.class)));
}


@end