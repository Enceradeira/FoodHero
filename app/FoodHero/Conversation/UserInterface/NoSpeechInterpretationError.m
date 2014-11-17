//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "NoSpeechInterpretationError.h"


@implementation NoSpeechInterpretationError {

    NSError *_innerError;
}
+ (NSError *)create:(NSError *)error {
    return [[NoSpeechInterpretationError alloc] init:error];
}

- (id)init:(NSError *)error {
    self = [super init];
    if (self) {
        _innerError = error;
    }
    return self;
}
@end