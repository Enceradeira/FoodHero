//
// Created by Jorg on 28/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationService.h"
#import "Conversation.h"
#import "ISpeechRecognitionService.h"


@interface SpeechRecognitionVisitor : NSObject
@property(nonatomic, readonly) LocationService *locationService;
@property(nonatomic, readonly) id <ISpeechRecognitionService> speechRecognitionService;
@property(nonatomic, readonly) Conversation *conversation;

- (instancetype)initWithRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService locationService:(LocationService *)locationService conversation:(Conversation *)conversation;

- (Restaurant *)getLastSuggestedRestaurant;

- (void)subscribeInterpretationOfCuisinePreference:(RACSignal *)signal;

- (void)subscribeInterpretationOfSuggestionFeedback:(RACSignal *)signal;

- (void)subscribeInterpretationOfWhatToDoNext:(RACSignal *)signal;

- (void)subscribeInterpretationOfAnswerAfterNoRestaurantWasFound:(RACSignal *)signal;

- (void)subscribeInterpretationOfAskUserIfProblemWithAccessLocationServiceResolved:(RACSignal *)signal;

- (void)subscribeInterpretationOfAskUserWhatToDoAfterGoodBye:(RACSignal *)signal;

- (void)addUserSolvedProblemWithAccessLocationService:(NSString *)string;

- (void)addAnswerAfterForWhatToAfterGoodBye:(NSString *)string;
@end