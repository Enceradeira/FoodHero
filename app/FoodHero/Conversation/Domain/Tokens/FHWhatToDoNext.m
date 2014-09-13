//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWhatToDoNext.h"
#import "TextRepository.h"
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"


@implementation FHWhatToDoNext {

}

- (instancetype)init {
    TextRepository *textRepository = [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];
    NSString *commentChoice = [textRepository getCommentChoice];
    NSString *whatToDoNextComment = [textRepository getWhatToDoNextComment];

    NSString *text = [NSString stringWithFormat:@"%@\n\n%@",commentChoice,whatToDoNextComment];
    return self = [super initWithSemanticId:@"FH:WhatToDoNext" text:text];
}

@end