//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmationIfInNewPreferredRangeMoreExpensive.h"


@implementation FHConfirmationIfInNewPreferredRangeMoreExpensive {

}
+ (ConversationToken *)create {
    NSString *text = @"It seems classier";
    return [[FHConfirmationIfInNewPreferredRangeMoreExpensive alloc] initWithSemanticId:@"FH:ConfirmationIfInNewPreferredRangeMoreExpensive" text:text];
}
@end