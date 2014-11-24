//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationAppService.h"
#import "ConversationBubbleTableViewCellDelegate.h"
#import "ConversationViewState.h"

@interface ConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ConversationBubbleTableViewCellDelegate>

@property(weak, nonatomic) IBOutlet UITableView *bubbleView;
@property(weak, nonatomic) IBOutlet UITextField *userTextField;
@property(weak, nonatomic) IBOutlet UIView *userInputContainerView;
@property(weak, nonatomic) IBOutlet UIView *userInputHeaderView;
@property(weak, nonatomic) IBOutlet UIButton *userSendButton;
@property(weak, nonatomic) IBOutlet UIButton *userMicButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeaderHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeightConstraint;

- (void)setViewState:(ConversationViewState *)viewState;

- (IBAction)userTextFieldChanged:(id)sender;

- (IBAction)userSendButtonTouchUp:(id)sender;

- (void)hideKeyboard;

- (IBAction)userMicButtonTouchUp:(id)sender;

- (void)setConversationAppService:(ConversationAppService *)service;

- (AVAudioSessionRecordPermission)recordPermission;

- (void)setDefaultViewState:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;

- (NSInteger)optimalUserInputListHeight;

- (BOOL)isUserInputEnabled;
@end
