//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHOpeningQuestion.h"


@implementation FHOpeningQuestion {
}

+ (FHOpeningQuestion *)create {
    return [[FHOpeningQuestion alloc] initWithParameter:@"FH:OpeningQuestion" parameter:@"What kind of food would you like to eat?"];
}

@end