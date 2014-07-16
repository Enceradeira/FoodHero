//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationAction.h"
#import "Persona.h"
#import "DesignByContractException.h"


@implementation ConversationAction {

}

- (id)init:(Persona *)persona responseId:(NSString *)responseId text:(NSString *)text {
    self = [super init];
    if (self != nil) {
        _persona = persona;
        _responseId = responseId;
        _text = text;
    }
    return self;
}

- (ConversationAction *)concat:(ConversationAction *)action {
    if (_persona != action.persona) {
        @throw [DesignByContractException createWithReason:@"Attempt to concat two ConversationAction for different personas"];
    }
    NSString *responseId = [NSString stringWithFormat:@"%@&%@", _responseId, action.responseId];
    NSString *text = [NSString stringWithFormat:@"%@ %@", _text, action.text];
    return [[ConversationAction alloc] init:_persona responseId:responseId text:text];
}
@end