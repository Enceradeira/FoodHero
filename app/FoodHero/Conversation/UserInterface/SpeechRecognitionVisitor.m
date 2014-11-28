//
// Created by Jorg on 28/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "SpeechRecognitionVisitor.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "SpeechInterpretation.h"
#import "UWantsToAbort.h"
#import "UTryAgainNow.h"
#import "UGoodBye.h"
#import "USuggestionFeedbackForLiking.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "UCuisinePreference.h"
#import "DesignByContractException.h"


@implementation SpeechRecognitionVisitor {

}

- (instancetype)initWithRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService
                           locationService:(LocationService *)locationService
                              conversation:(Conversation *)conversation {
    self = [super init];
    if (self) {
        _speechRecognitionService = speechRecognitionService;
        _locationService = locationService;
        _conversation = conversation;
    }
    return self;
}

- (Restaurant *)getLastSuggestedRestaurant {
    NSArray *restaurants = _conversation.suggestedRestaurants;
    if (restaurants.count == 0) {
        @throw [DesignByContractException createWithReason:@"no restaurants have ever been suggested to user"];
    }
    return [restaurants linq_lastOrNil];
}

- (void)subscribeInterpretationOfCuisinePreference:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        if ([interpretation.intent isEqualToString:@"setFoodPreference"] && interpretation.entities.count == 1) {
            ConversationToken *userInput = [UCuisinePreference create:interpretation.entities[0] text:interpretation.text];
            [_conversation addToken:userInput];
        }
    }];
}

- (void)subscribeInterpretationOfSuggestionFeedback:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        Restaurant *restaurant = [self getLastSuggestedRestaurant];
        if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooFarAway"]) {
            ConversationToken *userInput = [USuggestionFeedbackForTooFarAway create:restaurant currentUserLocation:_locationService.lastKnownLocation text:interpretation.text];
            [_conversation addToken:userInput];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooExpensive"]) {
            ConversationToken *userInput = [USuggestionFeedbackForTooExpensive create:restaurant text:interpretation.text];
            [_conversation addToken:userInput];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooCheap"]) {
            ConversationToken *userInput = [USuggestionFeedbackForTooCheap create:restaurant text:interpretation.text];
            [_conversation addToken:userInput];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Dislike"]) {
            ConversationToken *userInput = [USuggestionFeedbackForNotLikingAtAll create:restaurant text:interpretation.text];
            [_conversation addToken:userInput];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Like"]) {
            ConversationToken *userInput = [USuggestionFeedbackForLiking create:restaurant text:interpretation.text];
            [_conversation addToken:userInput];
        }
    }];
}

- (void)subscribeInterpretationOfWhatToDoNext:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        if ([interpretation.intent isEqualToString:@"goodBye"]) {
            ConversationToken *userInput = [UGoodBye create:interpretation.text];
            [_conversation addToken:userInput];
        }
        else if ([interpretation.intent isEqualToString:@"searchForAnotherRestaurant"]) {
            ConversationToken *userInput = [UWantsToSearchForAnotherRestaurant create:interpretation.text];
            [_conversation addToken:userInput];
        }
    }];
}

- (void)subscribeInterpretationOfAnswerAfterNoRestaurantWasFound:(RACSignal *)signal {
    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        if ([interpretation.intent isEqualToString:@"tryAgainNow"]) {
            ConversationToken *userInput = [UTryAgainNow create:interpretation.text];
            [_conversation addToken:userInput];
        }
        else if ([interpretation.intent isEqualToString:@"abort"]) {
            ConversationToken *userInput = [UWantsToAbort create:interpretation.text];
            [_conversation addToken:userInput];
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


- (void)addUserSolvedProblemWithAccessLocationService:(NSString *)string {
    ConversationToken *userInput = [UDidResolveProblemWithAccessLocationService create:string];
    [self.conversation addToken:userInput];
}

- (void)addAnswerAfterForWhatToAfterGoodBye:(NSString *)string {
    ConversationToken *userInput = [UWantsToSearchForAnotherRestaurant create:string];
    [self.conversation addToken:userInput];
}


@end