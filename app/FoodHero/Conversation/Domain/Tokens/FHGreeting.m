// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreeting.h"
#import "TextRepository.h"
#import "ConversationToken+Protected.h"
#import "NoAction.h"
#import "AddTokenAction.h"
#import "FHOpeningQuestion.h"
#import "PlayMusicAndAddTokenAction.h"
#import "GenericToken.h"

NSString *const SemanticId = @"FH:Greeting";

@implementation FHGreeting {

}
+ (FHGreeting *)create {
    NSString *text = [self.textRepository getGreeting];
    return [[FHGreeting alloc] initWithSemanticId:SemanticId text:text];
}

- (id <ConversationAction>)createAction {
    if([self.text isEqualToString:@"I’m tired.  I need coffee before I can continue."]) {
        id <ConversationAction> action = [AddTokenAction create:[FHOpeningQuestion create]];
        ConversationToken *token = [GenericToken createWithSemanticId:SemanticId text:@"Now I'm ready. What's up?" action:action];
        return [PlayMusicAndAddTokenAction create:token];
    }
    return [AddTokenAction create:[FHOpeningQuestion create]];
}

@end
