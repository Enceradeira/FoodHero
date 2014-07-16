//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreetingAction.h"
#import "Personas.h"


@implementation FHGreetingAction {

}
+ (FHGreetingAction *)create {
    return [[FHGreetingAction alloc] init:[Personas foodHero] responseId:@"FH:Greeting" text:@"Hi there."];
}
@end