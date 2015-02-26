//
// Created by Jorg on 01/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import "ExpectedStatement.h"

@implementation ExpectedStatement
- (instancetype)initWithText:(NSString *)semanticId inputAction:(Class)inputAction {
    self = [super init];
    if (self != nil) {
        _semanticId = semanticId;
        _state = inputAction;
    }
    return self;
}

@end

