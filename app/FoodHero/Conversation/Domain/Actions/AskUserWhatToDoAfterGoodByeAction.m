//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AskUserWhatToDoAfterGoodByeAction.h"


@implementation AskUserWhatToDoAfterGoodByeAction {

}
- (NSString *)getStateName {
    return @"afterGoodByeAfterSuccess";
}

- (void)accept:(id <IUActionVisitor>)visitor {
    [visitor visitAskUserWhatToDoAfterGoodByeAction:self];
}

@end