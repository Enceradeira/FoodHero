//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHNoRestaurantsFound.h"

@implementation FHNoRestaurantsFound {

}
+ (ConversationToken *)create {
    NSString *text = @"That’s weird. I can’t find any restaurants right now.";
    return [[FHNoRestaurantsFound alloc] initWithSemanticId:@"FH:NoRestaurantsFound" text:text];
}

@end