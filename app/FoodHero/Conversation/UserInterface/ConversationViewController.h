//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Wit/WITMicButton.h>
#import "ConversationAppService.h"
#import "ConversationViewState.h"
#import "ISpeechRecognitionStateSource.h"
#import "FoodHero-Swift.h"

@interface ConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ISpeechRecognitionStateSource, IHelpViewControllerDelegate>

@property(weak, nonatomic) IBOutlet UITableView *bubbleView;
@property(weak, nonatomic) IBOutlet UITextField *userTextField;
@property(weak, nonatomic) IBOutlet UIView *userInputContainerView;
@property(weak, nonatomic) IBOutlet UIView *userInputHeaderView;
@property(weak, nonatomic) IBOutlet UIButton *userSendButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeaderHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeightConstraint;
@property(weak, nonatomic) IBOutlet UIView *micView;
@property(strong, nonatomic) WITMicButton *micButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

- (void)setViewState:(ConversationViewState *)viewState;

- (IBAction)userTextFieldChanged:(id)sender;

- (IBAction)userSendButtonTouchUp:(id)sender;

- (IBAction)sharedTouched:(id)sender;

- (NSString *)getTextForSharing;

- (void)hideKeyboard;

- (void)setConversationAppService:(ConversationAppService *)service;

- (AVAudioSessionRecordPermission)recordPermission;

- (void)setDefaultViewState:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration;

- (void)userDidTouchLinkInConversationBubbleWith:(UIViewController *)controller;

- (void)initalizeHelpController:(HelpViewController *)controller;

- (NSInteger)optimalUserInputListHeight;

- (BOOL)isNotProcessingUserInput;

- (BOOL)isNotRecordingUserInput;

- (BOOL)isWaitingForUserInput;
@end
