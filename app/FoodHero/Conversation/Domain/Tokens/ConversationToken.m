//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationToken.h"
#import "DesignByContractException.h"
#import "Personas.h"


@implementation ConversationToken {
}

- (instancetype)initWithSemanticId:(NSString *)semanticId text:(NSString *)text {
    Persona *persona;
    if ([semanticId rangeOfString:@"FH:"].location == NSNotFound) {
        persona = [Personas user];
    }
    else {
        persona = [Personas foodHero];
    }
    return [self initWithPersona:persona semantidId:semanticId text:text];
}

- (instancetype)initWithPersona:(Persona *)persona semantidId:(NSString *)semanticId text:(NSString *)text {
    self = [super self];
    if (self != nil) {
        _semanticId = semanticId;
        _text = text;
        _persona = persona;
    }
    return self;
}

- (ConversationToken *)concat:(ConversationToken *)token {
    if (_persona != token.persona) {
        @throw [DesignByContractException createWithReason:@"Attempt to concat two ConversationAction for different personas"];
    }
    NSString *semanticId = [NSString stringWithFormat:@"%@&%@", _semanticId, token.semanticId];
    NSString *text = [NSString stringWithFormat:@"%@ %@", _text, token.text];
    return [[ConversationToken alloc] initWithPersona:_persona semantidId:semanticId text:text];
}

@end