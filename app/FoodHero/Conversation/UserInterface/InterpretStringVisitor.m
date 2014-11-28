//
// Created by Jorg on 28/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "InterpretStringVisitor.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "UDidResolveProblemWithAccessLocationService.h"


@implementation InterpretStringVisitor {

    NSString *_string;
}

+ (instancetype)create:(id <ISpeechRecognitionService>)service locationService:(LocationService *)locationService conversation:(Conversation *)conversation string:(NSString *)string {
    return [[InterpretStringVisitor alloc] initWithRecognitionService:service locationService:locationService conversation:conversation string:string];
}

- (id)initWithRecognitionService:(id <ISpeechRecognitionService>)recognitionService locationService:(LocationService *)locationService conversation:(Conversation *)conversation string:(NSString *)string {
    self = [super initWithRegocnitionService:recognitionService locationService:locationService conversation:conversation];
    if (self) {
        _string = string;
    }
    return self;
}

- (RACSignal *)interpretStringForAction:(id <IUAction>)action {
    return [self.speechRecognitionService interpretString:_string state:[action getStateName]];
}

- (void)visitAskUserCuisinePreferenceAction:(id <IUAction>)action {
    [self subscribeInterpretationOfCuisinePreference:[self interpretStringForAction:action]];
}

- (void)visitAskUserIfProblemWithAccessLocationServiceResolved:(id <IUAction>)action {
    [self addUserSolvedProblemWithAccessLocationService:_string];
}

- (void)visitAskUserSuggestionFeedbackAction:(id <IUAction>)action {
    [self subscribeInterpretationOfSuggestionFeedback:[self interpretStringForAction:action]];
}

- (void)visitAskUserToTryAgainAction:(id <IUAction>)action {
    [self subscribeInterpretationOfAnswerAfterNoRestaurantWasFound:[self interpretStringForAction:action]];
}

- (void)visitAskUserWhatToDoAfterGoodByeAction:(id <IUAction>)action {
    [self addAnswerAfterForWhatToAfterGoodBye:_string];
}

- (void)visitAskUserWhatToDoNextAction:(id <IUAction>)action {
    [self subscribeInterpretationOfWhatToDoNext:[self interpretStringForAction:action]];
}
@end