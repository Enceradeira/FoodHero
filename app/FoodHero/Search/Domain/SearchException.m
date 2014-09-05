//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchException.h"


@implementation SearchException {

}
- (id)initWithReason:(NSString *)reason {
    self = [super initWithName:@"SearchException" reason:reason userInfo:nil];
    return self;
}

+ (instancetype)createWithReason:(NSString *)reason {
    return [[SearchException alloc] initWithReason:reason];
}
@end

