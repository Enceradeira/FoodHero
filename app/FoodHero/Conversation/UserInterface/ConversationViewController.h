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

@property (weak, nonatomic) IBOutlet UIView *userInputView;
@property (weak, nonatomic) IBOutlet UITableView *bubbleView;
@property (weak, nonatomic) IBOutlet UIButton *userPrefereseBritishFood;
@property (weak, nonatomic) IBOutlet UIButton *userDoesntLikeThatRestaurant;

- (IBAction)userChoosesIndianOrBritishFood:(id)sender;
- (IBAction)userDoesntLikeThatRestaurant:(id)sender;

- (void)setConversationAppService:(ConversationAppService *)service;

@end
