//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreeting.h"


@implementation FHGreeting {

}
+ (FHGreeting *)create {
    return [[FHGreeting alloc] initWithParameter:@"FH:Greeting" parameter:@"Hi there."];
}
@end