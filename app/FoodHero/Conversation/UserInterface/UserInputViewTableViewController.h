//
// Created by Jorg on 13/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationAppService.h"
#import "ConversationViewController.h"

@interface UserInputViewTableViewController : UITableViewController
@property(nonatomic) ConversationAppService *appService;

@property(nonatomic) ConversationViewController *parentController;

@property(nonatomic, readonly) UITableViewCell *selectedCell;

- (CGFloat)rowHeight;

- (int)optimalViewHeight;
@end