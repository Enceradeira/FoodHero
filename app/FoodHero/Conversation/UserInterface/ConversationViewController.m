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
#import "ConversationBubbleFoodHero.h"
#import "DesignByContractException.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "ConversationViewState.h"
#import "ConversationViewStateNormal.h"
#import "ConversationViewStateTextInput.h"
#import "ConversationViewStateListOrTextInput.h"
#import "ViewDimensionHelper.h"
#import "CuisineTableViewController.h"
#import "TyphoonComponents.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController {
    ConversationAppService *_appService;
    Restaurant *_lastSuggestedRestaurant;
    ConversationViewState *_currentViewState;
    UIViewController <UserInputViewController> *_currentUserInputContainerViewController;
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

    // View
    _viewDimensionHelper = [ViewDimensionHelper create:self.view];

    // Bubble View
    _bubbleView.delegate = self;
    _bubbleView.dataSource = self;
    _bubbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *backgroundView = [self createBackgroundImage];
    [backgroundView setFrame:_bubbleView.frame];
    _bubbleView.backgroundView = backgroundView;

    [[_appService statementIndexes] subscribeNext:^(id next) {
        NSUInteger index;
        NSNumber *wrappedIndex = next;
        [wrappedIndex getValue:&index];

        NSMutableArray *newIndexes = [NSMutableArray new];
        NSIndexPath *newIndex = [NSIndexPath indexPathForItem:index inSection:0];
        [newIndexes addObject:newIndex];

        [_bubbleView insertRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationFade];

        [self configureUserInputFor:[self getStatementIndex:index]];
    }];

    // Input View
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

    [self setDefaultViewState];
}

- (void)setDefaultViewState {
    [self changeViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];
}

- (void)changeUserInputViewController:(NSString *)identifier {
    [self removeUserInputViewController];
    [self addUserInputViewController:identifier];

}

- (void)removeUserInputViewController {
    if (_currentUserInputContainerViewController == nil) {
        return;
    }

    [_currentUserInputContainerViewController willMoveToParentViewController:nil];
    [_currentUserInputContainerViewController.view removeFromSuperview];
    [_currentUserInputContainerViewController removeFromParentViewController];
    _currentUserInputContainerViewController = nil;
}

- (void)addUserInputViewController:(NSString *)identifier {
    _currentUserInputContainerViewController = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:identifier];
    _currentUserInputContainerViewController.delegate = self;
    UIView *controllerView = _currentUserInputContainerViewController.view;
    [controllerView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addChildViewController:_currentUserInputContainerViewController];

    [_userInputContainerView addSubview:controllerView];
    [_userInputContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userInputContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [_userInputContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userInputContainerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [_userInputContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userInputContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [_userInputContainerView addConstraint:[NSLayoutConstraint constraintWithItem:_userInputContainerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:controllerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

    [_currentUserInputContainerViewController didMoveToParentViewController:self];
}

- (void)changeViewState:(ConversationViewState *)viewState {
    if (![viewState isEqual:_currentViewState]) {
        _currentViewState = viewState;
        [viewState activate];
        [self disableUserInput];
    }
}

- (void)userInputViewChanged:(NSString *)text {
    _userCuisinePreferenceText.text = text;
    [self setEnabledForCuisinePreferenceSend];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)deviceOrientationDidChange:(id)deviceOrientationDidChange {
    _currentViewState = nil;
    [self setDefaultViewState];
}

- (void)viewWillLayoutSubviews {
    [_bubbleView reloadData];

    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ConversationBubble *)getStatementIndex:(NSInteger)index {
    ConversationBubble *bubble = [_appService getStatement:(NSUInteger) index bubbleWidth:_bubbleView.frame.size.width];
    return bubble;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getStatementIndex:indexPath.row].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_appService getStatementCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getConversationBubbleTableViewCell:tableView indexPath:indexPath];
}

- (UITableViewCell *)getConversationBubbleTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    ConversationBubble *bubble = [self getStatementIndex:indexPath.row];

    ConversationBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bubble.cellId forIndexPath:indexPath];
    cell.bubble = bubble;
    return cell;
}

- (void)disableUserInput {
    [self setEnabledForCuisinePreferenceSend];
    [self setEnabledForCuisinePreferenceList];
}

- (void)configureUserInputFor:(ConversationBubble *)bubble {
    [self disableUserInput];

    Restaurant *restaurant = [bubble suggestedRestaurant];
    if (restaurant != nil) {
        _lastSuggestedRestaurant = restaurant;
    }

    if ([bubble isKindOfClass:[ConversationBubbleFoodHero class]]) {
        ConversationBubbleFoodHero *foodHeroBubble = (ConversationBubbleFoodHero *) bubble;
        id <UAction> inputAction = foodHeroBubble.inputAction;
        [inputAction accept:self];
    }
}

- (void)askUserCuisinePreferenceAction {
    [self changeUserInputViewController:@"Cuisine"];
}

- (void)askUserSuggestionFeedback {
    [self changeUserInputViewController:@"Feedback"];
}

- (IBAction)userCuisinePreferenceTextChanged:(id)sender {
    [self setEnabledForCuisinePreferenceSend];
}

- (void)setEnabledForCuisinePreferenceList {
    self.userCuisinePreferenceList.enabled = ![_currentViewState isKindOfClass:ConversationViewStateListOrTextInput.class];
}

- (void)setEnabledForCuisinePreferenceSend {
    NSString *text = self.userCuisinePreferenceText.text;
    self.userCuisinePreferenceSend.enabled = text.length > 0;
}

- (IBAction)userCuisinePreferenceSendTouchUp:(id)sender {
    [self setDefaultViewState];

    NSString *text = self.userCuisinePreferenceText.text;
    UCuisinePreference *userInput = [UCuisinePreference create:text];
    [_appService addUserInput:userInput];
}

- (void)hideKeyboard {
    [(self.userCuisinePreferenceText) resignFirstResponder];
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
    [self changeViewState:[_currentUserInputContainerViewController getViewStateForList:self animationCurve:UIViewAnimationCurveEaseOut animationDuration:0.25]];
}

- (void)keyboardWillShow:(id)notification {
    NSDictionary *userInfo = ((NSNotification *) notification).userInfo;
    CGRect keyboardFrameEnd = [[userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect keyboardFrameEndWithRotation = [self.view convertRect:keyboardFrameEnd fromView:nil];
    CGFloat keyboardHeight = keyboardFrameEndWithRotation.size.height;

    NSNumber *animationDurationNumber = (NSNumber *) [userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    double animationDuration = animationDurationNumber.doubleValue;

    NSNumber *animationCurverNumber = (NSNumber *) [userInfo valueForKey:@"UIKeyboardAnimationCurveUserInfoKey"];
    UIViewAnimationCurve animationCurve = (UIViewAnimationCurve) animationCurverNumber.integerValue;

    [self changeViewState:[_currentUserInputContainerViewController getViewStateForTextInput:self height:keyboardHeight animationCurve:animationCurve animationDuration:animationDuration]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self changeViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];
    [super prepareForSegue:segue sender:sender];
}

@end
