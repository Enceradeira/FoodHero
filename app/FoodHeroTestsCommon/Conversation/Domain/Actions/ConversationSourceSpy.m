//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationSourceSpy.h"
#import "SearchProfil.h"


@implementation ConversationSourceSpy {

}

- (id)init {
    self = [super init];
    if (self) {
        _tokens = [NSMutableArray new];
    }

    return self;
}

- (void)addFHToken:(ConversationToken *)token {
    [_tokens addObject:token];
}

- (NSArray *)negativeUserFeedback {
    return nil;
}

- (SearchProfil *)currentSearchPreference {
    return nil;
}

- (ConversationToken *)lastSuggestionWarning {
    return nil;
}

@end