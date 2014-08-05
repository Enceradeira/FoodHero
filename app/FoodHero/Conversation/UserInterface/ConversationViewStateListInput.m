//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewStateListInput.h"
#import "ConversationViewController.h"


@implementation ConversationViewStateListInput {

}

+ (instancetype)create:(ConversationViewController *)controller {
    return [[ConversationViewStateListInput alloc] initWithController:controller];
}
@end