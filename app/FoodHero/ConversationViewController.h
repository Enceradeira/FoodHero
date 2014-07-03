//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationBubbleTableViewController.h"
#import "ConversationInputViewController.h"

@interface ConversationViewController : UIViewController
@property (weak) ConversationBubbleTableViewController* conversationBubbleController;
@property (weak) ConversationInputViewController* conversationInputController;
@end
