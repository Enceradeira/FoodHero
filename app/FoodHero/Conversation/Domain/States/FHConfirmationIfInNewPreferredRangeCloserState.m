//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmationIfInNewPreferredRangeCloserState.h"
#import "Alternation.h"
#import "FHConfirmationIfInNewPreferredRangeCheaper.h"
#import "FHConfirmationIfInNewPreferredRangeCloser.h"


@implementation FHConfirmationIfInNewPreferredRangeCloserState {
}


- (instancetype)init {
    return (FHConfirmationIfInNewPreferredRangeCloserState *) [super initWithToken:[FHConfirmationIfInNewPreferredRangeCloser class]];
}

+ (FHConfirmationIfInNewPreferredRangeCloserState *)create {
    return [[FHConfirmationIfInNewPreferredRangeCloserState alloc] init];
}


@end