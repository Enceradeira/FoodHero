//
//  ControllerFactory.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TyphoonBuilder.h"
#import "ControllerFactory.h"

@implementation ControllerFactory
+ (ConversationViewController *)createConversationViewController:(TyphoonAssembly *)assembly {
    TyphoonStoryboard *storyboard = [TyphoonBuilder createStoryboardFromAssembly:assembly];

    return [storyboard instantiateViewControllerWithIdentifier:@"ConversationViewController"];
}
@end
