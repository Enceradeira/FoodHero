//
//  Conversation.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
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

    RACSubject *_talkerInput;
    RACSubject *_scriptInput;
    RACSignal *_input;
    RACSubject *_controlInput;
    NSMutableArray *_rawConversation;
    NSMutableArray *_recordedInput;
    id <ApplicationAssembly> _assembly;
    bool _isStarted;
    id <IEnvironment> _environment;
    id <IRandomizer> _randomizer;
    TalkerEngine *_engine;
    TalkerContext *_context;
    id _schedulerFactory;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _statements = [NSMutableArray new];
        _rawConversation = [NSMutableArray new];
        _recordedInput = [NSMutableArray new];
        [self initCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        _statements = [coder decodeObjectForKey:@"_statements"];
        _rawConversation = [coder decodeObjectForKey:@"_rawConversation"];
        _recordedInput = [coder decodeObjectForKey:@"_recordedInput"];
        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    _isStarted = NO;
    _id = [Configuration userId];
    _scriptInput = [RACSubject new];
    _talkerInput = [RACSubject new];
    _controlInput = [RACSubject new];
}

- (void)setInput:(RACSignal *)input {
    _input = input;
}

- (void)sendControlInput:(id)input {
    [_controlInput sendNext:input];
}

- (void)setAssembly:(id <ApplicationAssembly>)assembly {
    _assembly = assembly;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_statements forKey:@"_statements"];
    [coder encodeObject:_rawConversation forKey:@"_rawConversation"];
    [coder encodeObject:_recordedInput forKey:@"_recordedInput"];
}

- (ConversationScript *)createConversationScriptWithGreeting {
    RestaurantSearch *search = [_assembly restaurantSearch];
    LocationService *locationService = [_assembly locationService];
    ConversationScript *script = [[ConversationScript alloc] initWithContext:_context
                                                                conversation:self
                                                                controlInput:_scriptInput
                                                                      search:search
                                                             locationService:locationService
                                                            schedulerFactory:_schedulerFactory];
    return script;
}

- (void)resumeWithFeedbackRequest:(BOOL)isForFeedbackRequest {
    if (_isStarted) {
        [self sendRequestProductFeedbackInterruption:isForFeedbackRequest];
    }
    else {
        [self startWithFeedbackRequest:isForFeedbackRequest];
    }
}

- (void)startWithFeedbackRequest:(BOOL)isForFeedbackRequest {
    _environment = [_assembly environment];
    _randomizer = [_assembly talkerRandomizer];

    _schedulerFactory = [_assembly schedulerFactory];
    ConversationResources *resources = [[ConversationResources alloc] initWithRandomizer:_randomizer];
    _context = [[TalkerContext alloc] initWithRandomizer:_randomizer resources:resources];

    // Create Script
    __block BOOL isRestoringStatements = _statements.count > 0;
    ConversationScript *script = [self createConversationScriptWithGreeting];

    // Create Inputs
    [[_input merge:_controlInput] subscribeNext:^(id input) {
        [_recordedInput addObject:input];
        [self dispatchInputToTalkerOfScript:input];
    }];


    // Create Talker
    NSArray *recordedInputBeforeScriptStarted = [_recordedInput copy];

    _engine = [[TalkerEngine alloc] initWithInput:_talkerInput];
    TalkerStreams *streams = _engine.output;
    [_engine interruptWith:script];

    // Restore State of conversation
    for (id input in recordedInputBeforeScriptStarted) {
        [self dispatchInputToTalkerOfScript:input];
    }

    // Create Outputs
    [streams.naturalOutput subscribeNext:^(TalkerUtterance *utterance) {
        if (isRestoringStatements) {
            // Ignore signals when Conversation is being restored
            return;
        }
        NSArray *semanticIds = [[utterance customData] linq_select:^(ConversationParameters *parameter) {
            return [parameter semanticIdInclParameters];
        }];
        NSArray *states = [[[[[utterance customData] linq_ofType:FoodHeroParameters.class] linq_select:^(FoodHeroParameters *parameter) {
            return [parameter state];
        }] linq_where:^(id state) {
            return (BOOL) (state != [NSNull null]);
        }] linq_distinct];

        Restaurant *restaurant = [[[[utterance customData] linq_ofType:FoodHeroRestaurantParameters.class] linq_select:^(FoodHeroSuggestionParameters *parameter) {
            return [parameter restaurant];
        }] linq_firstOrNil];

        if (restaurant == nil) {
            restaurant = [[[[utterance customData] linq_ofType:USuggestionFeedbackParameters.class] linq_select:^(USuggestionFeedbackParameters *parameter) {
                return [parameter restaurant];
            }] linq_firstOrNil];
        }

        ExpectedUserUtterances *expectedUserUtterances = [[[[[utterance customData]
                linq_ofType:FoodHeroParameters.class]
                linq_select:^(FoodHeroParameters *parameter) {
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
    isRestoringStatements = NO;
    [script startProcessingSearchRequests];

    if (_statements.count == 0) {
        [self sendControlInput:[SayGreetingControlInput new]];
        if (!isForFeedbackRequest) {
            [self sendControlInput:[StartSearchControlInput new]];
        }
    }
    [self sendRequestProductFeedbackInterruption:isForFeedbackRequest];
}

- (void)sendRequestProductFeedbackInterruption:(BOOL)doSend {
    if (doSend) {
        [self sendControlInput:[RequestProductFeedbackInterruption new]];
    }
}

- (void)dispatchInputToTalkerOfScript:(const id)input {
    if ([input isKindOfClass:NSError.class] || [input isKindOfClass:[TalkerUtterance class]]) {
        [_talkerInput sendNext:input];
    }
    else {
        [_scriptInput sendNext:input];
    }
}

- (NSArray *)conversationParameters {
    return [_rawConversation linq_select:^(TalkerUtterance *t) {
        return [t customData][0];
    }];
}

- (TalkerUtterance *)getLastUtteranceBefore:(NSString *)semanticId {
    NSUInteger idxLastNetworkError = [[self.conversationParameters linq_reverse] indexOfObjectPassingTest:^BOOL(ConversationParameters *p, NSUInteger idx, BOOL *stop) {
        return [p hasSemanticId:semanticId];
    }];
    assert(idxLastNetworkError != NSNotFound);

    return [[[[_rawConversation linq_reverse] linq_skip:idxLastNetworkError + 1] linq_where:^(TalkerUtterance *utterance) {
        ConversationParameters *p = utterance.customData[0];
        BOOL isFoodHero = [p isKindOfClass:[FoodHeroParameters class]];
        BOOL isNotRelatedToNetworkError = ![p hasSemanticId:
                semanticId];
        return (BOOL) (isFoodHero && isNotRelatedToNetworkError);
    }] linq_firstOrNil];
}

- (TalkerUtterance *)lastFoodHeroUtteranceBeforeNetworkError {
    return [self getLastUtteranceBefore:@"FH:HasNetworkError"];

}

- (TalkerUtterance *)lastFoodHeroUtteranceProductFeedback {
    return [self getLastUtteranceBefore:@"FH:AskForProductFeedback"];
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


- (NSArray *)suggestionParametersOfCurrentSearch {
    return [self.parametersOfCurrentSearch linq_ofType:[FoodHeroSuggestionParameters class]];
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

- (LINQCondition)isNegativeUserFeedback {
    return ^(ConversationParameters *parameter) {
        return (BOOL) (
                [parameter isKindOfClass:USuggestionFeedbackParameters.class] &&
                        ![parameter.semanticIdInclParameters hasPrefix:@"U:SuggestionFeedback=Like"]);
    };
}

- (NSArray *)negativeUserFeedback {
    return [self.parametersOfCurrentSearch linq_where:[self isNegativeUserFeedback]];
}

- (NSArray *)dislikedRestaurants {

    return [[self.conversationParameters linq_where:[self isNegativeUserFeedback]] linq_select:^(USuggestionFeedbackParameters *p) {
        return p.restaurant;
    }];
}

- (SearchProfile *)currentSearchPreference:(double)maxDistancePlaces searchLocation:(CLLocation *)location {
    return [SearchProfile createWithCuisine:self.cuisine
                                 priceRange:self.priceRange
                                maxDistance:[self maxDistance:maxDistancePlaces currLocation:location]
                                   occasion:[self currentOccasion]
                                   location:location];
}

- (NSString *)currentOccasion {
    NSArray *parameters = self.parametersOfCurrentSearch;
    UserParameters *preference = [[[parameters linq_ofType:[UserParameters class]] linq_where:^(UserParameters *p) {
        return (BOOL) [p hasSemanticId:@"U:OccasionPreference"];
    }] linq_lastOrNil];

    if (preference != nil) {
        return preference.parameter.text;
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
    return preference.parameter.text;
}

- (ConversationParameters *)lastSuggestionWarning {
    return [[self.parametersOfCurrentSearch linq_where:^(ConversationParameters *p) {
        return (BOOL) (
                [p.semanticIdInclParameters hasPrefix:@"FH:SuggestionIfNotInPreferredRangeTooCheap"] ||
                        [p.semanticIdInclParameters hasPrefix:@"FH:SuggestionIfNotInPreferredRangeTooExpensive"] ||
                        [p.semanticIdInclParameters hasPrefix:@"FH:SuggestionIfNotInPreferredRangeTooFarAway"]
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

- (NSString *)currentSearchLocation {
    return [[[[self.parametersOfCurrentSearch linq_ofType:[UserParameters class]] linq_select:^(UserParameters *s) {
        return s.parameter.location;
    }] linq_where:^(id location) {
        return (BOOL) (location != nil);
    }] linq_lastOrNil];
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

    if (lastSuggestion == nil) {
        return nil;
    }

    FoodHeroSuggestionParameters *parameter = [lastSuggestion customData][0];
    return [Statement createWithSemanticId:parameter.semanticIdInclParameters
                                      text:lastSuggestion.utterance
                                     state:nil
                       suggestedRestaurant:parameter.restaurant
                    expectedUserUtterances:nil];
}


- (BOOL)wasChatty {
    NSInteger nrConsecutiveChattyMsgs = 0;
    NSInteger upperThreshold = 2;   // FH starts with some funny sentences before coming more quiet
    NSInteger underThreshold = [self getRandomChattyUnderThreshold];
    BOOL isChatty = NO;
    for (FoodHeroSuggestionParameters *p in self.suggestionParametersOfCurrentSearch) {
        if ([p hasSemanticId:@"FH:SuggestionSimple"]) {
            nrConsecutiveChattyMsgs--;
        }
        else {
            nrConsecutiveChattyMsgs++;
        }
        if (nrConsecutiveChattyMsgs >= upperThreshold) {
            isChatty = YES;
            upperThreshold = [self getRandomChattyUpperThreshold];
        }
        else if (nrConsecutiveChattyMsgs <= underThreshold) {
            isChatty = NO;
            underThreshold = [self getRandomChattyUnderThreshold];
        }
    }
    return isChatty;
}

- (int)getRandomChattyUnderThreshold {
    return [_randomizer isTrueForTag:[RandomizerConstants chattyThreshold]] ? 0 : 1;
}

- (int)getRandomChattyUpperThreshold {
    return [_randomizer isTrueForTag:[RandomizerConstants chattyThreshold]] ? 2 : 1;
}

@end
