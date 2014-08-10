//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationAppService.h"

@class ConversationViewState;

@interface ConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UActionVisitor>

@property(weak, nonatomic) IBOutlet UITableView *bubbleView;
@property(weak, nonatomic) IBOutlet UITextField *userTextField;
@property(weak, nonatomic) IBOutlet UIView *userInputContainerView;
@property (weak, nonatomic) IBOutlet UIView *userInputHeaderView;
@property(weak, nonatomic) IBOutlet UIButton *userSendButton;
@property(weak, nonatomic) IBOutlet UIButton *userInputListButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeaderHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeightConstraint;

- (void)setViewState:(ConversationViewState *)viewState;

- (IBAction)userTextFieldChanged:(id)sender;

- (IBAction)userSendButtonTouchUp:(id)sender;

- (void)hideKeyboard;

- (IBAction)userInputListButtonTouchUp:(id)sender;

- (void)setConversationAppService:(ConversationAppService *)service;

- (void)animateViewThatMovesToTextInput:(UIView *)view completion:(void (^)(BOOL finished))completion;

- (void)setDefaultViewState:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;

- (int)optimalUserInputListHeight;
@end
