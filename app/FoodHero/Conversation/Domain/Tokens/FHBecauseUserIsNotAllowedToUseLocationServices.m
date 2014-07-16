//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHBecauseUserIsNotAllowedToUseLocationServices.h"


@implementation FHBecauseUserIsNotAllowedToUseLocationServices {

}
+ (ConversationToken *)create {
    NSString *text = @"I’m terribly sorry but there is a problem. I can’t access Location Services. I need access to Location Services in order that I know where I am.";
    return [[FHBecauseUserIsNotAllowedToUseLocationServices alloc] initWithParameter:@"FH:BecauseUserIsNotAllowedToUseLocationServices" parameter:text];
}
@end