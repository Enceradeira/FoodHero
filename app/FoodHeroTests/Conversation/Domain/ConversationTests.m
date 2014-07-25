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
#import "Personas.h"
#import "DesignByContractException.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponents.h"
#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "AskUserToTryAgainAction.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "AskUserCuisinePreferenceAction.h"
#import "USuggestionNegativeFeedback.h"
#import "ConversationTestsBase.h"
#import "RestaurantSearchServiceStub.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "AlternationRandomizerStub.h"


@interface ConversationTests : ConversationTestsBase
@end

@implementation ConversationTests
{
}

-(void)test_statementIndexes_ShouldStreamNewlyAddedStatements {
     NSMutableArray *receivedIndexes = [NSMutableArray new];
     [[self.conversation statementIndexes] subscribeNext:^(id next){
         [receivedIndexes addObject:next];
     }];

     [self.conversation addToken:[UCuisinePreference create:@"British Food"]]; // adds the answer & food-heros response

     assertThat(receivedIndexes, contains(
     [NSNumber numberWithUnsignedInt:0],
     [NSNumber numberWithUnsignedInt:1],
     [NSNumber numberWithUnsignedInt:2],nil));
 }


- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst
{
    Statement *statement = [self.conversation getStatement:0];
    
    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"FH:Greeting&FH:OpeningQuestion")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
    assertThat(statement.inputAction.class, is(equalTo([AskUserCuisinePreferenceAction class])));
}

- (void)test_getStatement_ShouldReturnException_WhenUserHasNeverSaidAnythingAndWhenAskedForSecondStatement
{
    @try {
        [self.conversation getStatement:1];
        XCTFail(@"An exception must be thrown");
    }
    @catch (DesignByContractException *exception)
    {
    }
}

-(void)test_getStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething
{
    [self.conversation addToken:[UCuisinePreference create:@"British or Indian Food"]];

    [self assertSecondLastStatementIs:@"U:CuisinePreference=British or Indian Food" userAction:nil];
}

-(void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation
{
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(1)));
    
    [self.conversation addToken:[UCuisinePreference create:@"British or Indian Food"]];
    assertThatInteger([self.conversation getStatementCount], is(equalToInteger(3)));
}

-(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithSuggestion{
    [self restaurantSearchReturnsName:@"King's Head" vicinity:@"Great Yarmouth"];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:Suggestion=Kings Head, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
 }

-(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults
{
    [self.restaurantSearchStub injectFindNothing];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self assertLastStatementIs:@"FH:NoRestaurantsFound" userAction:[AskUserToTryAgainAction class]];
}

-(void)test_USuggestionFeedback_ShouldCauseFoodHeroToSearchAgain{
    [self.tokenRandomizerStub injectDontDo:@"FH:Comment"];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self restaurantSearchReturnsName:@"Lion Heart" vicinity:@"Great Yarmouth"];
    [self.conversation addToken:[USuggestionFeedbackForTooExpensive create:[Restaurant new]]];

    [self assertLastStatementIs:@"FH:Suggestion=Lion Heart, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
}

-(void)test_suggestionFeedback_ShouldReturnAllSuggestionFeedback{
    USuggestionNegativeFeedback *feedback1 = [USuggestionFeedbackForTooExpensive create:[Restaurant new]];
    USuggestionNegativeFeedback *feedback2 = [USuggestionFeedbackForTooFarAway create:[Restaurant new]];

    [self.conversation addToken:[UCuisinePreference create:@"British Food"]];
    [self.conversation addToken:feedback1];
    [self.conversation addToken:feedback2];

    NSArray *feedback = [self.conversation suggestionFeedback];
    assertThatUnsignedInt(feedback.count, is(equalToUnsignedInt(2)));
    assertThat(feedback, hasItem(feedback1));
    assertThat(feedback, hasItem(feedback2));
}
@end