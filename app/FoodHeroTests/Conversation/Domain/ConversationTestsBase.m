//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ConversationTestsBase.h"
#import "StubAssembly.h"
#import "Personas.h"
#import "ExpectedStatement.h"
#import "TyphoonComponents.h"
#import "FoodHeroTests-Swift.h"

@implementation ConversationTestsBase {

    NSMutableArray *_expectedStatements;
    RACSubject *_input;
    TalkerRandomizerFake *_talkerRandomizerFake;
    id <ApplicationAssembly> _assembly;
}
- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];
    _input = [RACSubject new];
    _assembly = [TyphoonComponents getAssembly];
    _restaurantSearchStub = (PlacesAPIStub *) [_assembly placesAPI];
    _restaurantRepository = [_assembly restaurantRepository];
    _locationManagerStub = [_assembly locationManagerProxy];
    [self resetConversationWhenIsWithFeedbackRequest:NO];
    _talkerRandomizerFake = [_assembly talkerRandomizer];
    _environmentStub = [_assembly environment];
    _expectedStatements = [NSMutableArray new];
}

- (void)initalizeConversation:(BOOL)isWithFeedbackRequest {
    [_conversation setInput:_input];
    [_conversation setAssembly:_assembly];
    [_conversation resumeWithFeedbackRequest:isWithFeedbackRequest];
}

- (void)resetConversationWhenIsWithFeedbackRequest:(BOOL)isWithFeedbackRequest {
    _conversation = [[Conversation alloc] init];
    [self initalizeConversation:isWithFeedbackRequest];
}

- (void)codeAndDecodeWhenIsWithFeedbackRequest:(BOOL)isWithFeedbackRequest {
    _conversation = [CodingHelper encodeAndDecodeUntyped:_conversation];
    [self initalizeConversation:isWithFeedbackRequest];
}

- (void)sendInput:(id)utterance {
    [_input sendNext:utterance];
}

- (void)configureRestaurantSearchForLatitude:(double)latitude longitude:(double)longitude configuration:(void (^)(PlacesAPIStub *))configuration {
    // changing location invalidates cache in RestaurantRepository, otherwise configuration of RestaurantSearchStub has no effect
    [self.locationManagerStub injectLocations:@[[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]]];
    // configure stub
    configuration(_restaurantSearchStub);
}

- (void)resetRepositoryCache {
    [self.locationManagerStub moveLocation];
}

- (void)configureRestaurantSearchForLocation:(CLLocation *)location configuration:(void (^)(PlacesAPIStub *))configuration {
    [self configureRestaurantSearchForLatitude:location.coordinate.latitude longitude:location.coordinate.longitude configuration:configuration];
}

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status {
    [_locationManagerStub injectAuthorizationStatus:status];
}

- (void)expectedStatementIs:(NSString *)text userAction:(NSString *)action {
    [self expectedStatementIs:text userAction:action inList:_expectedStatements];
}

- (void)expectedStatementIs:(NSString *)text userAction:(NSString *)action inList:(NSMutableArray *)list {
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
        assertThat(statement.semanticId, containsString(expectedStatement.semanticId));
        assertThat(statement.persona, is(equalTo(expectedPersona)));
        assertThat(statement.state, is(equalTo(expectedStatement.state)));
    }
}


- (void)assertLastStatementIs:(NSString *)semanticId state:(NSString *)state {
    NSMutableArray *list = [NSMutableArray new];
    [self expectedStatementIs:semanticId userAction:state inList:list];
    NSUInteger index = self.conversation.getStatementCount - 1;
    [self assertExpectedStatementsAtIndex:index inList:list];
}

- (void)assertSecondLastStatementIs:(NSString *)semanticId state:(NSString *)state {
    NSUInteger index = self.conversation.getStatementCount - 2;
    NSMutableArray *list = [NSMutableArray new];
    [self expectedStatementIs:semanticId userAction:state inList:list];
    [self assertExpectedStatementsAtIndex:index inList:list];
}

- (void)asynch:(void (^)())handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), handler);
}

- (Statement *)getLastStatement {
    NSUInteger index = self.conversation.getStatementCount - 1;
    Statement *last = [self.conversation getStatement:index];
    return last;
}


@end