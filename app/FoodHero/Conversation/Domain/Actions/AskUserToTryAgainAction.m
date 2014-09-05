//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AskUserToTryAgainAction.h"


@implementation AskUserToTryAgainAction {

}
- (void)accept:(id <UActionVisitor>)visitor {
    [visitor askUserToTryAgainAction];
}


@end