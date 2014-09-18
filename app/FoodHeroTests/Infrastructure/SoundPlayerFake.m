//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SoundPlayerFake.h"


@implementation SoundPlayerFake {

    id <PlaySoundDelegate> _delegate;
}
- (id <PlaySoundDelegate>)delegate {
    return nil;
}

- (void)setDelegate:(id <PlaySoundDelegate>)delegate {
    _delegate = delegate;
}

- (void)play:(Sound *)sound delay:(NSTimeInterval)delay {
    [_delegate soundDidFinish];
}

@end