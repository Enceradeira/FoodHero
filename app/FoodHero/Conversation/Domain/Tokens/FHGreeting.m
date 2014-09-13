// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreeting.h"
#import "TyphoonComponents.h"
#import "DefaultRandomizer.h"
#import "TextRepository.h"


@implementation FHGreeting {

}
+ (FHGreeting *)create {
    TextRepository *textRepository = [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];

    return [[FHGreeting alloc] initWithSemanticId:@"FH:Greeting" text:[textRepository getGreeting]];
}
@end
