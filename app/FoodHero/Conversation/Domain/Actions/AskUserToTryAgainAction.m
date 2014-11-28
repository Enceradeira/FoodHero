//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AskUserToTryAgainAction.h"


@implementation AskUserToTryAgainAction {

}
- (NSString *)getStateName {
    return @"noRestaurantWasFound";
}

- (void)accept:(id <IUActionVisitor>)visitor {
    [visitor visitAskUserToTryAgainAction:self];
}


@end