//
//  FHConversationState.m
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
#import "FHGreeting.h"
#import "FHGreetingAction.h"
#import "FHOpeningQuestion.h"
#import "FHOpeningQuestionAction.h"
#import "FHConversationState.h"

@interface FHConversationStateTests : XCTestCase

@end

@implementation FHConversationStateTests
{
    FHConversationState *_state;
}

- (void)setUp {
    [super setUp];

    _state = [FHConversationState new];
}

-(void)test_consume_ShouldThrowException_WhenSuggestionFeedbackIsAddedAsFirstFeedback
{
     @try {
        // user suggestion feedback cannot be consumed in initial state
        [_state consume:[UserSuggestionFeedback create:@""]];
        assertThatBool(false, is(equalToBool(true)));
    }
    @catch(DesignByContractException * exception)
    {}
}

-(void)test_FHGreeting_ShouldReturnFHGreetingAction{
    ConversationAction *action = [_state consume:[FHGreeting new]];
    assertThat(action, is(notNilValue()));
    assertThat(action.class, is(equalTo(FHGreetingAction.class)));
}

-(void)test_FHOpeningQuestion_ShouldReturnFHOpeningAction{
    [_state consume:[FHGreeting new]];
    ConversationAction *action = [_state consume:[FHOpeningQuestion new]];
    assertThat(action, is(notNilValue()));
    assertThat(action.class, is(equalTo(FHOpeningQuestionAction.class)));
}


@end