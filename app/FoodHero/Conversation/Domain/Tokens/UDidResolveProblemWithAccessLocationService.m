//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UDidResolveProblemWithAccessLocationService.h"
#import "SearchAction.h"


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

@end