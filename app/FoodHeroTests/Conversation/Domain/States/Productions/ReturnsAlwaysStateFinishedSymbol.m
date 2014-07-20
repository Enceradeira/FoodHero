//
// Created by Jorg on 18/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ReturnsAlwaysStateFinishedSymbol.h"
#import "StateFinished.h"


@implementation ReturnsAlwaysStateFinishedSymbol {
}
- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [StateFinished new];
}

@end