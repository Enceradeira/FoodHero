//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ReturnsAlwaysTokenNotConsumedSymbol.h"


@implementation ReturnsAlwaysTokenNotConsumedSymbol {
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return nil;
}

- (id)init {
    return [super initWithToken:nil];
}

@end