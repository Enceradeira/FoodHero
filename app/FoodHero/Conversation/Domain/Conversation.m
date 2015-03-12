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
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"
#import "RestaurantSearch.h"
#import "FoodHero-Swift.h"


@interface Conversation ()
@property(nonatomic) NSMutableArray *statements;
@end

@implementation Conversation {

    RACSignal *_input;
    NSMutableArray *_rawConversation;
}


- (instancetype)init {
    return [self initWithInput:[RACSubject new]];
}

- (instancetype)initWithInput:(RACSignal *)input {
    self = [super init];
    if (self != nil) {
        _statements = [NSMutableArray new];
        _rawConversation = [NSMutableArray new];
        _input = input;

        id <IRandomizer> randomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] talkerRandomizer];
        RestaurantSearch *search = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
        LocationService *locationService = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationService];
        id <ISchedulerFactory> schedulerFactory = [(id <ApplicationAssembly>) [TyphoonComponents factory] schedulerFactory];
        ConversationResources *resources = [[ConversationResources alloc] initWithRandomizer:randomizer];
        TalkerContext *context = [[TalkerContext alloc] initWithRandomizer:randomizer resources:resources];
        ConversationScript *script = [[ConversationScript alloc] initWithContext:context conversation:self search:search locationService:locationService schedulerFactory:schedulerFactory];

        TalkerEngine *engine = [[TalkerEngine alloc] initWithScript:script input:_input];

        TalkerStreams *streams = [engine execute];

        [streams.naturalOutput subscribeNext:^(TalkerUtterance *utterance) {
            NSArray *semanticIds = [[utterance customData] linq_select:^(ConversationParameters *parameter) {
                return [parameter semanticIdInclParameters];
            }];
            NSArray *states = [[[[utterance customData] linq_ofType:FoodHeroParameters.class] linq_select:^(FoodHeroParameters *parameter) {
                return [parameter state];
            }] linq_where:^(NSString *state) {
                return (BOOL) (state != [NSNull null]);
            }];

            Restaurant* restaurant = [[[[utterance customData] linq_ofType:FoodHeroSuggestionParameters.class] linq_select:^(FoodHeroSuggestionParameters *parameter) {
                return [parameter restaurant];
            }] linq_firstOrNil];

            NSString *semanticIdString = [semanticIds componentsJoinedByString:@";"];
            NSString *statesString = [states componentsJoinedByString:@";"];
            NSString *text = utterance.utterance;

            Statement *statement = [Statement createWithSemanticId:semanticIdString text:text state:(statesString.length > 0 ? statesString : nil) suggestedRestaurant:restaurant];

            [self addStatement:statement];
        }];

        [streams.rawOutput subscribeNext:^(TalkerUtterance *utterance) {
            assert([utterance customData].count == 1);

            ConversationParameters *parameters = [utterance customData][0];
            [_rawConversation addObject:parameters];
        }];
    }
    return self;
}


- (NSArray *)parametersOfCurrentSearch {
    Statement *lastOpeningQuestion = [[_rawConversation
            linq_where:^(ConversationParameters *p) {
                return (BOOL) [p hasSemanticId:@"FH:OpeningQuestion"];
            }]
            linq_lastOrNil];

    NSUInteger currentSearchBeginCount = lastOpeningQuestion == nil ? 0 : [_rawConversation indexOfObject:lastOpeningQuestion] + 1;

    return [_rawConversation linq_skip:currentSearchBeginCount];

}

- (void)addStatement:(Statement *)statement {
    NSMutableArray *statementProxy = [self mutableArrayValueForKey:@"statements"]; // In order that KVC-Events are fired
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
    return [self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) (
                [p.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=Dislike"] ||
                        [p.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=tooCheap"] ||
                        [p.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=tooExpensive"] ||
                        [p.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=tooFarAway"]
        );
    }];
}

- (SearchProfile *)currentSearchPreference {
    return [SearchProfile createWithCuisine:self.cuisine priceRange:self.priceRange maxDistance:self.maxDistance];
}

- (ConversationParameters *)lastSuggestionWarning {
    return [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) (
                [p.semanticIdInclParameters isEqualToString:@"FH:WarningIfNotInPreferredRangeTooCheap"] ||
                        [p.semanticIdInclParameters isEqualToString:@"FH:WarningIfNotInPreferredRangeTooExpensive"] ||
                        [p.semanticIdInclParameters isEqualToString:@"FH:WarningIfNotInPreferredRangeTooFarAway"]
        );
    }] linq_lastOrNil];
}


- (DistanceRange *)maxDistance {
    USuggestionFeedbackParameters *lastFeedback = [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) (
                [p.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=tooFarAway"]
        );
    }] linq_lastOrNil];
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
    UserParameters *preference = [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) (
                [p hasSemanticId:@"U:CuisinePreference"]
        );
    }] linq_lastOrNil];
    if (preference == nil) {
        @throw [DesignByContractException createWithReason:@"cuisine preference is unknown"];
    }
    return preference.parameter;
}

- (PriceRange *)priceRange {
    PriceRange *priceRange = [PriceRange priceRangeWithoutRestriction];
    for (ConversationParameters *parameter in [self parametersOfCurrentSearch]) {
        if ([parameter.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=tooExpensive"]) {

            NSUInteger priceLevel = ((USuggestionFeedbackParameters *) parameter).restaurant.priceLevel;
            if (priceLevel == GOOGLE_PRICE_LEVEL_MIN) {
                priceLevel = GOOGLE_PRICE_LEVEL_MIN + 1;
            }
            priceRange = [priceRange setMaxLowerThan:priceLevel];
        }
        else if ([parameter.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=tooCheap"]) {
            NSUInteger priceLevel = ((USuggestionFeedbackParameters *) parameter).restaurant.priceLevel;
            if (priceLevel == GOOGLE_PRICE_LEVEL_MAX) {
                priceLevel = GOOGLE_PRICE_LEVEL_MAX - 1;
            }
            priceRange = [priceRange setMinHigherThan:priceLevel];
        }
    }
    return priceRange;
}

- (NSArray *)suggestedRestaurants {
    return [[self.parametersOfCurrentSearch linq_ofType:[FoodHeroSuggestionParameters class]] linq_select:^(FoodHeroSuggestionParameters *s) {
        return s.restaurant;
    }];
}

- (ConversationParameters *)lastUserResponse {
    return [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) ([p hasSemanticId:@"U:"]);
    }] linq_lastOrNil];
}
@end
