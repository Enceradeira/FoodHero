//
//  ConversationAppService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "ConversationAppService.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleUser.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "SpeechInterpretation.h"
#import "UCuisinePreference.h"
#import "USuggestionFeedback.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "USuggestionFeedbackForLiking.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "UTryAgainNow.h"
#import "UWantsToAbort.h"
#import "UGoodBye.h"
#import "AskUserCuisinePreferenceAction.h"
#import "AskUserIfProblemWithAccessLocationServiceResolved.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "AskUserToTryAgainAction.h"
#import "AskUserWhatToDoNextAction.h"
#import "AskUserWhatToDoAfterGoodByeAction.h"

static UIImage *LikeImage;
static UIImage *EmptyImage;


@implementation ConversationAppService {
    NSMutableDictionary *_bubbles;
    Conversation *_conversation;
    NSArray *_cuisines;
    NSArray *_feedbacks;
    LocationService *_locationService;
    RestaurantRepository *_restaurantRepository;
    BOOL _doRenderSemanticID;
    NSTimeInterval _interactionDelay;
    id <ISpeechRecognitionService> _speechRecognitionService;
}


+ (void)initialize {
    [super initialize];
    LikeImage = [UIImage imageNamed:@"Like-Icon.png"];
    EmptyImage = [UIImage imageNamed:@"Empty-Icon.png"];
}

- (instancetype)initWithConversationRepository:(ConversationRepository *)conversationRepository
                          restaurantRepository:(RestaurantRepository *)restaurantRepository
                               locationService:(LocationService *)locationService
                      speechRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService {
    self = [super init];
    if (self != nil) {
        _doRenderSemanticID = NO;
        _bubbles = [NSMutableDictionary new];
        _locationService = locationService;
        _restaurantRepository = restaurantRepository;
        _speechRecognitionService = speechRecognitionService;
        _conversation = conversationRepository.get;
    }
    return self;
}

+ (UIImage *)emptyImage {
    return EmptyImage;
}

- (void)addUserInput:(ConversationToken *)userInput {
    [_conversation addToken:userInput];
    // delays for integration testing
    [NSThread sleepForTimeInterval:_interactionDelay];
}

- (NSInteger)getStatementCount {
    return _conversation.getStatementCount;
}

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth {

    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long) index, (long) bubbleWidth];
    ConversationBubble *bubble = _bubbles[key];
    if (bubble == nil) {
        Statement *statement = [_conversation getStatement:index];

        if (statement.persona == Personas.foodHero) {
            bubble = [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:bubbleWidth index:index inputAction:statement.inputAction doRenderSemanticID:_doRenderSemanticID];
        }
        else {
            bubble = [[ConversationBubbleUser alloc] initWithStatement:statement width:bubbleWidth index:index doRenderSemanticID:_doRenderSemanticID];
        }

        _bubbles[key] = bubble;
    }
    return bubble;
}

- (RACSignal *)statementIndexes {
    return _conversation.statementIndexes;
}

- (Restaurant *)getLastSuggestedRestaurant {
    NSArray *restaurants = _conversation.suggestedRestaurants;
    if (restaurants.count == 0) {
        @throw [DesignByContractException createWithReason:@"no restaurants have ever been suggested to user"];
    }
    return [restaurants linq_lastOrNil];
}

- (void)processCheat:(NSString *)command {
    if ([command isEqualToString:@"C:FS"]) {
        // find something
        [_restaurantRepository simulateNoRestaurantFound:NO];
    }
    else if ([command isEqualToString:@"C:FN"]) {
        // find nothing
        [_restaurantRepository simulateNoRestaurantFound:YES];
    }
    else if ([command isEqualToString:@"C:NE"]) {
        // network error
        [_restaurantRepository simulateNetworkError:YES];
    }
    else if ([command isEqualToString:@"C:SS"]) {
        // show semantic-id
        _doRenderSemanticID = YES;
    }
    else if ([command isEqualToString:@"C:BS"]) {
        // be slow
        [_restaurantRepository simulateSlowResponse:YES];
    }

}

- (void)subscribeInterpretationOfCuisinePreference:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        if ([interpretation.intent isEqualToString:@"setFoodPreference"] && interpretation.entities.count == 1) {
            [self addUserInput:[UCuisinePreference create:interpretation.entities[0] text:interpretation.text]];
        }
    }];
}

- (void)subscribeInterpretationOfSuggestionFeedback:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        Restaurant *restaurant = [self getLastSuggestedRestaurant];
        if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooFarAway"]) {
            [self addUserInput:[USuggestionFeedbackForTooFarAway create:restaurant currentUserLocation:_locationService.lastKnownLocation text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooExpensive"]) {
            [self addUserInput:[USuggestionFeedbackForTooExpensive create:restaurant text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooCheap"]) {
            [self addUserInput:[USuggestionFeedbackForTooCheap create:restaurant text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Dislike"]) {
            [self addUserInput:[USuggestionFeedbackForNotLikingAtAll create:restaurant text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Like"]) {
            [self addUserInput:[USuggestionFeedbackForLiking create:restaurant text:interpretation.text]];
        }
    }];
}

- (void)subscribeInterpretationOfWhatToDoNext:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        if ([interpretation.intent isEqualToString:@"goodBye"]) {
            [self addUserInput:[UGoodBye create:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"searchForAnotherRestaurant"]) {
            [self addUserInput:[UWantsToSearchForAnotherRestaurant create:interpretation.text]];
        }
    }];
}

- (void)subscribeInterpretationOfAnswerAfterNoRestaurantWasFound:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        if ([interpretation.intent isEqualToString:@"tryAgainNow"]) {
            [self addUserInput:[UTryAgainNow create:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"abort"]) {
            [self addUserInput:[UWantsToAbort create:interpretation.text]];
        }
    }];
}

- (void)subscribeInterpretationOfAskUserIfProblemWithAccessLocationServiceResolved:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        [self addUserSolvedProblemWithAccessLocationService:interpretation.text];
    }];
}

- (void)subscribeInterpretationOfAskUserWhatToDoAfterGoodBye:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        [self addAnswerAfterForWhatToAfterGoodBye:interpretation.text];
    }];
}

- (void)addUserCuisinePreference:(NSString *)string action:(id <IUAction>)action {
    RACSignal *signal = [_speechRecognitionService interpretString:string state:[action getStateName]];

    [self subscribeInterpretationOfCuisinePreference:signal];
}

- (void)addUserSuggestionFeedback:(NSString *)string action:(id <IUAction>)action {
    RACSignal *signal = [_speechRecognitionService interpretString:string state:[action getStateName]];

    [self subscribeInterpretationOfSuggestionFeedback:signal];
}

- (void)addUserSolvedProblemWithAccessLocationService:(NSString *)string {
    [self addUserInput:[UDidResolveProblemWithAccessLocationService create:string]];
}

- (void)addAnswerAfterForWhatToAfterGoodBye:(NSString *)string {
    [self addUserInput:[UWantsToSearchForAnotherRestaurant create:string]];
}


- (void)addUserAnswerAfterNoRestaurantWasFound:(NSString *)string action:(id <IUAction>)action {
    RACSignal *signal = [_speechRecognitionService interpretString:string state:[action getStateName]];

    [self subscribeInterpretationOfAnswerAfterNoRestaurantWasFound:signal];
}

- (void)addUserAnswerForWhatToDoNext:(NSString *)string action:(id <IUAction>)action {
    RACSignal *signal = [_speechRecognitionService interpretString:string state:[action getStateName]];

    [self subscribeInterpretationOfWhatToDoNext:signal];
}


- (void)addUserText:(NSString *)string forInputAction:(id <IUAction>)inputAction {
    if ([inputAction isEqual:[AskUserCuisinePreferenceAction new]]) {
        [self addUserCuisinePreference:string action:inputAction];
    }
    else if ([inputAction isEqual:[AskUserSuggestionFeedbackAction new]]) {
        [self addUserSuggestionFeedback:string action:inputAction];
    }
    else if ([inputAction isEqual:[AskUserIfProblemWithAccessLocationServiceResolved new]]) {
        [self addUserSolvedProblemWithAccessLocationService:string];
    }
    else if ([inputAction isEqual:[AskUserWhatToDoAfterGoodByeAction new]]) {

        [self addAnswerAfterForWhatToAfterGoodBye:string];
    }
    else if ([inputAction isEqual:[AskUserToTryAgainAction new]]) {

        [self addUserAnswerAfterNoRestaurantWasFound:string action:inputAction];
    }
    else if ([inputAction isEqual:[AskUserWhatToDoNextAction new]]) {

        [self addUserAnswerForWhatToDoNext:string action:inputAction];
    }
    else {
        @throw [DesignByContractException createWithReason:@"unhandled inputAction"];
    }
}

- (RACSignal *)addUserVoiceForInputAction:(id <IUAction>)inputAction {
    RACSignal *signal = [_speechRecognitionService recordAndInterpretUserVoice:[inputAction getStateName]];
    if ([inputAction isEqual:[AskUserCuisinePreferenceAction new]]) {
        [self subscribeInterpretationOfCuisinePreference:signal];
    }
    else if ([inputAction isEqual:[AskUserSuggestionFeedbackAction new]]) {
        [self subscribeInterpretationOfSuggestionFeedback:signal];
    }
    else if ([inputAction isEqual:[AskUserIfProblemWithAccessLocationServiceResolved new]]) {
        [self subscribeInterpretationOfAskUserIfProblemWithAccessLocationServiceResolved:signal];
    }
    else if ([inputAction isEqual:[AskUserWhatToDoAfterGoodByeAction new]]) {
        [self subscribeInterpretationOfAskUserWhatToDoAfterGoodBye:signal];
    }
    else if ([inputAction isEqual:[AskUserToTryAgainAction new]]) {
        [self subscribeInterpretationOfAnswerAfterNoRestaurantWasFound:signal];
    }
    else if ([inputAction isEqual:[AskUserWhatToDoNextAction new]]) {
        [self subscribeInterpretationOfWhatToDoNext:signal];
    }
    else {
        @throw [DesignByContractException createWithReason:@"unhandled inputAction"];
    }


    return signal;
}

- (AVAudioSessionRecordPermission)recordPermission {
    return [_speechRecognitionService recordPermission];
}
@end
