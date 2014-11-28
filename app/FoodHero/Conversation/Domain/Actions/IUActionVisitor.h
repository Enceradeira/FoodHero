//
// Created by Jorg on 28/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IUAction;

@protocol IUActionVisitor <NSObject>
- (void)visitAskUserCuisinePreferenceAction:(id <IUAction>)action;

- (void)visitAskUserIfProblemWithAccessLocationServiceResolved:(id <IUAction>)action;;

- (void)visitAskUserSuggestionFeedbackAction:(id <IUAction>)action;;

- (void)visitAskUserToTryAgainAction:(id <IUAction>)action;;

- (void)visitAskUserWhatToDoAfterGoodByeAction:(id <IUAction>)action;

- (void)visitAskUserWhatToDoNextAction:(id <IUAction>)action;;
@end