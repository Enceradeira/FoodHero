//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWhatToDoNext.h"
#import "TextRepository.h"
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"
#import "ConversationToken+Protected.h"


@implementation FHWhatToDoNext {

}

- (instancetype)init {
    NSString *commentChoice = [(self.textRepository) getCommentChoice];
    NSString *whatToDoNextComment = [(self.textRepository) getWhatToDoNextComment];

    NSString *text = [NSString stringWithFormat:@"%@\n\n%@",commentChoice,whatToDoNextComment];
    return self = [super initWithSemanticId:@"FH:WhatToDoNext" text:text];
}

@end