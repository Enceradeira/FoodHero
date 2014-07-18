//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AtomicSymbol.h"
#import "DesignByContractException.h"


@implementation AtomicSymbol {
    Class _tokenclass;

    BOOL _hasBeenConsumed;
}

- (id)initWithToken:(Class)tokenclass {
    self = [super init];
    if (self) {
        _tokenclass = tokenclass;
    }
    return self;
}


- (id <ConversationAction>)consume:(ConversationToken *)token {
    if (!_hasBeenConsumed && _tokenclass == token.class) {
        _hasBeenConsumed = YES;
        return [self createAction:token];
    }
    return nil;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    @throw [DesignByContractException createWithReason:@"createAction must be overriden"];
}

@end