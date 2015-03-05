//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UDidResolveProblemWithAccessLocationService.h"
#import "SearchAction.h"
#import "FoodHero-Swift.h"


@implementation UDidResolveProblemWithAccessLocationService {
}

- (id)initWithText:(NSString *)text {
    return [super initWithSemanticId:@"U:DidResolveProblemWithAccessLocationService" text:text];
}

- (id <ConversationAction>)createAction {
    return [SearchAction new];
}

+ (instancetype)create:(NSString *)text {
    return [[UDidResolveProblemWithAccessLocationService alloc] initWithText:text];
}

+ (TalkerUtterance *)createUtterance:(NSString *)text {

    UserParameters *parameters = [[UserParameters alloc] initWithSemanticId:@"U:DidResolveProblemWithAccessLocationService" parameter:@""];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end