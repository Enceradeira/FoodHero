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
    id <IEnvironment> _environment;
}

- (instancetype)initWithInput:(RACSignal *)input assembly:(id <ApplicationAssembly>)assembly {
    self = [super init];
    if (self != nil) {
        _statements = [NSMutableArray new];
        _rawConversation = [NSMutableArray new];
        _input = input;
        _assembly = assembly;
        _isStarted = NO;
        _id = [UserId id];
    }
    return self;
}

- (void)start {
    assert(!_isStarted);

    _environment = [_assembly environment];
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
        }] linq_where:^(id state) {
            return (BOOL) (state != [NSNull null]);
        }];

        Restaurant *restaurant = [[[[utterance customData] linq_ofType:FoodHeroSuggestionParameters.class] linq_select:^(FoodHeroSuggestionParameters *parameter) {
            return [parameter restaurant];
        }] linq_firstOrNil];

        if (restaurant == nil) {
            restaurant = [[[[utterance customData] linq_ofType:USuggestionFeedbackParameters.class] linq_select:^(USuggestionFeedbackParameters *parameter) {
                return [parameter restaurant];
            }] linq_firstOrNil];
        }

        ExpectedUserUtterances *expectedUserUtterances = [[[[[utterance customData]
                linq_ofType:FoodHeroParameters.class]
                linq_select:^(FoodHeroSuggestionParameters *parameter) {
                    return [parameter expectedUserUtterances];
                }]
                linq_where:^(id expectedUtterances) {
                    return (BOOL) (expectedUtterances != [NSNull null]);
                }] linq_firstOrNil];

        NSString *semanticIdString = [semanticIds componentsJoinedByString:@";"];
        NSString *statesString = [states componentsJoinedByString:@";"];
        NSString *text = utterance.utterance;

        Statement *statement = [Statement createWithSemanticId:semanticIdString
                                                          text:text state:(statesString.length > 0 ? statesString : nil)
                                           suggestedRestaurant:restaurant
                                        expectedUserUtterances:expectedUserUtterances];

        [self addStatement:statement];
    }];

    [streams.rawOutput subscribeNext:^(TalkerUtterance *utterance) {
        assert([utterance customData].count == 1);
        [_rawConversation addObject:utterance];
    }];

    _isStarted = YES;
}

- (NSArray *)conversationParameters {
    return [_rawConversation linq_select:^(TalkerUtterance *t) {
        return [t customData][0];
    }];
}

- (NSArray *)parametersOfCurrentSearch {
    NSArray *parameters = self.conversationParameters;
    Statement *lastUserUtterance = [[parameters linq_where:^(ConversationParameters *p) {
        return (BOOL) ([p hasSemanticId:@"FH:ConfirmsRestart"] ||
                [p hasSemanticId:@"FH:Greeting"] ||
                [p hasSemanticId:@"FH:OpeningQuestion"] ||
                [p hasSemanticId:@"U:OccasionPreference"] ||
                [p hasSemanticId:@"U:CuisinePreference"]
        );
    }]
            linq_lastOrNil];

    // -> "lastUserUtterance" is followed by things that belong to next search
    NSUInteger currentSearchBeginCount = 0;
    if (lastUserUtterance != nil) {
        currentSearchBeginCount = [parameters indexOfObject:lastUserUtterance];
    }

    return [parameters linq_skip:currentSearchBeginCount];

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
    return [self.conversationParameters linq_where:^(ConversationParameters *p) {
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
                                   occasion:[self currentOccasion]];
}

- (NSString *)currentOccasion {
    NSArray *parameters = self.parametersOfCurrentSearch;
    UserParameters *preference = [[[parameters linq_ofType:[UserParameters class]] linq_where:^(UserParameters *p) {
        return (BOOL) [p hasSemanticId:@"U:OccasionPreference"];
    }] linq_lastOrNil];

    if (preference != nil) {
        return preference.parameter;
    }
    else {
        BOOL hasUserUtteredCuisinePreference = [parameters linq_any:^(ConversationParameters *p) {
            return (BOOL) [p hasSemanticId:@"U:CuisinePreference"];
        }];

        if (hasUserUtteredCuisinePreference) {
            return [Occasions guessFromCuisine:self.cuisine];
        }
        else {
            // Default make FH suggest something reasonable without user feedback
            return [Occasions getCurrent:_environment];
        }
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
    NSArray *parameters = self.parametersOfCurrentSearch;
    if ([parameters linq_any:^(ConversationParameters *p) {
        return (BOOL) ([p.semanticIdInclParameters isEqualToString:@"U:SuggestionFeedback=theClosestNow"]);
    }]) {
        return [DistanceRange distanceRangeNearerThan:0];
    }

    USuggestionFeedbackParameters *lastFeedback = [[parameters linq_where:^(ConversationParameters *p) {
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

- (NSArray *)suggestedRestaurantsInCurrentSearch {
    return [[self.parametersOfCurrentSearch linq_ofType:[FoodHeroSuggestionParameters class]] linq_select:^(FoodHeroSuggestionParameters *s) {
        return s.restaurant;
    }];
}

- (ConversationParameters *)lastUserResponse {
    return [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) ([p hasSemanticId:@"U:"]);
    }] linq_lastOrNil];
}

- (Statement *)lastRawSuggestion {
    TalkerUtterance *lastSuggestion = [[_rawConversation linq_where:^(TalkerUtterance *t) {
        ConversationParameters *conversationParameter = [t customData][0];
        return (BOOL) [conversationParameter isKindOfClass:[FoodHeroSuggestionParameters class]];
    }] linq_lastOrNil];

    if( lastSuggestion == nil){
        return nil;
    }

    FoodHeroSuggestionParameters *parameter = [lastSuggestion customData][0];
    return [Statement createWithSemanticId:parameter.semanticIdInclParameters
                                      text:lastSuggestion.utterance
                                     state:nil
                       suggestedRestaurant:parameter.restaurant
                    expectedUserUtterances:nil];
}
@end
