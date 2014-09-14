//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UGoodBye.h"
#import "FHGoodByeAfterSuccess.h"
#import "AddTokenAction.h"


@implementation UGoodBye {

}
- (id)init {
    return [super initWithSemanticId:@"U:GoodBye" text:@"No thanks! Good bye."];
}

- (id <ConversationAction>)createAction{
    return [AddTokenAction create:[FHGoodByeAfterSuccess new]];
}
@end