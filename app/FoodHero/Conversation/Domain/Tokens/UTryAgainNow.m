//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UTryAgainNow.h"
#import "SearchAction.h"


@implementation UTryAgainNow {
}
- (id)initWithText:(NSString *)text {
    return [super initWithSemanticId:@"U:TryAgainNow" text:text];
}

- (id <ConversationAction>)createAction {
    return [SearchAction new];
}

+ (instancetype)create:(NSString *)text {
    return [[UTryAgainNow alloc] initWithText:text];
}

+ (TalkerUtterance *)createUtterance:(NSString *)text {

    UserParameters *parameters = [[UserParameters alloc] initWithSemanticId:@"U:TryAgainNow" parameter:@""];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end
