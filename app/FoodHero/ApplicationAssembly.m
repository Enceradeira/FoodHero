//
//  JENAppAssembly.m
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "ApplicationAssembly.h"
#import "NavigationController.h"
#import "ConversationBubbleTableViewController.h"
#import "ConversationViewController.h"
#import "ConversationInputViewController.h"

@implementation ApplicationAssembly
- (id)navigationViewController
{
    return [TyphoonDefinition withClass:[NavigationController class]];
}

- (id) conversationBubbleViewController
{
    return [TyphoonDefinition withClass:[ConversationBubbleTableViewController class]];
}

- (id) conversationInputViewController
{
    return [TyphoonDefinition withClass:[ConversationInputViewController class]];
}

- (id) conversationViewController
{
    return [TyphoonDefinition
                withClass:[ConversationViewController class]
                configuration:^(TyphoonDefinition* definition) {
                    [definition injectProperty:@selector(conversationBubbleController) with:[self conversationBubbleViewController]];
                    [definition injectProperty:@selector(conversationInputController) with:[self conversationInputViewController]];
                }
            ];
}
                                                           
@end
