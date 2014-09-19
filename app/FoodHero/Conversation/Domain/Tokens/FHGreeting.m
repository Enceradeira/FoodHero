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
#import "GenericToken.h"

NSString *const SemanticId = @"FH:Greeting";

@implementation FHGreeting {

    TextAndSound *_textAndSound;
}
+ (instancetype)create {
    TextAndSound *text = [self.textRepository getGreeting];
    return [[FHGreeting alloc] initWithSemanticIdAndText:SemanticId text:text];
}

- (instancetype)initWithSemanticIdAndText:(NSString *const)semanticId text:(TextAndSound *)textAndSound {
    self = [super initWithSemanticId:semanticId text:textAndSound.text];
    if (self != nil) {
        _textAndSound = textAndSound;
    }
    return self;
}

- (id <ConversationAction>)createAction {
    AddTokenAction *addOpeningQuestionAction = [AddTokenAction create:[FHOpeningQuestion create]];
    if (_textAndSound.sound != nil) {
        if( _textAndSound.textAfterSound == nil) {
            return [PlaySoundAndAfterAddTokenAction create:[FHOpeningQuestion create] sound:_textAndSound.sound];
        }
        else{
            ConversationToken *sayTextAfterSongAndThenOpeningQuestion = [GenericToken createWithSemanticId:SemanticId text:_textAndSound.textAfterSound action:addOpeningQuestionAction];
            return [PlaySoundAndAfterAddTokenAction create:sayTextAfterSongAndThenOpeningQuestion sound:_textAndSound.sound];
        }
    }
    return addOpeningQuestionAction;
}

@end
