//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationAppService.h"
#import "ViewDimensionHelper.h"

@interface ConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UActionVisitor>

@property(weak, nonatomic) IBOutlet UITableView *bubbleView;
@property(weak, nonatomic) IBOutlet UITextField *userCuisinePreferenceText;
@property (weak, nonatomic) IBOutlet UIView *userInputContainerView;
@property(weak, nonatomic) IBOutlet UIButton *userCuisinePreferenceSend;
@property(weak, nonatomic) IBOutlet UIButton *userCuisinePreferenceList;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeaderHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewHeightConstraint;
@property(nonatomic, readonly) ViewDimensionHelper *viewDimensionHelper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeightConstraint;

- (void)userInputViewChanged:(NSString *)text;

- (IBAction)userCuisinePreferenceTextChanged:(id)sender;

- (IBAction)userCuisinePreferenceSendTouchUp:(id)sender;

- (void)hideKeyboard;

- (IBAction)userCuisinePreferenceListTouchUp:(id)sender;

- (void)setConversationAppService:(ConversationAppService *)service;


@end
