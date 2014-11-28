//
// Created by Jorg on 28/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RecordAndInterpretUserVoiceVisitor.h"


@implementation RecordAndInterpretUserVoiceVisitor {
}
+ (instancetype)create:(id <ISpeechRecognitionService>)service locationService:(LocationService *)locationService conversation:(Conversation *)conversation {
    return [[RecordAndInterpretUserVoiceVisitor alloc] initWithRegocnitionService:service locationService:locationService conversation:conversation];
}

- (RACSignal *)recordAndInterpretUserVoice:(id <IUAction>)action {
    _signal = [self.speechRecognitionService recordAndInterpretUserVoice:[action getStateName]];
    return _signal;
}

- (void)visitAskUserCuisinePreferenceAction:(id <IUAction>)action; {
    [self subscribeInterpretationOfCuisinePreference:[self recordAndInterpretUserVoice:action]];
}

- (void)visitAskUserIfProblemWithAccessLocationServiceResolved:(id <IUAction>)action; {
    [self subscribeInterpretationOfAskUserIfProblemWithAccessLocationServiceResolved:[self recordAndInterpretUserVoice:action]];
}


- (void)visitAskUserSuggestionFeedbackAction:(id <IUAction>)action; {
    [self subscribeInterpretationOfSuggestionFeedback:[self recordAndInterpretUserVoice:action]];
}

- (void)visitAskUserToTryAgainAction:(id <IUAction>)action; {
    [self subscribeInterpretationOfAnswerAfterNoRestaurantWasFound:[self recordAndInterpretUserVoice:action]];
}

- (void)visitAskUserWhatToDoAfterGoodByeAction:(id <IUAction>)action; {
    [self subscribeInterpretationOfAskUserWhatToDoAfterGoodBye:[self recordAndInterpretUserVoice:action]];
}

- (void)visitAskUserWhatToDoNextAction:(id <IUAction>)action; {
    [self subscribeInterpretationOfWhatToDoNext:[self recordAndInterpretUserVoice:action]];
}

@end