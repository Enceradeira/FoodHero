//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UDidResolveProblemWithAccessLocationService.h"
#import "SearchAction.h"


@implementation UDidResolveProblemWithAccessLocationService {
}

- (id)init {
    NSString *text = @"I fixed the problem. Please try again!";
    return [super initWithSemanticId:@"U:DidResolveProblemWithAccessLocationService" text:text];
}

- (id <ConversationAction>)createAction {
    return [SearchAction new];
}

@end