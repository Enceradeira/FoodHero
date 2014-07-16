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
#import "FHOpeningQuestion.h"
#import "FHConversationState.h"
#import "HCIsExceptionOfType.h"
#import "SearchAction.h"
#import "NoAction.h"
#import "AskUserCuisinePreferenceAction.h"

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

-(void)test_consume_ShouldThrowException_WhenSomethingOtherThenFHGreetingIsAdded
{
    assertThat(^(){[_state consume:[UserSuggestionFeedback create:@""]];;}, throwsExceptionOfType([DesignByContractException class]) );
}

-(void)test_consume_ShouldThrowException_WhenSomethingOtherThenUserCuisinePreferenceIsAddedAfterFHOpeningQuestion
{
    [_state consume:[FHGreeting new]];
    [_state consume:[FHOpeningQuestion new]];
    assertThat(^(){[_state consume:[FHGreeting new]];}, throwsExceptionOfType([DesignByContractException class]) );
}

-(void)test_consume_ShouldThrowException_WhenGreetingIsAddedTwice
{
    [_state consume:[FHGreeting new]];

    assertThat(^(){[_state consume:[FHGreeting new]];}, throwsExceptionOfType([DesignByContractException class]) );
}

-(void)test_FHGreeting_ShouldReturnFHGreetingAction{
    ConversationAction *action = [_state consume:[FHGreeting new]];
    assertThat(action.class, is(equalTo(NoAction.class)));
}

-(void)test_FHOpeningQuestion_ShouldReturnFHOpeningAction{
    [_state consume:[FHGreeting new]];
    ConversationAction *action = [_state consume:[FHOpeningQuestion new]];
    assertThat(action.class, is(equalTo(AskUserCuisinePreferenceAction .class)));
}

-(void)test_UserCuisinePreference_ShouldReturnFHSearchAction{
    [_state consume:[FHGreeting new]];
    [_state consume:[FHOpeningQuestion new]];
    ConversationAction *action = [_state consume:[UserCuisinePreference new]];
    assertThat(action.class, is(equalTo(SearchAction.class)));
}


@end