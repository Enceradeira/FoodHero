//
// Created by Jorg on 24/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AudioSessionStub.h"


@implementation AudioSessionStub {

    AVAudioSessionRecordPermission _permission;
}
- (void)requestRecordPermission:(void (^)(BOOL granted))response {
    response(_permission != AVAudioSessionRecordPermissionDenied);
}

- (AVAudioSessionRecordPermission)recordPermission {
    return _permission;
}

- (void)playJblBeginSound {

}

- (void)playJblCancelSound {

}


- (void)injectRecordPermission:(AVAudioSessionRecordPermission)permission {
    _permission = permission;
}
@end