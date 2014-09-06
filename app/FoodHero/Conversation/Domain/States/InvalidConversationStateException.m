//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "InvalidConversationStateException.h"


@implementation InvalidConversationStateException {

}
- (id)initWithReason:(NSString *)reason {
    self = [super initWithName:@"InvalidConversationStateException" reason:reason userInfo:nil];
    return self;
}

+ (instancetype)createWithReason:(NSString *)reason {
    return [[InvalidConversationStateException alloc] initWithReason:reason];
}
@end