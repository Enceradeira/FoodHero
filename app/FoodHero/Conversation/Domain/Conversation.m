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
#import "TyphoonComponents.h"
#import "RestaurantSearch.h"
#import "FoodHero-Swift.h"


@interface Conversation ()
@property(nonatomic) NSMutableArray *statements;
@end

@implementation Conversation {

    RACSignal *_input;
    NSMutableArray *_rawConversation;
    id <ApplicationAssembly> _assembly;
    bool _isStarted;
}

- (instancetype)initWithInput:(RACSignal *)input assembly:(id <ApplicationAssembly>)assembly {
    self = [super init];
    if (self != nil) {
        _statements = [NSMutableArray new];
        _rawConversation = [NSMutableArray new];
        _input = input;
        _assembly = assembly;
        _isStarted = NO;
    }
    return self;
}

- (void)start {
    assert(!_isStarted);

    id <IRandomizer> randomizer = [_assembly talkerRandomizer];
    RestaurantSearch *search = [_assembly restaurantSearch];
    LocationService *locationService = [_assembly locationService];
    id <ISchedulerFactory> schedulerFactory = [_assembly schedulerFactory];
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

        Restaurant *restaurant = [[[[utterance customData] linq_ofType:FoodHeroSuggestionParameters.class] linq_select:^(FoodHeroSuggestionParameters *parameter) {
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

    _isStarted = YES;
}

- (NSArray *)parametersOfCurrentSearch {
    Statement *lastWhatToDoNext = [[[_rawConversation linq_ofType:[FoodHeroParameters class]]
            linq_where:^(FoodHeroParameters *p) {
                return (BOOL) [p.state isEqualToString:[FHStates askForWhatToDoNext]];
            }]
            linq_lastOrNil];

    // -> "askWhatToDoNext" is followed by user-answer and then next search starts
    NSUInteger indexOfNextSearchBegin = [_rawConversation indexOfObject:lastWhatToDoNext] + 2;
    NSUInteger currentSearchBeginCount = (lastWhatToDoNext == nil || indexOfNextSearchBegin >= _rawConversation.count) ? 0 : indexOfNextSearchBegin;

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

- (SearchProfile *)currentSearchPreference:(double)maxDistancePlaces currUserLocation:(CLLocation *)location {
    return [SearchProfile createWithCuisine:self.cuisine
                                 priceRange:self.priceRange
                                maxDistance:[self maxDistance:maxDistancePlaces currLocation:location]
                                   occasion:[Occasions getCurrent]];
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


- (DistanceRange *)maxDistance:(double)maxDistancePlaces currLocation:(CLLocation *)location {
    USuggestionFeedbackParameters *lastFeedback = [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) (
                [p.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=tooFarAway"]
        );
    }] linq_lastOrNil];
    if (lastFeedback == nil) {
        return nil;
    }
    else {
        // set max distance to 1/3 nearer
        CLLocationDistance distance = [lastFeedback.restaurant.location distanceFromLocation:location];
        CLLocationDistance normalizedDistance = maxDistancePlaces == 0 ? 0 : distance / maxDistancePlaces;
        return [DistanceRange distanceRangeNearerThan:normalizedDistance];
    }
}

- (NSString *)cuisine {
    UserParameters *preference = [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) (
                [p hasSemanticId:@"U:CuisinePreference"]
        );
    }] linq_lastOrNil];
    if (preference == nil) {
        return @"";
    }
    return preference.parameter;
}

- (PriceRange*)priceRange {
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

- (NSArray*)suggestedRestaurants {
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
