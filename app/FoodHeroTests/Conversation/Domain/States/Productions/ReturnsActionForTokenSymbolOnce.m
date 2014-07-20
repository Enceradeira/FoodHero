//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ReturnsActionForTokenSymbolOnce.h"
#import "TestAction.h"


@implementation ReturnsActionForTokenSymbolOnce {
}

- (id)initWithToken:(Class)tokenclass {
    return [super initWithToken:tokenclass];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [TestAction create:self];
}

+ (instancetype)create:(Class)token {
    return [[ReturnsActionForTokenSymbolOnce alloc] initWithToken:token];
}

@end