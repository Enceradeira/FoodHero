//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ConversationTestsBase.h"
#import "TyphoonComponents.h"
#import "StubAssembly.h"
#import "RestaurantSearchServiceStub.h"
#import "Personas.h"
#import "AlternationRandomizerStub.h"

@interface ExpectedStatement : NSObject
@property(nonatomic, readonly) NSString *semanticId;
@property(nonatomic, readonly) Class inputActionClass;

- (instancetype)initWithText:(NSString *)text inputAction:(Class)inputAction;
@end

@implementation ExpectedStatement
- (instancetype)initWithText:(NSString *)semanticId inputAction:(Class)inputAction {
    self = [super init];
    if (self != nil) {
        _semanticId = semanticId;
        _inputActionClass = inputAction;
    }
    return self;
}

@end


@implementation ConversationTestsBase {

    NSMutableArray *_expectedStatements;
}
- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _restaurantSearchStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearchService];
    _locationManagerStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationManagerProxy];
    _conversation = [(id <ApplicationAssembly>) [TyphoonComponents factory] conversation];
    _alternationRandomizerStub = [(id <ApplicationAssembly>) [TyphoonComponents factory] tokenRandomizer];
    _expectedStatements = [NSMutableArray new];
}

- (void)restaurantSearchReturnsName:(NSString *)name vicinity:(NSString *)vicinity {
    [_restaurantSearchStub injectFindResult:[Restaurant createWithName:name vicinity:vicinity types:nil placeId:nil]];
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

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index inList:(NSMutableArray *)list{
    for(NSUInteger i=0; i<list.count; i++){
        ExpectedStatement *expectedStatement = list[i];
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
            @throw [NSException exceptionWithName:@"" reason:@"you have to specify an inputActionClass for that test expectation (It's a statement from Food Hero)" userInfo:nil];
        }
        assertThat(statement.inputAction.class, is(equalTo(expectedStatement.inputActionClass)));
    }}


- (void)assertLastStatementIs:(NSString *)semanticId userAction:(Class)userAction {
    NSMutableArray *list = [NSMutableArray new];
    [self expectedStatementIs:semanticId userAction:userAction inList:list];
    NSUInteger index = self.conversation.getStatementCount - 1;
    [self assertExpectedStatementsAtIndex:index inList:list];
}

- (void)assertSecondLastStatementIs:(NSString *)semanticId userAction:(Class)userAction {
    NSUInteger index = self.conversation.getStatementCount-2;
    NSMutableArray *list = [NSMutableArray new];
    [self expectedStatementIs:semanticId userAction:userAction inList:list];
    [self assertExpectedStatementsAtIndex:index inList:list];
}

@end