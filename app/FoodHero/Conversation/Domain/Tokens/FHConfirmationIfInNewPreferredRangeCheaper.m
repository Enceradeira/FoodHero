//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmationIfInNewPreferredRangeCheaper.h"


@implementation FHConfirmationIfInNewPreferredRangeCheaper {

}
+ (ConversationToken *)create {
    NSString *text = @"It seems a bit cheaper.";
    return [[FHConfirmationIfInNewPreferredRangeCheaper alloc] initWithSemanticId:@"FH:ConfirmationIfInNewPreferredRangeCheaper" text:text];
}
@end