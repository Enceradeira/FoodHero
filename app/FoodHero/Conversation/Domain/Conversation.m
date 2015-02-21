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
#import "FHOpeningQuestion.h"
#import "FHAction.h"
#import "USuggestionNegativeFeedback.h"
#import "FHSuggestion.h"
#import "UCuisinePreference.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "SearchProfil.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "FHWarningIfNotInPreferredRange.h"
#import "FoodHero-Swift.h"


@interface Conversation ()
@property(nonatomic) NSMutableArray *statements;
@end

@implementation Conversation {

    RACSignal *_input;
}


- (instancetype)init {
    return [self initWithInput:[RACSubject new]];
}

- (instancetype)initWithInput:(RACSignal*) input {
    self = [super init];
    if (self != nil) {
        _statements = [NSMutableArray new];
        _input = input;

        id <IRandomizer> randomizer = [TalkerRandomizer new];
        ConversationResources *resources = [[ConversationResources alloc] initWithRandomizer:randomizer];
        TalkerContext *context = [[TalkerContext alloc] initWithRandomizer:randomizer resources:resources];
        ConversationScript *script = [[ConversationScript alloc] initWithContext:context];

        TalkerEngine *engine = [[TalkerEngine alloc] initWithScript:script input:_input];

        RACSignal *output = [engine execute];
        [output subscribeNext:^(TalkerUtterance *utterance) {
            NSArray *semanticIds = [[utterance customData] linq_select:^(ConversationContext* context){
                return [context semanticId];
            }];
            NSArray *states = [[[utterance customData] linq_select:^(ConversationContext *context) {
                return [context state];
            }] linq_where:^(NSString*state){
                return (BOOL)(state != [NSNull null]);
            }];

            NSString *semanticIdString = [semanticIds componentsJoinedByString:@";"];
            NSString *statesString = [states componentsJoinedByString:@";"];
            NSString *text = utterance.utterance;

            ConversationToken *token = [[ConversationToken alloc] initWithSemanticId:semanticIdString text:text];

            [self addStatement:token state:statesString];
            /*
            id <IUAction> uiAction = nil;
            if ([semanticIdString rangeOfString:@"FH:OpeningQuestion"].location != NSNotFound) {
                uiAction = [AskUserCuisinePreferenceAction new];
            } */


        }];


        // [self addFHToken:[FHGreeting create]];
    }
    return self;
}


- (NSArray *)tokensOfCurrentSearch {
    Statement *lastOpeningQuestion = [[_statements
            linq_where:^(Statement *s) {
                return (BOOL) [s.token isKindOfClass:[FHOpeningQuestion class]];
            }]
            linq_lastOrNil];

    NSUInteger currentSearchBeginCount = lastOpeningQuestion == nil ? 0 : [_statements indexOfObject:lastOpeningQuestion] + 1;

    return [[_statements
            linq_skip:currentSearchBeginCount]
            linq_select:^(Statement *s) {
                return s.token;
            }];
}

- (void)addStatement:(ConversationToken *)token state:(NSString*)state {
    NSMutableArray *statementProxy = [self mutableArrayValueForKey:@"statements"]; // In order that KVC-Events are fired
    Statement *statement = [Statement create:token state:state];
    [statementProxy addObject:statement];
}

- (Statement *)getStatement:(NSUInteger)index {
    if (index > [_statements count] - 1) {
        @throw [[DesignByContractException alloc] initWithReason:[NSString stringWithFormat:@"no conversation exists at index %ld", (long) index]];
    }

    return _statements[index];
}

- (void)addFHToken:(ConversationToken *)token {
    assert(false); // Remove
}

- (NSUInteger)getStatementCount {
    return _statements.count;
}

- (RACSignal *)statementIndexes {
    NSUInteger __block index = 0;

    RACSubject *nextIndexSignal = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    RACSignal *statementsChangedSignal = RACObserve(self, self.statements);
    [statementsChangedSignal subscribeNext:^(NSArray *statements) {
        for (NSUInteger i = 0; i < statements.count; i++) {
            if (i >= index) {
                [nextIndexSignal sendNext:@(index++)];
            }
        }
    }];

    return nextIndexSignal;
}

- (NSArray *)negativeUserFeedback {
    return [self.tokensOfCurrentSearch linq_ofType:[USuggestionNegativeFeedback class]];
}

- (SearchProfil *)currentSearchPreference {
    return [SearchProfil createWithCuisine:self.cuisine priceRange:self.priceRange maxDistance:self.maxDistance];
}

- (ConversationToken *)lastSuggestionWarning {
    return [[self.tokensOfCurrentSearch linq_ofType:[FHWarningIfNotInPreferredRange class]] linq_lastOrNil];
}


- (DistanceRange *)maxDistance {
    USuggestionFeedbackForTooFarAway *lastFeedback = [[self.tokensOfCurrentSearch linq_ofType:[USuggestionFeedbackForTooFarAway class]] linq_lastOrNil];
    if (lastFeedback == nil) {
        return [DistanceRange distanceRangeWithoutRestriction];
    }
    else {
        // set max distance to 1/3 nearer
        CLLocationDistance distance = [lastFeedback.restaurant.location distanceFromLocation:lastFeedback.currentUserLocation];
        return [DistanceRange distanceRangeNearerThan:distance];
    }
}

- (NSString *)cuisine {
    UCuisinePreference *preference = [[self.tokensOfCurrentSearch linq_ofType:[UCuisinePreference class]] linq_lastOrNil];
    if (preference == nil) {
        @throw [DesignByContractException createWithReason:@"cuisine preference is unknown"];
    }
    return preference.text;
}

- (PriceRange *)priceRange {
    PriceRange *priceRange = [PriceRange priceRangeWithoutRestriction];
    for (ConversationToken *token in [self tokensOfCurrentSearch]) {
        if ([token isKindOfClass:[USuggestionFeedbackForTooExpensive class]]) {

            NSUInteger priceLevel = ((USuggestionFeedbackForTooExpensive *) token).restaurant.priceLevel;
            if (priceLevel == GOOGLE_PRICE_LEVEL_MIN) {
                priceLevel = GOOGLE_PRICE_LEVEL_MIN + 1;
            }
            priceRange = [priceRange setMaxLowerThan:priceLevel];
        }
        else if ([token isKindOfClass:[USuggestionFeedbackForTooCheap class]]) {
            NSUInteger priceLevel = ((USuggestionFeedbackForTooCheap *) token).restaurant.priceLevel;
            if (priceLevel == GOOGLE_PRICE_LEVEL_MAX) {
                priceLevel = GOOGLE_PRICE_LEVEL_MAX - 1;
            }
            priceRange = [priceRange setMinHigherThan:priceLevel];
        }
    }
    return priceRange;
}


- (NSArray *)suggestedRestaurants {
    return [[self.tokensOfCurrentSearch linq_ofType:[FHSuggestionBase class]] linq_select:^(FHSuggestionBase *s) {
        return s.restaurant;
    }];
}
@end
