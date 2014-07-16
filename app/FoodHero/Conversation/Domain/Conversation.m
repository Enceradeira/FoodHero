//
//  Conversation.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "Conversation.h"
#import "DesignByContractException.h"
#import "RestaurantSearch.h"
#import "FHGreeting.h"
#import "FHOpeningQuestion.h"
#import "AtomicState.h"
#import "FHConversationState.h"


@interface Conversation ()
@property(nonatomic) NSMutableArray *statements;
@end

@implementation Conversation {
    RestaurantSearch *_restaurantSearch;
    FHConversationState *_state;
}

- (id)initWithDependencies:(RestaurantSearch *)restaurantSearch {
    self = [super init];
    if (self != nil) {
        _restaurantSearch = restaurantSearch;
        _statements = [NSMutableArray new];

        _state = [FHConversationState createWithActionFeedback:self restaurantSearch:_restaurantSearch];

        FHGreeting *greetingToken = [FHGreeting create];
        FHOpeningQuestion *openingQuestionToken = [FHOpeningQuestion create];

        [_state consume:greetingToken];
        [_state consume:openingQuestionToken];

        ConversationToken *token = [greetingToken concat:openingQuestionToken];
        [self addStatementWithPersona:token.persona text:token.parameter semanticId:token.semanticId];
    }
    return self;
}

- (void)addStatementWithPersona:(Persona *)persona text:(NSString *)text semanticId:(NSString *)semanticId {
    NSMutableArray *statementProxy = [self mutableArrayValueForKey:@"statements"]; // In order that KVC-Events are fired
    [statementProxy addObject:[[Statement alloc] initWithText:text semanticId:semanticId persona:persona]];
}

- (Statement *)getStatement:(NSUInteger)index {
    if (index > [_statements count] - 1) {
        @throw [[DesignByContractException alloc] initWithReason:[NSString stringWithFormat:@"no conversation exists at index %ld", (long) index]];
    }

    return _statements[index];
}

- (void)addToken:(ConversationToken *)token {
    id<ConversationAction> action = [_state consume:token];
    [self addStatementWithPersona:token.persona text:token.parameter semanticId:token.semanticId];
    [action execute];
}

- (NSUInteger)getStatementCount {
    return _statements.count;
}

- (RACSignal *)statementIndexes {
    NSUInteger __block index = 0;
    return [RACObserve(self, self.statements) map:^(id next){
        return [NSNumber numberWithUnsignedInt:index++];
    }];
}

@end
