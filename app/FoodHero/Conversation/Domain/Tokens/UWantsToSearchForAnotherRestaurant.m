//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWantsToSearchForAnotherRestaurant.h"
#import "FHOpeningQuestion.h"

@implementation UWantsToSearchForAnotherRestaurant {

}
- (id)initWithText:(NSString *)text {
    return [super initWithSemanticId:@"U:WantsToSearchForAnotherRestaurant" text:text];
}

+ (instancetype)create:(NSString *)text {
    return [[UWantsToSearchForAnotherRestaurant alloc] initWithText:text];
}

+ (TalkerUtterance *)createUtterance:(NSString *)text {

    UserParameters *parameters = [[UserParameters alloc] initWithSemanticId:@"U:WantsToSearchForAnotherRestaurant" parameter:@""];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end