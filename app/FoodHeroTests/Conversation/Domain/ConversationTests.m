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


@interface ConversationTests : XCTestCase

@end

@implementation ConversationTests
{
    Conversation *_conversation;
    RestaurantSearchServiceStub *_restaurantSearchStub;
    CLLocationManagerProxyStub  *_locationManagerStub;
    NSMutableDictionary* _expectedStatements;
}

- (void)setUp
{
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _restaurantSearchStub = [(id<ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _locationManagerStub =  [(id<ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _conversation =  [(id<ApplicationAssembly>) [TyphoonComponents factory] conversation ];
    _expectedStatements = [NSMutableDictionary new];
}

- (void)restaurantSearchReturnsName:(NSString *)name vicinity:(NSString *)vicinity{
    [_restaurantSearchStub injectFindResult:[Restaurant createWithName:name withVicinity:vicinity withTypes:nil]];
}

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status{
    [_locationManagerStub injectAuthorizationStatus:status];
}

- (void)expectStatementFor:(Persona *)persona statmentent:(NSString *)statement{
    [_expectedStatements setObject:persona forKey:statement];
}

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index {
    for(NSUInteger i=0; i<_expectedStatements.count; i++){
        NSString *expectedSemanticId = _expectedStatements.allKeys[i];
        Persona *expectedPersona = _expectedStatements[expectedSemanticId];

        NSUInteger offsetIndex = i+index;
        assertThatUnsignedInt(_conversation.getStatementCount, is(greaterThan(@(offsetIndex))));
        Statement *statement = [_conversation getStatement:offsetIndex];
        assertThat(statement, is(notNilValue()));
        assertThat(statement.semanticId, is(equalTo(expectedSemanticId)));
        assertThat(statement.persona, is(equalTo(expectedPersona)));
    }
}

- (void)test_getStatement_ShouldHaveFoodHerosGreeting_WhenAskedForFirst
{
    Statement *statement = [_conversation getStatement:0];
    
    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"Greeting&OpeningQuestion")));
    assertThat(statement.persona, is(equalTo(Personas.foodHero)));
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

-(void)test_statementIndexes_ShouldStreamNewlyAddedStatements {
     NSMutableArray *receivedIndexes = [NSMutableArray new];
     [[_conversation statementIndexes] subscribeNext:^(id next){
         [receivedIndexes addObject:next];
     }];

     [_conversation addStatement:@"British Food"]; // adds the answer & food-heros response

     assertThat(receivedIndexes, contains(
     [NSNumber numberWithUnsignedInt:0],
     [NSNumber numberWithUnsignedInt:1],
     [NSNumber numberWithUnsignedInt:2],nil));
 }

-(void)test_getStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething
{
    [_conversation addStatement:@"British or Indian Food"];

    [self expectStatementFor:Personas.user statmentent:@"UserAnswer:British or Indian Food"];

    [self assertExpectedStatementsAtIndex:1];
}

-(void)test_getStatementCount_ShouldReturnNrOfStatementsInConversation
{
    assertThatInteger([_conversation getStatementCount], is(equalToInteger(1)));
    
    [_conversation addStatement:@"British or Indian Food"];
    assertThatInteger([_conversation getStatementCount], is(equalToInteger(3)));
}

-(void)test_addStatement_ShouldCauseFoodHeroToRespondWithSuggestion{
    NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;

    [self restaurantSearchReturnsName:@"King's Head" vicinity:@"Great Yarmouth"];
    [_conversation addStatement:@"British Food"];

    [self expectStatementFor:Personas.foodHero statmentent:@"Suggestion:British Food"];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
 }

 -(void)test_addStatement_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserHasDeniedAccessToLocationServiceBefore{
     NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;

     [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
     [_conversation addStatement:@"British Food"];

     [self expectStatementFor:[Personas foodHero] statmentent:@"CantAccessLocationService:BecauseUserDeniedAccessToLocationServices"];
     [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
 }

-(void)test_addStatement_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserCantGrantAccessToLocationServiceBefore{
    NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusRestricted];
    [_conversation addStatement:@"British Food"];

    [self expectStatementFor:[Personas foodHero] statmentent:@"CantAccessLocationService:BecauseUserIsNotAllowedToUseLocationServices"];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
}

-(void)test_addStatement_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileBeingAskedNow{
     NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount]+1;

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [_conversation addStatement:@"British Food"];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];

    [self expectStatementFor:[Personas foodHero] statmentent:@"CantAccessLocationService:BecauseUserDeniedAccessToLocationServices"];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
 }

-(void)test_addStatement_ShouldCauseFoodHeroToRespondWithNoRestaurantsFound_WhenRestaurantServicesYieldsNoResults
{
    NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;
    [_restaurantSearchStub injectFindResultNothing];

    [_conversation addStatement:@"British Food"];

    [self expectStatementFor:[Personas foodHero] statmentent:@"NoRestaurantsFound"];
    [self assertExpectedStatementsAtIndex:indexOfFoodHeroResponse];
}


@end