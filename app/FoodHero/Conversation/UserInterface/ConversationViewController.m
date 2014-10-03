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
#import "ConversationViewStateListOnlyInput.h"
#import "CheatTextFieldController.h"

const UIViewAnimationCurve DEFAULT_ANIMATION_CURVE = UIViewAnimationCurveEaseOut;
const UIViewAnimationOptions DEFAULT_ANIMATION_OPTION_CURVE = UIViewAnimationOptionCurveEaseOut;
const double DEFAULT_ANIMATION_DURATION = 0.25;
const double DEFAULT_ANIMATION_DELAY = 0.0;

@interface ConversationViewController ()

@end

@implementation ConversationViewController {
    ConversationAppService *_appService;
    ConversationViewState *_currentViewState;
    UIViewController <UserInputViewController> *_currentUserInputContainerViewController;
    CheatTextFieldController *_cheatTextFieldController;
    NSMutableArray *_bubbleCells;
    BOOL _isLoading;
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
    _isLoading = YES;

    [super viewDidLoad];
    _bubbleCells = [NSMutableArray new];

    // Bubble View
    _bubbleView.delegate = self;
    _bubbleView.dataSource = self;
    _bubbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *backgroundView = [self createBackgroundImage];
    [backgroundView setFrame:_bubbleView.frame];
    _bubbleView.backgroundView = backgroundView;

    // Detect gestures on Bubble View
    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] init];
    [gestureRecognizer setDelegate:self];
    [_bubbleView addGestureRecognizer:gestureRecognizer];


    [[_appService statementIndexes] subscribeNext:^(id next) {
        NSUInteger index;
        NSNumber *wrappedIndex = next;
        [wrappedIndex getValue:&index];

        NSMutableArray *newIndexes = [NSMutableArray new];
        NSIndexPath *newIndex = [NSIndexPath indexPathForItem:index inSection:0];
        [newIndexes addObject:newIndex];

        if (!_isLoading) {
            [_bubbleView insertRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationFade];
            [_bubbleView scrollToRowAtIndexPath:newIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }

        [self configureUserInputFor:[self getStatementIndex:index]];
    }];

    // Input View
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    _userInputHeaderView.layer.borderColor = [[FoodHeroColors darkerSepeartorGrey] CGColor];
    _userInputHeaderView.layer.borderWidth = 0.5;

    [self setDefaultViewState:UIViewAnimationCurveLinear animationDuration:0];
    _isLoading = NO;
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

    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:DEFAULT_ANIMATION_DELAY options:DEFAULT_ANIMATION_OPTION_CURVE animations:^{
        // move view to position of text input
        NSInteger paddingLeft = 10;
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
    [_currentViewState update];
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
        [_currentViewState activate];
    }
    else {
        [_currentViewState update];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationWillChange:(id)deviceOrientationDidChange {
    _currentViewState = nil;
    [self setDefaultViewState:UIViewAnimationCurveLinear animationDuration:0];
}

- (void)deviceOrientationDidChange:(id)deviceOrientationDidChange {
    [_bubbleCells removeAllObjects];
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
    /*
        [tableView dequeueReusableCellWithIdentifier] isn't used because it caused the bubbles to flicker
        when a cell was reconfigured with an other image. Images are anyway cached and managed by the AppService.

        Furthermore the reconfiguration of the dequeued celled was animated since it's called during an animation
        that changes the height of the UITableView. I couldn't get rid of that animation by other means.

    */

    if (indexPath.row < _bubbleCells.count) {
        return _bubbleCells[(NSUInteger) indexPath.row];
    }

    ConversationBubble *bubble = [self getStatementIndex:indexPath.row];
    ConversationBubbleTableViewCell *cell = (ConversationBubbleTableViewCell *) [[ConversationBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bubble.cellId];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bubble = bubble;
    cell.delegate = self;
    [_bubbleCells addObject:cell];
    return cell;
}

- (void)configureUserInputFor:(ConversationBubble *)bubble {
    _userTextField.text = nil;

    if ([bubble isKindOfClass:[ConversationBubbleFoodHero class]]) {
        ConversationBubbleFoodHero *foodHeroBubble = (ConversationBubbleFoodHero *) bubble;
        id <UAction> inputAction = foodHeroBubble.inputAction;
        [inputAction accept:self];
    }
    [_currentViewState activate];
}

- (void)askUserCuisinePreferenceAction {
    [self changeUserInputViewController:@"Cuisine"];
}

- (void)askUserSuggestionFeedback {
    [self changeUserInputViewController:@"Feedback"];
}

- (void)askUserWhatToDoNext {
    [self changeUserInputViewController:@"WhatToDoNext"];
}

- (void)askUserIfProblemWithAccessLocationServiceResolved {
    [self changeUserInputViewController:@"ProblemWithAccessLocationServiceResolved"];
}

- (void)askUserToTryAgainAction {
    [self changeUserInputViewController:@"TryAgain"];
}

- (void)askUserWhatToDoAfterGoodBye {
    [self changeUserInputViewController:@"SearchForAnotherRestaurant"];
}

- (IBAction)userTextFieldChanged:(id)sender {
    [_currentViewState update];
}

- (IBAction)userSendButtonTouchUp:(id)sender {
    [self setDefaultViewState:UIViewAnimationCurveLinear animationDuration:0];

    if ([_userTextField.text hasPrefix:@"C:E"] && _cheatTextFieldController == nil) {
        _cheatTextFieldController = [CheatTextFieldController createWithView:self.view applicationService:_appService];
    }
    else {
        UIViewController <UserInputViewController> *inputViewController = _currentUserInputContainerViewController;
        [self removeUserInputViewController];
        [inputViewController sendUserInput];
    }
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


- (void)userDidTouchLinkInConversationBubbleWith:(Restaurant *)restaurant {
    id controller = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantDetail"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)optimalUserInputListHeight {
    return _currentUserInputContainerViewController.optimalViewHeight;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self setDefaultViewState:DEFAULT_ANIMATION_CURVE animationDuration:DEFAULT_ANIMATION_DURATION];
    return NO;
}

- (BOOL)isUserInputEnabled {
    return _currentUserInputContainerViewController != nil;
}
@end
