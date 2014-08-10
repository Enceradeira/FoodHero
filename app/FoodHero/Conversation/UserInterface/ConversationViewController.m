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
#import "ConversationBubbleFoodHero.h"
#import "ConversationViewState.h"
#import "ConversationViewStateNormal.h"
#import "ConversationViewStateListOrTextInput.h"
#import "CuisineTableViewController.h"
#import "TyphoonComponents.h"
#import "FoodHeroColors.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController {
    ConversationAppService *_appService;
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
        [_bubbleView scrollToRowAtIndexPath:newIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];

        [self configureUserInputFor:[self getStatementIndex:index]];
    }];

    // Input View
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    _userInputHeaderView.layer.borderColor = [[FoodHeroColors darkerSepeartorGrey] CGColor];
    _userInputHeaderView.layer.borderWidth = 0.5;

    [self setDefaultViewState:UIViewAnimationCurveLinear animationDuration:0];
}

- (void)animateViewThatMovesToTextInput:(UIView *)view completion:(void (^)(BOOL finished))completion {
    UIView *originalSuperview = view.superview;

    // position of text input
    CGRect textinputFrame = _userTextField.frame;
    CGRect convertedTextinputFrame = [_userTextField.superview convertRect:textinputFrame toView:[self view]];

    // position of view
    CGRect viewFrame = view.frame;
    CGRect convertedViewFrame = [view convertRect:viewFrame toView:[self view]];

    // temporally move view into top-view
    [view removeFromSuperview];
    view.frame = CGRectMake(convertedViewFrame.origin.x, convertedViewFrame.origin.y, convertedViewFrame.size.width, convertedViewFrame.size.height);
    [[self view] addSubview:view];
    [[self view] bringSubviewToFront:view];

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // move view to position of text input
        int paddingLeft = 10;
        view.frame = CGRectMake(convertedTextinputFrame.origin.x + paddingLeft, convertedTextinputFrame.origin.y, convertedTextinputFrame.size.width - paddingLeft, convertedTextinputFrame.size.height);
    }                completion:^(BOOL completed) {

        // move view back to original super-view
        [view removeFromSuperview];
        view.frame = viewFrame;
        [originalSuperview addSubview:view];
        completion(completed);
    }];
}

- (void)setDefaultViewState:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    [self setViewState:[ConversationViewStateNormal create:self animationCurve:animationCurve aimationDuration:animationDuration]];
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
    _currentUserInputContainerViewController.parentController = self;
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

- (void)setViewState:(ConversationViewState *)viewState {
    if (![viewState isEqual:_currentViewState]) {
        _currentViewState = viewState;
        [viewState activate];
        [self disableUserInput];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(id)deviceOrientationDidChange {
    _currentViewState = nil;
    [self setDefaultViewState:UIViewAnimationCurveLinear animationDuration:0];
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

- (void)askUserWhatToDoNext {

}


- (IBAction)userTextFieldChanged:(id)sender {
    [self setEnabledForCuisinePreferenceSend];
}

- (void)setEnabledForCuisinePreferenceList {
    self.userInputListButton.enabled = ![_currentViewState isKindOfClass:ConversationViewStateListOrTextInput.class];
}

- (void)setEnabledForCuisinePreferenceSend {
    NSString *text = self.userTextField.text;
    self.userSendButton.enabled = text.length > 0;
}

- (IBAction)userSendButtonTouchUp:(id)sender {
    [self setDefaultViewState:UIViewAnimationCurveLinear animationDuration:0];

    [_currentUserInputContainerViewController sendUserInput];
    _userTextField.text = @"";
}

- (void)hideKeyboard {
    [(self.userTextField) resignFirstResponder];
}

- (IBAction)userInputListButtonTouchUp:(id)sender {
    [_currentUserInputContainerViewController notifyUserWantsListInput:UIViewAnimationCurveEaseOut animationDuration:0.25];
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

    [_currentUserInputContainerViewController notifyUserWantsTextInput:keyboardHeight animationCurve:animationCurve animationDuration:animationDuration];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self setViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];
    [super prepareForSegue:segue sender:sender];
}

- (int)optimalUserInputListHeight {
    return _currentUserInputContainerViewController.optimalViewHeight;
}
@end
