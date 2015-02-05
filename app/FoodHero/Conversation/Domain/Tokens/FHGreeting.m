// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreeting.h"
#import "TextRepository.h"
#import "ConversationToken+Protected.h"
#import "NoAction.h"
#import "AddTokenAction.h"
#import "FHOpeningQuestion.h"

NSString *const SemanticId = @"FH:Greeting";

@implementation FHGreeting {

    NSString *_text;
}
+ (instancetype)create {
    NSString *text = [self.textRepository getGreeting];
    return [[FHGreeting alloc] initWithSemanticIdAndText:SemanticId text:text];
}

- (instancetype)initWithSemanticIdAndText:(NSString *const)semanticId text:(NSString *)text {
    self = [super initWithSemanticId:semanticId text:text];
    if (self != nil) {
        _text = text;
    }
    return self;
}

- (id <ConversationAction>)createAction {
    AddTokenAction *addOpeningQuestionAction = [AddTokenAction create:[FHOpeningQuestion create]];
    return addOpeningQuestionAction;
}

@end
