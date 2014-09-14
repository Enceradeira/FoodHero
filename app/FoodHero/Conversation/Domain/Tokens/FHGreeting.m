// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreeting.h"
#import "TextRepository.h"
#import "ConversationToken+Protected.h"
#import "NoAction.h"
#import "AddTokenAction.h"
#import "FHOpeningQuestion.h"
#import "PlaySoundAndAfterAddTokenAction.h"
#import "GenericToken.h"
#import "ISoundRepository.h"

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
        ConversationToken *token = [GenericToken createWithSemanticId:SemanticId text:@"Now I feel better!" action:action];
        Sound *sound = [self.soundRepository getNespressoSound];
        return [PlaySoundAndAfterAddTokenAction create:token sound:sound];
    }
    return [AddTokenAction create:[FHOpeningQuestion create]];
}

@end
