//
// Created by Jorg on 24/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UAction.h"


@implementation UAction {

}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToAction:other];
}

- (BOOL)isEqualToAction:(UAction *)action {
    if (self == action)
        return YES;
    if (action == nil)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [super hash];
}


@end