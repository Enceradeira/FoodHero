//
//  Conversation.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <NSArray+LinqExtensions.h>
#import "Conversation.h"
#import "DesignByContractException.h"
#import "RestaurantSearch.h"
#import "FHGreeting.h"
#import "FHOpeningQuestion.h"
#import "FHConversationState.h"
#import "FHAction.h"
#import "USuggestionFeedback.h"
#import "TokenConsumed.h"


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

        _state = [FHConversationState createWithActionFeedback:self];

        FHGreeting *greetingToken = [FHGreeting create];
        FHOpeningQuestion *openingQuestionToken = [FHOpeningQuestion create];

        [_state consume:greetingToken];
        id <UAction> action = (id <UAction>) ((TokenConsumed *) [_state consume:openingQuestionToken]).action;

        ConversationToken *token = [greetingToken concat:openingQuestionToken];
        [self addStatement:token inputAction:action];
    }
    return self;
}

- (void)addStatement:(ConversationToken *)token inputAction:(id <UAction>)inputAction {
    NSMutableArray *statementProxy = [self mutableArrayValueForKey:@"statements"]; // In order that KVC-Events are fired
    Statement *statement = [Statement create:token inputAction:inputAction];
    [statementProxy addObject:statement];
}

- (Statement *)getStatement:(NSUInteger)index {
    if (index > [_statements count] - 1) {
        @throw [[DesignByContractException alloc] initWithReason:[NSString stringWithFormat:@"no conversation exists at index %ld", (long) index]];
    }

    return _statements[index];
}

- (void)addToken:(ConversationToken *)token {
    id <ConsumeResult> result = [_state consume:token];
    if (!result.isTokenConsumed) {
        @throw [DesignByContractException createWithReason:@"token was not consumed. This indicates an invalid state"];
    }
    else {
        id <ConversationAction> action = ((TokenConsumed *) result).action;
        id <UAction> userAction;
        if ([action conformsToProtocol:@protocol(UAction)]) {
            // User has to perform next action
            userAction = (id <UAction>) action;
            [self addStatement:token inputAction:userAction];
        }
        else {
            // FH has to perform next action
            [self addStatement:token inputAction:nil];
            [(id <FHAction>) action execute];
        }
    }
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

- (NSArray *)suggestionFeedback {
    return [[_statements linq_where:^(Statement *s){
        return (BOOL) ([s.token isKindOfClass: [USuggestionFeedback class]]);
    }] linq_select:^(Statement *s){
        return s.token;
    }];
}

@end
