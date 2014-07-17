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
#import "UCuisinePreference.h"
#import "USuggestionFeedback.h"
#import "FHGreeting.h"
#import "FHOpeningQuestion.h"
#import "FHConversationState.h"
#import "HCIsExceptionOfType.h"
#import "SearchAction.h"
#import "NoAction.h"
#import "AskUserCuisinePreferenceAction.h"
#import "FHSuggestion.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServices.h"
#import "FHBecauseUserDeniedAccessToLocationServices.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"

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
    assertThat(^(){[_state consume:[USuggestionFeedback create:@""]];;}, throwsExceptionOfType([DesignByContractException class]) );
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

-(void)test_consume_ShouldThrowException_WhenFHBecauseUserDeniedAccessToLocationServicesIsAddedTwice
{
    [_state consume:[FHGreeting new]];
    [_state consume:[FHOpeningQuestion new]];
    [_state consume:[UCuisinePreference new]];
    [_state consume:[FHBecauseUserDeniedAccessToLocationServices new]];

    assertThat(^(){ [_state consume:[FHBecauseUserDeniedAccessToLocationServices new]];}, throwsExceptionOfType([DesignByContractException class]) );
}


@end