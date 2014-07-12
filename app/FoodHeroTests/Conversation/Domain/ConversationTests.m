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
}

- (void)setUp
{
    [super setUp];
    
    [TyphoonComponents configure:[StubAssembly new]];
    _restaurantSearchStub = [(id<ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _locationManagerStub =  [(id<ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _conversation =  [(id<ApplicationAssembly>) [TyphoonComponents factory] conversation ];
}

- (void)restaurantSearchReturnsName:(NSString *)name vicinity:(NSString *)vicinity{
    [_restaurantSearchStub injectFindResult:[Restaurant createWithName:name withVicinity:vicinity withTypes:nil]];
}

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status{
    [_locationManagerStub injectAuthorizationStatus:status];
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

-(void)test_getStatement_ShouldReturnUserAnswer_WhenUserHasSaidSomething
{
    [_conversation addStatement:@"British or Indian Food"];
    
    Statement *statement  = [_conversation getStatement:1];
    
    assertThat(statement, is(notNilValue()));
    assertThat(statement.semanticId, is(equalTo(@"UserAnswer:British or Indian Food")));
    assertThat(statement.persona, is(equalTo(Personas.user)));
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

    Statement *foodHeroResponse = [_conversation getStatement:indexOfFoodHeroResponse];
    assertThat(foodHeroResponse, is(notNilValue()));
    assertThat(foodHeroResponse.persona, is(equalTo(Personas.foodHero)));
    assertThat(foodHeroResponse.semanticId, is(equalTo(@"Suggestion:British Food")));
 }

 -(void)test_addStatement_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserHasDeniedAccessToLocationServiceBefore{
     NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount] +1;

     [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];
     [_conversation addStatement:@"British Food"];

     Statement *foodHeroResponse = [_conversation getStatement:indexOfFoodHeroResponse];
     assertThat(foodHeroResponse, is(notNilValue()));
     assertThat(foodHeroResponse.persona, is(equalTo(Personas.foodHero)));
     assertThat(foodHeroResponse.semanticId, is(equalTo(@"CantAccessLocationService")));
 }

 -(void)test_addStatement_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileBeingAskedNow{
     NSUInteger indexOfFoodHeroResponse = [_conversation getStatementCount]+1;

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [_conversation addStatement:@"British Food"];

    [self userSetsLocationAuthorizationStatus:kCLAuthorizationStatusDenied];

     Statement *foodHeroResponse = [_conversation getStatement:indexOfFoodHeroResponse];

     assertThat(foodHeroResponse, is(notNilValue()));
     assertThat(foodHeroResponse.persona, is(equalTo(Personas.foodHero)));
     assertThat(foodHeroResponse.semanticId, is(equalTo(@"CantAccessLocationService")));
 }

-(void)test_addStatement_ShouldCauseFoodHeroToRespondWithCantAccessLocation_WhenUserDeniesAccessWhileLocationServiceIsQueried{
    assertThatBool(YES, is(equalToBool(NO)));
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

@end