//
//  ConversationViewController.h
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationAppService.h"

@interface ConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,  UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *userInputView;
@property (weak, nonatomic) IBOutlet UITableView *bubbleView;
@property (weak, nonatomic) IBOutlet UIButton *userPrefereseBritishFood;
@property (weak, nonatomic) IBOutlet UIButton *userDoesntLikeThatRestaurant;
@property (weak, nonatomic) IBOutlet UITextField *userCuisinePreferenceText;
@property (weak, nonatomic) IBOutlet UIButton *userCuisinePreferenceSend;
@property (weak, nonatomic) IBOutlet UICollectionView *userInputListView;
@property (weak, nonatomic) IBOutlet UIButton *userCuisinePreferenceList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInputListHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInputHeaderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleViewHeightConstraint;

- (IBAction)userCuisinePreferenceTextChanged:(id)sender;
- (IBAction)userCuisinePreferenceSendTouchUp:(id)sender;

- (void)hideKeyboard;

- (IBAction)userChoosesIndianOrBritishFood:(id)sender;
- (IBAction)userDoesntLikeThatRestaurant:(id)sender;
- (IBAction)userCuisinePreferenceListTouchUp:(id)sender;

- (void)setConversationAppService:(ConversationAppService *)service;


@end
