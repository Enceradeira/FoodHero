//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UActionVisitor <NSObject>
- (void)askUserCuisinePreferenceAction;

- (void)askUserSuggestionFeedback;

- (void)askUserWhatToDoNext;

- (void)askUserIfProblemWithAccessLocationServiceResolved;
@end