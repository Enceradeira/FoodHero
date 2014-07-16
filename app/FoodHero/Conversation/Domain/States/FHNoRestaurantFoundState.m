//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHNoRestaurantFoundState.h"
#import "AskUserToTryAgainAction.h"


@implementation FHNoRestaurantFoundState {

}
- (id <ConversationAction>)createAction {
    return [AskUserToTryAgainAction new];
}

@end