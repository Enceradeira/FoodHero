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
#import "FHGreeting.h"
#import "FHOpeningQuestion.h"
#import "FHConversationState.h"
#import "FHAction.h"
#import "USuggestionNegativeFeedback.h"
#import "TokenConsumed.h"
#import "FHSuggestion.h"
#import "UCuisinePreference.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "SearchParameter.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "PlaceEvaluation.h"


@interface Conversation ()
@property(nonatomic) NSMutableArray *statements;
@end

@implementation Conversation {
    FHConversationState *_state;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _statements = [NSMutableArray new];

        _state = [FHConversationState new];

        FHGreeting *greetingToken = [FHGreeting create];
        FHOpeningQuestion *openingQuestionToken = [FHOpeningQuestion create];

        [_state consume:greetingToken];
        id <UAction> action = (id <UAction>) ((TokenConsumed *) [_state consume:openingQuestionToken]).action;

        ConversationToken *token = [greetingToken concat:openingQuestionToken];
        [self addStatement:token inputAction:action];
    }
    return self;
}


- (NSArray *)tokens {
    return [_statements linq_select:^(Statement *s) {
        return s.token;
    }];
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
            [(id <FHAction>) action execute:self];
        }
    }
}

- (NSUInteger)getStatementCount {
    return _statements.count;
}

- (RACSignal *)statementIndexes {
    NSUInteger __block index = 0;
    return [RACObserve(self, self.statements) map:^(id next) {
        return @(index++);
    }];
}

- (NSArray *)negativeUserFeedback {
    return [self.tokens linq_ofType:[USuggestionNegativeFeedback class]];
}

- (SearchParameter *)currentSearchPreference {
    return [SearchParameter createWithCuisine:self.cuisine priceRange:self.priceRange maxDistance:self.maxDistance];
}

- (double)maxDistance {
    USuggestionFeedbackForTooFarAway* lastFeedback = [[self.tokens linq_ofType:[USuggestionFeedbackForTooFarAway class]] linq_lastOrNil];
    if( lastFeedback == nil){
        return DBL_MAX;
    }
    else{
        // set max distance to 1/3 nearer
        return [lastFeedback.restaurant.location distanceFromLocation:lastFeedback.currentUserLocation] * EVAL_DISTANCE_DECREMENT_FACTOR;
    }
}

- (NSString *)cuisine {
    UCuisinePreference *preference = [[self.tokens linq_ofType:[UCuisinePreference class]] linq_lastOrNil];
    if (preference == nil) {
        @throw [DesignByContractException createWithReason:@"cuisine preference is unknown"];
    }
    return preference.text;
}

- (PriceLevelRange *)priceRange {
    PriceLevelRange *priceRange = [PriceLevelRange createFullRange];
    for (ConversationToken *token in [self tokens]) {
        if ([token isKindOfClass:[USuggestionFeedbackForTooExpensive class]]) {
            priceRange = [priceRange setMaxLowerThan:((USuggestionFeedbackForTooExpensive *) token).restaurant.priceLevel];
        }
        else if ([token isKindOfClass:[USuggestionFeedbackForTooCheap class]]) {
            priceRange = [priceRange setMinHigherThan:((USuggestionFeedbackForTooCheap *) token).restaurant.priceLevel];
        }
    }
    return priceRange;
}


- (NSArray *)suggestedRestaurants {
    return [[self.tokens linq_ofType:[FHSuggestionBase class]] linq_select:^(FHSuggestionBase *s) {
        return s.restaurant;
    }];
}
@end
