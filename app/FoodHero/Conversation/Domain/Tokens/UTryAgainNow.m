//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UTryAgainNow.h"
#import "SearchAction.h"


@implementation UTryAgainNow {
}
- (id)init {
    return [super initWithSemanticId:@"U:TryAgainNow" text:@"Please, try again"];
}

- (id <ConversationAction>)createAction {
    return [SearchAction new];
}
@end
