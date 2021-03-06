//
//  ConversationBubbleTableViewCell.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationBubble.h"
#import "ConversationViewController.h"

@interface ConversationBubbleTableViewCell : UITableViewCell

@property(nonatomic) ConversationBubble *bubble;

@property(nonatomic) ConversationViewController* delegate;
@end
