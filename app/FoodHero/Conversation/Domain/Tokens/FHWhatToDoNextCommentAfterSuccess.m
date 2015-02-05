//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWhatToDoNextCommentAfterSuccess.h"
#import "TextRepository.h"
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"
#import "ConversationToken+Protected.h"
#import "AskUserWhatToDoNextAction.h"


@implementation FHWhatToDoNextCommentAfterSuccess {

}

- (instancetype)init {
    NSString *commentChoice = [(self.textRepository) getCommentChoice];
    NSString *whatToDoNextComment = [(self.textRepository) getWhatToDoNextComment];

    NSString *text = [NSString stringWithFormat:@"%@\n\n%@",commentChoice,whatToDoNextComment];
    return self = [super initWithSemanticId:@"FH:WhatToDoNextCommentAfterSuccess" text:text];
}

- (id <ConversationAction>)createAction{
    return [AskUserWhatToDoNextAction new];
}


@end