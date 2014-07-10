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
#import "DefaultAssembly.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantSearchServiceStub.h"
#import "Restaurant.h"

 @interface ConversationTests : XCTestCase

@end

@implementation ConversationTests
{
    Conversation *_conversation;
    RestaurantSearchServiceStub *_restaurantSearchStub;
}

- (void)setUp
{
    [super setUp];
    
    [TyphoonComponents configure:[StubAssembly new]];
    _restaurantSearchStub = [(id<ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _conversation =  [(id<ApplicationAssembly>) [TyphoonComponents factory] conversation ];
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

-(void)test_addStatement_ShouldCauseFoodHeroToRespond{
    [_restaurantSearchStub injectSearchResult:[Restaurant createWithName:@"King's Head" withVicinity:@"Great Yarmouth" withTypes:nil]];

    NSUInteger lastIndex = [_conversation getStatementCount]-1;
    [_conversation addStatement:@"British Food"];

    // Statement *userStatement = [_conversation getStatement:lastIndex+1];
    Statement *foodHeroResponse = [_conversation getStatement:lastIndex+2];

    assertThat(foodHeroResponse, is(notNilValue()));
    assertThat(foodHeroResponse.persona, is(equalTo(Personas.foodHero)));
    assertThat(foodHeroResponse.semanticId, is(equalTo(@"Suggestion:King's Head, Great Yarmouth")));
}

@end