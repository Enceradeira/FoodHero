//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWhatToDoNext.h"


@implementation FHWhatToDoNext {

}

- (instancetype)init {
    NSString *text = @"Now that you like that restaurant.\n\n Is there something else that I can do for you?";
    return self = [super initWithSemanticId:@"FH:WhatToDoNext" text:text];
}

@end