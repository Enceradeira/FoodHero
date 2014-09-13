//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHOpeningQuestion.h"
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"
#import "TextRepository.h"


@implementation FHOpeningQuestion {
}

+ (FHOpeningQuestion *)create {
    TextRepository *textRepository = [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];
    NSString *text = [textRepository getOpeningQuestion];
    return [[FHOpeningQuestion alloc] initWithSemanticId:@"FH:OpeningQuestion" text:text];
}

@end