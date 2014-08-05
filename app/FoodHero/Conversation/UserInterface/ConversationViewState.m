//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewState.h"
#import "ConversationViewController.h"
#import "DesignByContractException.h"
#import "ViewDimensions.h"

@implementation ConversationViewState

- (instancetype)initWithController:(ConversationViewController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;
    }
    return self;
}

- (void)animateChange {
    @throw [DesignByContractException createWithReason:@"base class must override this method"];
}

- (BOOL)isEqual:(id)other {
    return [[other class] isEqual:[self class]];
}

@end