//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHConfirmation.h"


@implementation FHConfirmation {

}
+ (FHConfirmation *)create {
    return [[FHConfirmation alloc] initWithParameter:@"FH:Confirmation" parameter:@"What do you think?"];
}
@end