//
//  ConversationViewController.m
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Wit/WITMicButton.h>
#import "ConversationViewController.h"
#import "ConversationBubbleTableViewCell.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationViewStateNormal.h"
#import "CheatTextFieldController.h"
#import "FoodHeroColors.h"
#import "ConversationViewStateTextInput.h"

const UIViewAnimationCurve DEFAULT_ANIMATION_CURVE = UIViewAnimationCurveEaseOut;
const UIViewAnimationOptions DEFAULT_ANIMATION_OPTION_CURVE = UIViewAnimationOptionCurveEaseOut;
const double DEFAULT_ANIMATION_DURATION = 0.25;
const double DEFAULT_ANIMATION_DELAY = 0.0;

@interface ConversationViewController ()

@end

@implementation ConversationViewController {
    ConversationAppService *_appService;
    ConversationViewState *_currentViewState;
    CheatTextFieldController *_cheatTextFieldController;
    NSMutableArray *_bubbleCells;
    BOOL _isLoading;
    BOOL _isProcessingUserInput;
    BOOL _isRecordingUserInput;
    ConversationBubbleFoodHero *_currentFhBubble;
}

- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
    _appService.stateSource = self;
}

- (UIImageView *)createBackgroundImage {
    UIImage *backgroundImage = [UIImage imageNamed:@"Cuttlery-Background.png"];
    //backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile]; // otherwise picture is displayed compressed if to big

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    [backgroundView setContentMode:UIViewContentModeBottomLeft];
    return backgroundView;
}

- (void)viewDidAppear:(BOOL)animated {
    [self logScreenViewed];
}

- (void)logScreenViewed {
    [GAIService logScreenViewed:@"Conversation"];
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

    // Mic View
    _micButton = [[WITMicButton alloc] initWithFrame:_micView.frame];
    _micButton.accessibilityLabel = @"microphone";
    [_micButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_micView addSubview:self.micButton];

    NSDictionary *views = NSDictionaryOfVariableBindings(_micButton);
    [_micView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0.0-[_micButton]-0.0-|" options:0 metrics:@{} views:views]];
    [_micView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.0-[_micButton]-0.0-|" options:0 metrics:@{} views:views]];

    [self setDefaultViewState:UIViewAnimationCurveLinear animationDuration:0];
    _isLoading = NO;
}

- (AVAudioSessionRecordPermission)recordPermission {
    return [_appService recordPermission];
}

- (void)setDefaultViewState:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    [self setViewState:[ConversationViewStateNormal create:self animationCurve:animationCurve aimationDuration:animationDuration]];
}

- (void)setViewState:(ConversationViewState *)viewState {
    if (![viewState isEqual:_currentViewState]) {
        _currentViewState = viewState;
        [self redrawCurrentViewState];
    }
    else {
        [_currentViewState update];
    }
}

- (void)redrawCurrentViewState {
    [_currentViewState activate];
}

- (ExpectedUserUtterances *)expectedUserUtterances {
    return _currentFhBubble.expectedUserUtterances;
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
    ConversationBubbleTableViewCell *cell = [[ConversationBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bubble.cellId];
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

        if (foodHeroBubble.state) {
            NSLog(@"state changed: %@", foodHeroBubble.state);
            // sometimes FH produces more than one bubble in sequence but just one holds and state which should not be overwritten
            // this is the case e.g
            _currentFhBubble = foodHeroBubble;
        }
    }
    else if (![bubble.semanticId isEqualToString:@"U:GoodBye"]) {
        _currentFhBubble = nil;
    }
    _isProcessingUserInput = NO; // when we get here a new bubble is rendered, therefore the UserInput is finished being processed
    [_currentViewState update];
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
        [_appService addUserText:_userTextField.text];
    }
    _userTextField.text = @"";
}

- (IBAction)sharedTouched:(id)sender {
    ConversationBubbleFoodHero *lastSuggestion = [_appService lastRawSuggestion];

    NSString *text;
    if (lastSuggestion != nil) {
        text = [SharingTextBuilder foodHeroSuggested:lastSuggestion.text
                                          restaurant:lastSuggestion.suggestedRestaurant];
    }
    else {
        text = [SharingTextBuilder foodHeroIsCool];
    }

    SharingController *sharingController = [[SharingController alloc] initWithText:text completion:^() {
        [self logScreenViewed];
    }];
    if ( [sharingController respondsToSelector:@selector(popoverPresentationController)] ) {
        sharingController.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:sharingController animated:YES completion:nil];
}


- (void)hideKeyboard {
    [(self.userTextField) resignFirstResponder];
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

    //[_currentUserInputContainerViewController notifyUserWantsTextInput:keyboardHeight animationCurve:animationCurve animationDuration:animationDuration];
    [self setViewState:[ConversationViewStateTextInput create:self heigth:keyboardHeight animationCurve:animationCurve animationDuration:animationDuration]];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_appService getStatementCount] -1 inSection:0];
    [_bubbleView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self setViewState:[ConversationViewStateNormal create:self animationCurve:UIViewAnimationCurveLinear aimationDuration:0]];
    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"helpView"]) {
        HelpViewController *controller = (HelpViewController *) segue.destinationViewController;
        [self initalizeHelpController:controller];
    }
}


- (void)userDidTouchLinkInConversationBubbleWith:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initalizeHelpController:(HelpViewController *)controller {
    [controller setFhUtterance:_currentFhBubble.text expectedUserUtterances:self.expectedUserUtterances delegate:self];
}

- (NSInteger)optimalUserInputListHeight {
    // return _currentUserInputContainerViewController.optimalViewHeight;
    return 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self setDefaultViewState:DEFAULT_ANIMATION_CURVE animationDuration:DEFAULT_ANIMATION_DURATION];
    return NO;
}

- (BOOL)isNotProcessingUserInput {
    return !_isProcessingUserInput;
}

- (void)didStopProcessingUserInput {
    [_currentViewState update];
}

- (void)didStopRecordingUserInput {
    _isRecordingUserInput = NO;
    [_currentViewState update];
}

- (void)didStartProcessingUserInput {
    _isProcessingUserInput = YES;
    [_currentViewState update];
}

- (void)didStartRecordingUserInput {
    _isRecordingUserInput = YES;
    [_currentViewState update];
}

- (BOOL)isNotRecordingUserInput {
    return !_isRecordingUserInput;
}

- (BOOL)isWaitingForUserInput {
    return _currentFhBubble != nil;
}

- (void)userDidSelectUtterance:(NSString *)utterance {
    [self.navigationController popViewControllerAnimated:true];
    self.userTextField.text = utterance;
    [_currentViewState update];

    [self flash:self.userSendButton];
}

- (void)flash:(UIView *)view {
    CGFloat oldAlpha = view.alpha;
    CGFloat minAlpha = 0.2;
    enum UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:.3 delay:0.3 options:options animations:^{
                [UIView setAnimationRepeatCount:4];
                view.alpha = minAlpha;

            }
                     completion:^(BOOL finished) {
                         view.alpha = oldAlpha;
                     }];
}
@end
