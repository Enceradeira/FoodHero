//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationSourceSpy.h"
#import "SearchProfile.h"


@implementation ConversationSourceSpy {

}

- (id)init {
    self = [super init];
    if (self) {
        _tokens = [NSMutableArray new];
    }

    return self;
}

- (NSArray *)negativeUserFeedback {
    return nil;
}

- (SearchProfile *)currentSearchPreference {
    return nil;
}

- (ConversationParameters *)lastSuggestionWarning {
    return nil;
}

@end