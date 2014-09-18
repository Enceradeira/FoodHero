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
#import "TextAndSound.h"

NSString *const SemanticId = @"FH:Greeting";

@implementation FHGreeting {

    Sound *_sound;
}
+ (instancetype)create {
    TextAndSound *text = [self.textRepository getGreeting];
    return [[FHGreeting alloc] initWithSemanticIdAndText:SemanticId text:text];
}

- (instancetype)initWithSemanticIdAndText:(NSString *const)semanticId text:(TextAndSound *)textAndSound {
    self = [super initWithSemanticId:semanticId text:textAndSound.text];
    if (self != nil) {
        _sound = textAndSound.sound;
    }
    return self;
}

- (id <ConversationAction>)createAction {
    if (_sound != nil) {
        return [PlaySoundAndAfterAddTokenAction create:[FHOpeningQuestion create] sound:_sound];
    }
    return [AddTokenAction create:[FHOpeningQuestion create]];
}

@end
