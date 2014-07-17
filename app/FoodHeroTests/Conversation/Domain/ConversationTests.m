//
//  ConversationTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <ReactiveCocoa.h>
#import "Conversation.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "TyphoonComponentFactory.h"
#import "DefaultAssembly.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantSearchServiceStub.h"
#import "CLLocationManagerProxyStub.h"
#import "UCuisinePreference.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "AskUserToTryAgainAction.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "AskUserCuisinePreferenceAction.h"
#import "USuggestionFeedback.h"

@interface ExpectedStatement: NSObject
@property (nonatomic, readonly) NSString* semanticId;
@property (nonatomic, readonly) Class inputActionClass;
-(instancetype)initWithText:(NSString*)text inputAction:(Class) inputAction;
@end

@implementation ExpectedStatement
- (instancetype)initWithText:(NSString *)semanticId inputAction:(Class)inputAction {
    self = [super init];
    if( self != nil){
        _semanticId = semanticId;
        _inputActionClass = inputAction;
    }
    return self;
}

@end


@interface ConversationTests : XCTestCase

@end

@implementation ConversationTests
{
    Conversation *_conversation;
    RestaurantSearchServiceStub *_restaurantSearchStub;
    CLLocationManagerProxyStub  *_locationManagerStub;
    NSMutableArray* _expectedStatements;
}

- (void)setUp
{
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _restaurantSearchStub = [(id<ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _locationManagerStub =  [(id<ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _conversation =  [(id<ApplicationAssembly>) [TyphoonComponents factory] conversation ];
    _expectedStatements = [NSMutableArray new];
}

- (void)restaurantSearchReturnsName:(NSString *)name vicinity:(NSString *)vicinity{
    [_restaurantSearchStub injectFindResult:[Restaurant createWithName:name withVicinity:vicinity withTypes:nil]];
}

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status{
    [_locationManagerStub injectAuthorizationStatus:status];
}

- (void)expectedStatementIs:(NSString *)text userAction:(Class)action {
    ExpectedStatement *statement = [[ExpectedStatement alloc] initWithText:text inputAction:action];
    [_expectedStatements addObject:statement];
}

-(void)test_statementIndexes_ShouldStreamNewlyAddedStatements {
     NSMutableArray *receivedIndexes = [NSMutableArray new];
     [[_conversation statementIndexes] subscribeNext:^(id next){
         [receivedIndexes addObject:next];
     }];

     [_conversation addToken:[UCuisinePreference create:@"British Food"]]; // adds the answer & food-heros response

     assertThat(receivedIndexes, contains(
     [NSNumber numberWithUnsignedInt:0],
     [NSNumber numberWithUnsignedInt:1],
     [NSNumber numberWithUnsignedInt:2],nil));
 }

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index {
    for(NSUInteger i=0; i<_expectedStatements.count; i++){
        ExpectedStatement *expectedStatement = _expectedStatements[i];
        Persona *expectedPersona;
        if ([expectedStatement.semanticId rangeOfString:@"FH:"].location == NSNotFound)    {
            expectedPersona = [Personas user];
        }
        else{
            expectedPersona = [Personas foodHero];
        }

        NSUInteger offsetIndex = i+index;
        assertThatUnsignedInt(_conversation.getStatementCount, is(greaterThan(@(offsetIndex))));
        Statement *statement = [_conversation getStatement:offsetIndex];
        assertThat(statement, is(notNilValue()));
        assertThat(statement.semanticId, is(equalTo(expectedStatement.semanticId)));
        assertThat(statement.persona, is(equalTo(expectedPersona)));
        if( statement.persona == [Personas  foodHero] && expectedStatement.inputActionClass == nil){
            @throw [NSException exceptionWithName:@"" reason:@"inputActionClass required for statement from FoodHero" userInfo:nil];
        }
        assertThat(statement.inputAction.class, is(equalTo(expectedStatement.inputActionClass)));
    }
}

- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst
{
    Statement *statement = [_conversation getStatement:0];
    
    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"FH:Greeting&FH:OpeningQuestion")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
    assertThat(statement.inputAction.class, is(equalTo([AskUserCuisinePreferenceAction class])));
}

- (void)test_getStatement_ShouldReturnException_WhenUserHasNeverSaidAnythingAndWhenAskedForSecondStatement
{
    @try {
        [_conversation getStatement:1];
        XCTFail(@"An exception must be thrown");
    }
    @catch (DesignByContractException *exception)
    {
    }
}

-(void)test_getStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething
{
    [_conversation addToken:[UCuisinePreference create:@"British or Indian Food"]];

    [self expectedStatementIs:@"U:CuisinePreference=British or Indian Food" userAction:nil];

    [self assertExpectedStatementsAtIndex:1];
}

-(void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation
{
    assertThatInteger([_conversation getStatementCount], is(equalToInteger(1)));
    
    [_conversation addToken:[UCuisinePreference create:@"British or Indian Food"]];
    assertThatInteger([_conversation getStatementCount], is(equalToInteger(3)));
}

-(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithSuggestion{
    NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;

    [self restaurantSearchReturnsName:@"King's Head" vicinity:@"Great Yarmouth"];
    [_conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self expectedStatementIs:@"FH:Suggestion=Kings Head, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
 }

 -(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserHasDeniedAccessToLocationServiceBefore{
     NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;

     [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
     [_conversation addToken:[UCuisinePreference create:@"British Food"]];

     [self expectedStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:[AskUserIfProblemWithAccessLocationServiceResolved class]];
     [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
 }

-(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserCantGrantAccessToLocationServiceBefore{
    NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [_conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self expectedStatementIs:@"FH:BecauseUserIsNotAllowedToUseLocationServices" userAction: [AskUserIfProblemWithAccessLocationServiceResolved class]];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
}

-(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileBeingAskedNow{
     NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount]+1;

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [_conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];

    [self expectedStatementIs:@"FH:BecauseUserDeniedAccessToLocationServices" userAction:[AskUserIfProblemWithAccessLocationServiceResolved class]];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
 }

-(void)test_UCuisinePreference_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults
{
    NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;
    [_restaurantSearchStub injectFindResultNothing];

    [_conversation addToken:[UCuisinePreference create:@"British Food"]];

    [self expectedStatementIs:@"FH:NoRestaurantsFound" userAction:[AskUserToTryAgainAction class]];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
}

-(void)test_USuggestionFeedback_ShouldCauseFoodHeroToSearchAgain{
    [_conversation addToken:[UCuisinePreference create:@"British Food"]];

    NSUInteger index = [_conversation getStatementCount] +1;
    [_conversation addToken:[USuggestionFeedback create:@"too expensive"]];

    [self expectedStatementIs:@"FH:Suggestion=Lion Heart, Great Yarmouth" userAction:[AskUserSuggestionFeedbackAction class]];
    [self assertExpectedStatementsAtIndex:index];
}



@end