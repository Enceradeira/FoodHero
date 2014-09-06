//
//  FHConversationState.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "InvalidConversationStateException.h"
#import "UCuisinePreference.h"
#import "USuggestionNegativeFeedback.h"
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
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "RestaurantBuilder.h"

@interface FHConversationStateTests : XCTestCase <ConversationSource>

@end

@implementation FHConversationStateTests
{
    FHConversationState *_state;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _state = [FHConversationState new];
}

-(void)addToken:(ConversationToken *)token{

}

-(void)test_consume_ShouldReturnTokenNotConsumed_WhenSomethingOtherThenFHGreetingIsAdded
{
    id <ConsumeResult> result = [_state consume:[USuggestionFeedbackForTooCheap create:[[RestaurantBuilder alloc] build]]];
    assertThatBool(result.isTokenNotConsumed, is(equalToBool(YES)));
}

-(void)test_consume_ShouldThrowException_WhenSomethingOtherThenUserCuisinePreferenceIsAddedAfterFHOpeningQuestion
{
    [_state consume:[FHGreeting new]];
    [_state consume:[FHOpeningQuestion new]];
    assertThat(^(){[_state consume:[FHGreeting new]];}, throwsExceptionOfType([InvalidConversationStateException class]) );
}

-(void)test_consume_ShouldThrowException_WhenGreetingIsAddedTwice
{
    [_state consume:[FHGreeting new]];

    assertThat(^(){[_state consume:[FHGreeting new]];}, throwsExceptionOfType([InvalidConversationStateException class]) );
}

-(void)test_consume_ShouldThrowException_WhenFHBecauseUserDeniedAccessToLocationServicesIsAddedTwice
{
    [_state consume:[FHGreeting new]];
    [_state consume:[FHOpeningQuestion new]];
    [_state consume:[UCuisinePreference new]];

    assertThat(^(){ [_state consume:[UCuisinePreference new]];}, throwsExceptionOfType([InvalidConversationStateException class]) );
}
@end