//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHBecauseUserDeniedAccessToLocationServices.h"

@implementation FHBecauseUserDeniedAccessToLocationServices {

}
+ (ConversationToken *)create {
    NSString *text = @"Ooops... I can't find out my current location.\n\nI need to know where I am.\n\nPlease turn Location Services on at Settings > Privacy > Location Services.";
    return [[FHBecauseUserDeniedAccessToLocationServices alloc] initWithSemanticId:@"FH:BecauseUserDeniedAccessToLocationServices" text:text];
}

@end