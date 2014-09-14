// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreeting.h"
#import "TextRepository.h"
#import "ConversationToken+Protected.h"
#import "NoAction.h"


@implementation FHGreeting {

}
+ (FHGreeting *)create {
    NSString *text = [self.textRepository getGreeting];
    return [[FHGreeting alloc] initWithSemanticId:@"FH:Greeting" text:text];
}

- (id <ConversationAction>)createAction{
    return [NoAction new];
}

@end
