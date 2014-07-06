//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)userChoosesIndianOrBritishFood:(id)sender;
@property (readonly) UITableView *conversationBubbleView;
@property (readonly) UIView *userInputView;
@end
