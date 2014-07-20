//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHCantAccessLocationServiceState.h"
#import "FHBecauseUserDeniedAccessToLocationServicesState.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServicesState.h"
#import "Alternation.h"
#import "RepeatOnce.h"


@implementation FHCantAccessLocationServiceState {
    Alternation *_alternation;
}

- (id)init {
    self = [super init];
    if (self) {
        _alternation = [Alternation create:
                [RepeatOnce create:[FHBecauseUserDeniedAccessToLocationServicesState new]],
                [RepeatOnce create:[FHBecauseUserIsNotAllowedToUseLocationServicesState new]], nil];
    }

    return self;
}


- (id <ConsumeResult>)consume:(ConversationToken *)token {
    return [_alternation consume:token];
}
@end