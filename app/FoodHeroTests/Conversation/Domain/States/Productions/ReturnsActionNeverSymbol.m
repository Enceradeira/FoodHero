//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ReturnsActionNeverSymbol.h"


@implementation ReturnsActionNeverSymbol {
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return nil;
}

- (id)init {
    return [super initWithToken:nil];
}

@end