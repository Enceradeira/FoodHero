//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWantsToSearchForAnotherRestaurantState.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "AddTokenAction.h"
#import "FHOpeningQuestion.h"


@implementation UWantsToSearchForAnotherRestaurantState {

}
- (instancetype)init {
    self = [super initWithToken:UWantsToSearchForAnotherRestaurant.class];
    return self;
}

- (id <ConversationAction>)createAction:(ConversationToken *)token {
    return [token createAction];
}
@end