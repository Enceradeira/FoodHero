//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWantsToSearchForAnotherRestaurant.h"
#import "FHOpeningQuestion.h"
#import "AddTokenAction.h"


@implementation UWantsToSearchForAnotherRestaurant {

}
- (id)init {
    return [super initWithSemanticId:@"U:WantsToSearchForAnotherRestaurant" text:@"Search for another restaurant, please"];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHOpeningQuestion create]];
}

@end