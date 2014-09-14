//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "GenericToken.h"


@implementation GenericToken {

    id <ConversationAction> _action;
}
+ (instancetype)createWithSemanticId:(NSString *)semanticId text:(NSString *)text action:(id <ConversationAction>)action {
    return [[GenericToken alloc] initWithSemanticId:semanticId text:text action:action];
}

- (instancetype)initWithSemanticId:(NSString *)semanticId text:(NSString *)text action:(id <ConversationAction>)action {
    self = [super initWithSemanticId:semanticId text:text];
    if (self != nil) {
        _action = action;
    }
    return self;
}

- (id <ConversationAction>)createAction {
    return _action;
}

@end