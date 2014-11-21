//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UGoodBye.h"
#import "FHGoodByeAfterSuccess.h"
#import "AddTokenAction.h"


@implementation UGoodBye {

}
- (id)initWithText:(NSString *)text {
    return [super initWithSemanticId:@"U:GoodBye" text:text];
}

- (id <ConversationAction>)createAction {
    return [AddTokenAction create:[FHGoodByeAfterSuccess new]];
}

+ (instancetype)create:(NSString *)text {
    return [[UGoodBye alloc] initWithText:text];
}
@end