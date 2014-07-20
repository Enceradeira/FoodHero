//
// Created by Jorg on 20/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "StateFinished.h"


@implementation StateFinished {

}
- (BOOL)isStateFinished {
    return YES;
}

- (BOOL)isTokenConsumed {
    return NO;
}

- (BOOL)isTokenNotConsumed {
    return NO;
}

@end