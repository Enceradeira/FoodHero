//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationToken.h"


@implementation ConversationToken {
}

- (id)init:(NSString *)semanticId parameter:(NSString *)parameter {
    self = [super self];
    if (self != nil) {
        _semanticId = semanticId;
        _parameter = parameter;
    }
    return self;
}


@end