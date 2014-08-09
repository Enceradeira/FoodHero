//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AskUserCuisinePreferenceAction.h"


@implementation AskUserCuisinePreferenceAction {

}
+ (id <ConversationAction>)create {
    return [AskUserCuisinePreferenceAction new];
}

- (void)accept:(id <UActionVisitor>)visitor {
    [visitor askUserCuisinePreferenceAction];
}

@end