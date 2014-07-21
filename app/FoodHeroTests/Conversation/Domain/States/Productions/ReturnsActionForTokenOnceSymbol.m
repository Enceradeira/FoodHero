//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ReturnsActionForTokenOnceSymbol.h"
#import "TestAction.h"


@implementation ReturnsActionForTokenOnceSymbol {
}

- (id)initWithToken:(Class)tokenclass {
    return [super initWithToken:tokenclass];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [TestAction create:self];
}

+ (instancetype)create:(Class)token {
    return [[ReturnsActionForTokenOnceSymbol alloc] initWithToken:token];
}

@end