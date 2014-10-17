//
//  ControllerFactory.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Typhoon.h>
#import "ConversationViewController.h"

@class RestaurantDetailTableViewController;

@interface ControllerFactory : NSObject
+ (ConversationViewController *)createConversationViewController;

+ (RestaurantDetailTableViewController *)createRestaurantDetailTableViewController;
@end
