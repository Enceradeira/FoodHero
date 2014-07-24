//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmationIfInNewPreferredRangeCloser.h"


@implementation FHConfirmationIfInNewPreferredRangeCloser {

}
+ (ConversationToken *)create {
    NSString *text = @"It's closer than the other one.";
    return [[FHConfirmationIfInNewPreferredRangeCloser alloc] initWithParameter:@"FH:ConfirmationIfInNewPreferredRangeCloser" parameter:text];
}
@end