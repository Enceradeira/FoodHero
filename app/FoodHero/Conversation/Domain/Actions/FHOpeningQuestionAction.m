//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHOpeningQuestionAction.h"
#import "Personas.h"


@implementation FHOpeningQuestionAction {

}
+ (FHOpeningQuestionAction *)create {
    return [[FHOpeningQuestionAction alloc] init:[Personas foodHero] responseId:@"FH:OpeningQuestion" text:@"What kind of food would you like to eat?"];
}
@end