//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHOpeningQuestion.h"
#import "TextRepository.h"
#import "ConversationToken+Protected.h"
#import "AskUserCuisinePreferenceAction.h"


@implementation FHOpeningQuestion {
}

+ (FHOpeningQuestion *)create {
    NSString *text = [[self textRepository] getOpeningQuestion].text;
    return [[FHOpeningQuestion alloc] initWithSemanticId:@"FH:OpeningQuestion" text:text];
}

- (id <ConversationAction>)createAction {
    return [AskUserCuisinePreferenceAction new];
}


@end