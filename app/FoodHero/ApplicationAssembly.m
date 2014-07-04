//
//  JENAppAssembly.m
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "ApplicationAssembly.h"
#import "NavigationController.h"
#import "ConversationViewController.h"

@implementation ApplicationAssembly
- (id)navigationViewController
{
    return [TyphoonDefinition withClass:[NavigationController class]];
}

- (id) conversationViewController
{
    return [TyphoonDefinition
                withClass:[ConversationViewController class]
                configuration:^(TyphoonDefinition* definition) {
                }
            ];
}
                                                           
@end
