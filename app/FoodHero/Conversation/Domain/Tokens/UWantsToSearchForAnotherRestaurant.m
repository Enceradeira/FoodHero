//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWantsToSearchForAnotherRestaurant.h"
#import "FHOpeningQuestion.h"
#import "AddTokenAction.h"


@implementation UWantsToSearchForAnotherRestaurant {

}
- (id)initWithText:(NSString *)text {
    return [super initWithSemanticId:@"U:WantsToSearchForAnotherRestaurant" text:text];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHOpeningQuestion create]];
}

+ (instancetype)create:(NSString *)text {
    return [[UWantsToSearchForAnotherRestaurant alloc] initWithText:text];
}

@end