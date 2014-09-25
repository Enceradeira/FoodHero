//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWhatToDoNextAfterFailure.h"
#import "TextRepository.h"
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"
#import "ConversationToken+Protected.h"
#import "AskUserWhatToDoNextAction.h"


@implementation FHWhatToDoNextAfterFailure {

}

- (instancetype)init {
    return self = [super initWithSemanticId:@"FH:WhatToDoNextAfterFailure" text:@"I’m sorry it didn’t work out!\n\nIs there anything else?"];
}

- (id <ConversationAction>)createAction{
    return [AskUserWhatToDoNextAction new];
}


@end