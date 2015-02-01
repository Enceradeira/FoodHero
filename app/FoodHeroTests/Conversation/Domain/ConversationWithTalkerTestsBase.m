//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ConversationTestsBase.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "Personas.h"
#import "ConversationWithTalkerTestsBase.h"
#import "ExpectedStatement.h"

@implementation ConversationWithTalkerTestsBase {

    NSMutableArray *_expectedStatements;
    RestaurantSearchServiceStub *_restaurantSearchStub;
}
- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _restaurantSearchStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _locationManagerStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    [self resetConversation];
    _tokenRandomizerStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] randomizer];
    _textRepositoryStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];
    _expectedStatements = [NSMutableArray new];
}

- (void)resetConversation {
    _conversation = [[ConversationWithTalker alloc] init];
}

- (void)configureRestaurantSearchForLatitude:(double)latitude longitude:(double)longitude configuration:(void (^)(RestaurantSearchServiceStub *))configuration {
    // changing location invalidates cache in RestaurantRepository, otherwise configuration of RestaurantSearchStub has no effect
    [self.locationManagerStub injectLocations:@[[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]]];
    // configure stub
    configuration(_restaurantSearchStub);
}

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status {
    [_locationManagerStub injectAuthorizationStatus:status];
}

- (void)expectedStatementIs:(NSString *)text userAction:(Class)action {
    [self expectedStatementIs:text userAction:action inList:_expectedStatements];
}

- (void)expectedStatementIs:(NSString *)text userAction:(Class)action inList:(NSMutableArray *)list {
    ExpectedStatement *statement = [[ExpectedStatement alloc] initWithText:text inputAction:action];
    [list addObject:statement];
}

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index {
    [self assertExpectedStatementsAtIndex:index inList:_expectedStatements];
}

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index inList:(NSMutableArray *)list {
    for (NSUInteger i = 0; i < list.count; i++) {
        ExpectedStatement *expectedStatement = list[i];
        Persona *expectedPersona;
        if ([expectedStatement.semanticId rangeOfString:@"FH:"].location == NSNotFound) {
            expectedPersona = [Personas user];
        }
        else {
            expectedPersona = [Personas foodHero];
        }

        NSUInteger offsetIndex = i + index;
        assertThatUnsignedInt(_conversation.getStatementCount, is(greaterThan(@(offsetIndex))));
        Statement *statement = [_conversation getStatement:offsetIndex];
        assertThat(statement, is(notNilValue()));
        assertThat(statement.semanticId, is(equalTo(expectedStatement.semanticId)));
        assertThat(statement.persona, is(equalTo(expectedPersona)));
        assertThat(statement.inputAction.class, is(equalTo(expectedStatement.inputActionClass)));
    }
}


- (void)assertLastStatementIs:(NSString *)semanticId userAction:(Class)userAction {
    NSMutableArray *list = [NSMutableArray new];
    [self expectedStatementIs:semanticId userAction:userAction inList:list];
    NSUInteger index = self.conversation.getStatementCount - 1;
    [self assertExpectedStatementsAtIndex:index inList:list];
}

- (void)assertSecondLastStatementIs:(NSString *)semanticId userAction:(Class)userAction {
    NSUInteger index = self.conversation.getStatementCount - 2;
    NSMutableArray *list = [NSMutableArray new];
    [self expectedStatementIs:semanticId userAction:userAction inList:list];
    [self assertExpectedStatementsAtIndex:index inList:list];
}

- (void)assertThirdLastStatementIs:(NSString *)semanticId userAction:(Class)userAction {
    NSUInteger index = self.conversation.getStatementCount - 3;
    NSMutableArray *list = [NSMutableArray new];
    [self expectedStatementIs:semanticId userAction:userAction inList:list];
    [self assertExpectedStatementsAtIndex:index inList:list];
}

@end