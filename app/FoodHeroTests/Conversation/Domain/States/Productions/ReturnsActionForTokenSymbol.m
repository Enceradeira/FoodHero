//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ReturnsActionForTokenSymbol.h"
#import "TestAction.h"


@implementation ReturnsActionForTokenSymbol {
}

- (id)initWithToken:(Class)tokenclass {
    return [super initWithToken:tokenclass];
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [TestAction create:self];
}

+ (instancetype)create:(Class)token {
    return [[ReturnsActionForTokenSymbol alloc] initWithToken:token];
}

@end