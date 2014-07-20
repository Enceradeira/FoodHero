//
// Created by Jorg on 20/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TokenNotConsumed.h"


@implementation TokenNotConsumed {

}
- (BOOL)isStateFinished {
    return NO;
}

- (BOOL)isTokenConsumed {
    return NO;
}

- (BOOL)isTokenNotConsumed {
    return YES;
}

@end