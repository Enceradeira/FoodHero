//
//  ControllerFactory.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ControllerFactory.h"
#import "TyphoonComponents.h"

@implementation ControllerFactory
+ (ConversationViewController *)createConversationViewController {
    TyphoonStoryboard *storyboard = [TyphoonComponents storyboard];

    return [storyboard instantiateViewControllerWithIdentifier:@"ConversationViewController"];
}
@end
