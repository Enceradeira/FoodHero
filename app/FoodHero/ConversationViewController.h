//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationAppService.h"

@interface ConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(readonly) UITableView *conversationBubbleView;
@property(readonly) UIView *userInputView;

- (IBAction)userChoosesIndianOrBritishFood:(id)sender;

- (void)setConversationAppService:(ConversationAppService *)service;

@end
