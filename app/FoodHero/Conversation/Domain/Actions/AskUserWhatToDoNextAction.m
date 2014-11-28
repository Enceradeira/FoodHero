//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AskUserWhatToDoNextAction.h"


@implementation AskUserWhatToDoNextAction {

}
- (NSString *)getStateName {
    return @"askForWhatToDoNext";
}

- (void)accept:(id <IUActionVisitor>)visitor {
    [visitor visitAskUserWhatToDoNextAction:self];
}

@end