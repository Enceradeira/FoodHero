//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UWantsToAbort.h"
#import "SearchAction.h"
#import "AddTokenAction.h"
#import "FHWhatToDoNextCommentAfterFailure.h"


@implementation UWantsToAbort {
}
- (id)initWithText:(NSString *)text {
    return [super initWithSemanticId:@"U:WantsToAbort" text:text];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHWhatToDoNextCommentAfterFailure new]];
}

+ (instancetype)create:(NSString *)text {
    return [[UWantsToAbort alloc] initWithText:text];
}

+ (TalkerUtterance *)createUtterance:(NSString *)text {

    UserParameters *parameters = [[UserParameters alloc] initWithSemanticId:@"U:WantsToAbort" parameter:@""];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}
@end
