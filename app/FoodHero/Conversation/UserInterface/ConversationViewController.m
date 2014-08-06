//
//  ConversationViewController.m
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "ConversationViewController.h"
#import "ConversationBubbleTableViewCell.h"
#import "UCuisinePreference.h"
#import "USuggestionNegativeFeedback.h"
#import "AskUserCuisinePreferenceAction.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationBubbleFoodHero.h"
#import "DesignByContractException.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "ConversationViewState.h"
#import "ConversationViewStateNormal.h"
#import "ConversationViewStateTextInput.h"
#import "ConversationViewStateListInput.h"
#import "CuisineTableViewCell.h"
#import "ViewDimensionHelper.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController {
    ConversationAppService *_appService;
    Restaurant *_lastSuggestedRestaurant;
    ConversationViewState *_currentViewState;
}

- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
}

- (UIImageView *)createBackgroundImage {
    UIImage *backgroundImage = [UIImage imageNamed:@"Cuttlery-Background.png"];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile]; // otherwise picture is displayed compressed if to big

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    return backgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_bubbleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_userInputListView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // View
    _viewDimensionHelper = [ViewDimensionHelper create:self.view];

    // Bubble View
    _bubbleView.delegate = self;
    _bubbleView.dataSource = self;
    _bubbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *backgroundView = [self createBackgroundImage];
    [backgroundView setFrame:_bubbleView.frame];
    _bubbleView.backgroundView = backgroundView;

    [[_appService statementIndexes] subscribeNext:^(id next){
        NSUInteger index;
        NSNumber *wrappedIndex = next;
        [wrappedIndex getValue:&index];

        NSMutableArray *newIndexes = [NSMutableArray new];
        NSIndexPath *newIndex = [NSIndexPath indexPathForItem:index inSection:0];
        [newIndexes addObject:newIndex];

        [_bubbleView insertRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationFade];
    }];

    // Input View
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

    // UserInputList
    _userInputListView.delegate = self;
    _userInputListView.dataSource = self;

    [self changeViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];
}


- (void)changeViewState:(ConversationViewState *)viewState {
    if (![viewState isEqual:_currentViewState]) {
        _currentViewState = viewState;
        [viewState animateChange];
        [self disableUserInput];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)deviceOrientationDidChange:(id)deviceOrientationDidChange {
    _currentViewState = nil;
    [self changeViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];
}

- (void)viewWillLayoutSubviews {
    [_bubbleView reloadData];

    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ConversationBubble *)getStatement:(NSIndexPath *)indexPath {
    ConversationBubble *bubble = [_appService getStatement:(NSUInteger) indexPath.row bubbleWidth:_bubbleView.frame.size.width];
    return bubble;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if( tableView == _bubbleView) {
        return [self getStatement:indexPath].height;
    }
    else{
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _bubbleView) {
        return [_appService getStatementCount];
    }
    else{
        return [_appService getCuisineCount];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _bubbleView) {
        return [self getConversationBubbleTableViewCell:tableView indexPath:indexPath];
    }
    else{
        return [self getCuisineTableViewCell:tableView indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if( tableView == _userInputListView){
       CuisineTableViewCell *cell = (CuisineTableViewCell *) [_userInputListView cellForRowAtIndexPath:indexPath];
       cell.isSelected = !cell.isSelected;
   }
}


- (UITableViewCell *)getCuisineTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    CuisineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cuisine" forIndexPath:indexPath];
    cell.cuisine = [_appService getCuisine:indexPath.row];
    return cell;
}

- (UITableViewCell *)getConversationBubbleTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    ConversationBubble *bubble = [self getStatement:indexPath];

    BOOL isLastRow = indexPath.row == [_appService getStatementCount] - 1;
    if (isLastRow) {
            [self configureUserInputFor:bubble];
        }

    ConversationBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bubble.cellId forIndexPath:indexPath];
    cell.bubble = bubble;
    return cell;
}

- (void)disableUserInput {
    [self setEnabledForCuisinePreferenceSend];
    [self setEnabledForCuisinePreferenceList];
    [self.userPrefereseBritishFood setHidden:YES];
    [self.userDoesntLikeThatRestaurant setHidden:YES];
}

- (void)configureUserInputFor:(ConversationBubble *)bubble {
    [self disableUserInput];

    Restaurant *restaurant = [bubble suggestedRestaurant];
    if (restaurant != nil) {
        _lastSuggestedRestaurant = restaurant;
    }

    if ([bubble isKindOfClass:[ConversationBubbleFoodHero class]]) {
        ConversationBubbleFoodHero *foodHeroBubble = (ConversationBubbleFoodHero *) bubble;
        if (foodHeroBubble.inputAction.class == AskUserCuisinePreferenceAction.class) {
            [self.userPrefereseBritishFood setHidden:NO];
        }
        else if (foodHeroBubble.inputAction.class == AskUserSuggestionFeedbackAction.class) {
            [_userDoesntLikeThatRestaurant setHidden:NO];
        }
    }
}

- (IBAction)userCuisinePreferenceTextChanged:(id)sender {
    [self setEnabledForCuisinePreferenceSend];
}

- (void)setEnabledForCuisinePreferenceList {
    self.userCuisinePreferenceList.enabled = ![_currentViewState isKindOfClass:ConversationViewStateListInput.class];
}

- (void)setEnabledForCuisinePreferenceSend {
    NSString *text = self.userCuisinePreferenceText.text;
    self.userCuisinePreferenceSend.enabled = text.length > 0;
}

- (IBAction)userCuisinePreferenceSendTouchUp:(id)sender {
    [self changeViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];

    NSString *text = self.userCuisinePreferenceText.text;
    UCuisinePreference *userInput = [UCuisinePreference create:text];
    [_appService addUserInput:userInput];
}

- (void)hideKeyboard {
    [(self.userCuisinePreferenceText) resignFirstResponder];
}

- (IBAction)userChoosesIndianOrBritishFood:(id)sender {
    [self disableUserInput];
    UCuisinePreference *userInput = [UCuisinePreference create:@"British food"];
    [_appService addUserInput:userInput];
}

- (IBAction)userDoesntLikeThatRestaurant:(id)sender {
    [self disableUserInput];

    if (_lastSuggestedRestaurant == nil) {
        @throw [DesignByContractException createWithReason:@"no last suggested Restaurant found"];
    }


    USuggestionNegativeFeedback *userInput = [USuggestionFeedbackForNotLikingAtAll create:_lastSuggestedRestaurant];
    [_appService addUserInput:userInput];
}

- (IBAction)userCuisinePreferenceListTouchUp:(id)sender {
    [self changeViewState:[ConversationViewStateListInput create:self animationDuration:0.25 animationCurve:UIViewAnimationCurveEaseOut]];
}

- (void)keyboardWillShow:(id)notification {
    NSDictionary *userInfo = ((NSNotification *) notification).userInfo;
    CGRect keyboardFrameEnd = [[userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect keyboardFrameEndWithRotation = [self.view convertRect:keyboardFrameEnd fromView:nil];
    CGFloat keyboardHeight = keyboardFrameEndWithRotation.size.height;

    NSNumber *animationDuration = (NSNumber *) [userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    NSNumber *animationCurve = (NSNumber *) [userInfo valueForKey:@"UIKeyboardAnimationCurveUserInfoKey"];

    [self changeViewState:[ConversationViewStateTextInput create:self heigth:keyboardHeight animationCurve:(UIViewAnimationCurve) animationCurve.integerValue animationDuration:animationDuration.doubleValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self changeViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];
    [super prepareForSegue:segue sender:sender];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
