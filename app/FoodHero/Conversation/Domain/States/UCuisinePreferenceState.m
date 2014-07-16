//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreferenceState.h"
#import "SearchAction.h"


@implementation UCuisinePreferenceState {
}
- (ConversationAction *)createAction {
    return [SearchAction create];
}


@end